import 'dart:io';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';

import '../../core/services/session_service.dart';
import '../../locator.dart';
import '../enums/error_code.dart';
import '../enums/viewstate.dart';
import '../error/rest_service_exception.dart';
import '../error/service_exception.dart';
import '../models/rest/config.dart';
import '../services/dialog_service.dart';
import '../services/file_service.dart';
import '../services/link_service.dart';
import '../util/formatter_util.dart';
import '../util/logger.dart';
import 'base_model.dart';

class ProfileModel extends BaseModel {
  final SessionService _sessionService = locator<SessionService>();
  final DialogService _dialogService = locator<DialogService>();
  final LinkService _linkService = locator<LinkService>();
  final FileService _fileService = locator<FileService>();
  final Logger _logger = getLogger();

  String errorMessage;

  Future logout() async {
    var dialogResult = await _dialogService.showConfirmationDialog(
        title: translate('logout.title'), description: translate('logout.confirm'));

    if (dialogResult.confirmed) {
      await _sessionService.logout();
    }
  }

  Future revealApiKey(String apiKey) async {
    await _dialogService.showDialog(
        title: translate('profile.revealed_api_key.title'),
        description: translate('profile.revealed_api_key.description', args: {'apiKey': apiKey}));
  }

  Future showConfig(String url) async {
    Config config;
    try {
      config = await _fileService.getConfig(url);
      errorMessage = null;
    } catch (e) {
      if (e is RestServiceException) {
        if (e.statusCode == HttpStatus.unauthorized) {
          errorMessage = translate('login.errors.wrong_credentials');
        } else if (e.statusCode != HttpStatus.unauthorized && e.statusCode == HttpStatus.forbidden) {
          errorMessage = translate('login.errors.forbidden');
        } else if (e.statusCode == HttpStatus.notFound) {
          errorMessage = translate('api.incompatible_error_not_found');
        }
        if (e.statusCode == HttpStatus.badRequest) {
          errorMessage = translate('api.bad_request', args: {'reason': e.responseBody.message});
        } else {
          errorMessage = translate('api.general_rest_error');
        }
      } else if (e is ServiceException && e.code == ErrorCode.SOCKET_ERROR) {
        errorMessage = translate('api.socket_error');
      } else if (e is ServiceException && e.code == ErrorCode.SOCKET_TIMEOUT) {
        errorMessage = translate('api.socket_timeout');
      } else {
        errorMessage = translate('app.unknown_error');
        _sessionService.logout();
        setStateView(ViewState.Idle);
        _logger.e('An unknown error occurred', e);
        throw e;
      }
    }

    if (config != null && errorMessage == null) {
      await _dialogService.showDialog(
          title: translate('profile.shown_config.title'),
          description: translate('profile.shown_config.description', args: {
            'uploadMaxSize': FormatterUtil.formatBytes(config.uploadMaxSize, 2),
            'maxFilesPerRequest': config.maxFilesPerRequest,
            'maxInputVars': config.maxInputVars,
            'requestMaxSize': FormatterUtil.formatBytes(config.requestMaxSize, 2)
          }));
    } else {
      await _dialogService.showDialog(
          title: translate('profile.shown_config.error.title'),
          description: translate('profile.shown_config.error.description', args: {'message': errorMessage}));
    }
  }

  void openLink(String link) {
    _linkService.open(link);
  }
}
