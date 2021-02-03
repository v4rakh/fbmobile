import 'dart:async';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';
import '../../core/datamodels/dialog_response.dart';
import '../../core/services/dialog_service.dart';
import '../../core/services/stoppable_service.dart';
import '../../core/util/logger.dart';
import '../../locator.dart';
import 'storage_service.dart';

class PermissionService extends StoppableService {
  final Logger _logger = getLogger();
  final DialogService _dialogService = locator<DialogService>();
  final StorageService _storageService = locator<StorageService>();

  Timer _serviceCheckTimer;

  PermissionStatus _permissionStatus;

  bool _permanentlyIgnored = false;
  bool _devicePermissionDialogActive = false;
  bool _ownPermissionDialogActive = false;

  PermissionService() {
    _devicePermissionDialogActive = true;

    Permission.storage.request().then((status) {
      _permissionStatus = status;
      if (PermissionStatus.permanentlyDenied == status) {
        _permanentlyIgnored = true;
      }
    }).whenComplete(() {
      _logger.d('Initial device request permission finished');
      _devicePermissionDialogActive = false;
    });
  }

  Future checkEnabledAndPermission() async {
    if (_permanentlyIgnored) {
      await _storageService.storeStoragePermissionDialogIgnored();
      _permanentlyIgnored = false;
      _logger.d('Set permanently ignored permission request');
      stop();
    }

    if (_devicePermissionDialogActive) {
      _logger.d('Device permission dialog active, skipping');
      return;
    }

    if (_ownPermissionDialogActive) {
      _logger.d('Own permission dialog already active, skipping');
      return;
    }

    var ignoredDialog = await _storageService.hasStoragePermissionDialogIgnored();

    if (ignoredDialog) {
      _logger.d('Permanently ignored permission request, skipping');
      stop();
      return;
    }

    _permissionStatus = await Permission.storage.status;
    if (_permissionStatus != PermissionStatus.granted) {
      if (_permissionStatus == PermissionStatus.permanentlyDenied) {
        await _storageService.storeStoragePermissionDialogIgnored();
        return;
      }

      _ownPermissionDialogActive = true;
      DialogResponse response = await _dialogService.showConfirmationDialog(
          title: translate('permission_service.dialog.title'),
          description: translate('permission_service.dialog.description'),
          buttonTitleAccept: translate('permission_service.dialog.grant'),
          buttonTitleDeny: translate('permission_service.dialog.ignore'));

      if (!response.confirmed) {
        await _storageService.storeStoragePermissionDialogIgnored();
      } else {
        _devicePermissionDialogActive = true;
        Permission.storage.request().then((status) async {
          if (PermissionStatus.permanentlyDenied == status) {
            await _storageService.storeStoragePermissionDialogIgnored();
          }
        }).whenComplete(() {
          _logger.d('Device request permission finished');
          _devicePermissionDialogActive = false;
        });
      }

      _ownPermissionDialogActive = false;
    } else {
      await _storageService.storeStoragePermissionDialogIgnored();
    }
  }

  @override
  Future start() async {
    super.start();
    await checkEnabledAndPermission();

    _serviceCheckTimer =
        Timer.periodic(Duration(milliseconds: Constants.mediaPermissionCheckInterval), (_serviceTimer) async {
      if (!super.serviceStopped) {
        await checkEnabledAndPermission();
      } else {
        _serviceTimer.cancel();
      }
    });
    _logger.d('PermissionService started');
  }

  @override
  void stop() {
    _removeServiceCheckTimer();
    super.stop();
    _logger.d('PermissionService stopped');
  }

  void _removeServiceCheckTimer() {
    if (_serviceCheckTimer != null) {
      _serviceCheckTimer.cancel();
      _serviceCheckTimer = null;
      _logger.d('Removed service check timer');
    }
  }
}
