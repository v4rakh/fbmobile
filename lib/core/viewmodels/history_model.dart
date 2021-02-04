import 'dart:async';
import 'dart:io';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';

import '../../locator.dart';
import '../datamodels/dialog_response.dart';
import '../enums/error_code.dart';
import '../enums/refresh_event.dart';
import '../enums/viewstate.dart';
import '../error/rest_service_exception.dart';
import '../error/service_exception.dart';
import '../models/rest/history.dart';
import '../models/rest/rest_error.dart';
import '../models/uploaded_paste.dart';
import '../services/dialog_service.dart';
import '../services/file_service.dart';
import '../services/link_service.dart';
import '../services/refresh_service.dart';
import '../util/logger.dart';
import 'base_model.dart';

class HistoryModel extends BaseModel {
  final Logger _logger = getLogger();
  final FileService _fileService = locator<FileService>();
  final RefreshService _refreshService = locator<RefreshService>();
  final LinkService _linkService = locator<LinkService>();
  final DialogService _dialogService = locator<DialogService>();

  StreamSubscription _refreshTriggerSubscription;

  List<UploadedPaste> pastes = [];
  String errorMessage;

  void init() {
    this._refreshTriggerSubscription = _refreshService.refreshHistoryController.stream.listen((event) {
      if (event == RefreshEvent.RefreshHistory) {
        _logger.d('History needs a refresh');
        getHistory();
      }
    });
  }

  Future getHistory() async {
    setState(ViewState.Busy);

    try {
      pastes.clear();
      History _history = await _fileService.getHistory();
      if (_history.items != null) {
        _history.items.forEach((key, value) {
          var millisecondsSinceEpoch = int.parse(value.date) * 1000;
          pastes.add(
            UploadedPaste(
                id: key,
                date: DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch),
                filename: value.filename,
                filesize: int.parse(value.filesize),
                hash: value.hash,
                mimetype: value.mimetype,
                isMulti: false,
                items: [],
                thumbnail: value.thumbnail),
          );
        });
      }

      if (_history.multipasteItems != null) {
        _history.multipasteItems.forEach((key, multiPaste) {
          var millisecondsSinceEpoch = int.parse(multiPaste.date) * 1000;
          pastes.add(UploadedPaste(
              id: key,
              date: DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch),
              isMulti: true,
              items: multiPaste.items.entries.map((e) => e.value.id).toList()));
        });
      }

      pastes.sort((a, b) => a.date.compareTo(b.date));
      errorMessage = null;
    } catch (e) {
      if (e is RestServiceException) {
        if (e.statusCode == HttpStatus.notFound) {
          errorMessage = translate('history.errors.not_found');
        } else if (e.statusCode == HttpStatus.forbidden) {
          errorMessage = translate('api.forbidden');
        } else if (e.statusCode != HttpStatus.notFound &&
            e.statusCode != HttpStatus.forbidden &&
            e.responseBody is RestError &&
            e.responseBody.message != null) {
          if (e.statusCode == HttpStatus.badRequest) {
            errorMessage = translate('api.bad_request', args: {'reason': e.responseBody.message});
          } else {
            errorMessage = translate('api.general_rest_error_payload', args: {'message': e.responseBody.message});
          }
        } else {
          errorMessage = translate('api.general_rest_error');
        }
      } else if (e is ServiceException && e.code == ErrorCode.SOCKET_ERROR) {
        errorMessage = translate('api.socket_error');
      } else if (e is ServiceException && e.code == ErrorCode.SOCKET_TIMEOUT) {
        errorMessage = translate('api.socket_timeout');
      } else {
        errorMessage = translate('app.unknown_error');
        setState(ViewState.Idle);
        _logger.e('An unknown error occurred', e);
        throw e;
      }
    }

    setState(ViewState.Idle);
  }

  Future deletePaste(String id) async {
    DialogResponse res = await _dialogService.showConfirmationDialog(
        title: translate('history.delete_dialog.title'),
        description: translate('history.delete_dialog.description', args: {'id': id}),
        buttonTitleAccept: translate('history.delete_dialog.accept'),
        buttonTitleDeny: translate('history.delete_dialog.deny'));

    if (!res.confirmed) {
      return;
    }

    setState(ViewState.Busy);

    try {
      await _fileService.deletePaste(id);
      await getHistory();
      errorMessage = null;
    } catch (e) {
      if (e is RestServiceException) {
        if (e.statusCode == HttpStatus.notFound) {
          errorMessage = translate('project.errors.not_found');
        } else if (e.statusCode == HttpStatus.forbidden) {
          errorMessage = translate('api.forbidden');
        } else if (e.statusCode != HttpStatus.notFound &&
            e.statusCode != HttpStatus.forbidden &&
            e.responseBody is RestError &&
            e.responseBody.message != null) {
          errorMessage = translate('api.general_rest_error_payload', args: {'message': e.responseBody.message});
        } else {
          errorMessage = translate('api.general_rest_error');
        }
      } else if (e is ServiceException && e.code == ErrorCode.SOCKET_ERROR) {
        errorMessage = translate('api.socket_error');
      } else if (e is ServiceException && e.code == ErrorCode.SOCKET_TIMEOUT) {
        errorMessage = translate('api.socket_timeout');
      } else {
        errorMessage = translate('app.unknown_error');
        setState(ViewState.Idle);
        _logger.e('An unknown error occurred', e);
        throw e;
      }
    }

    setState(ViewState.Idle);
  }

  void openLink(String link) {
    _linkService.open(link);
  }

  @override
  void dispose() {
    _refreshTriggerSubscription.cancel();
    super.dispose();
  }
}
