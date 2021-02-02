import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';
import 'package:validators/sanitizers.dart';
import 'package:validators/validators.dart';

import '../../core/services/file_service.dart';
import '../../core/services/session_service.dart';
import '../../core/services/storage_service.dart';
import '../../locator.dart';
import '../enums/error_code.dart';
import '../enums/viewstate.dart';
import '../error/rest_service_exception.dart';
import '../error/service_exception.dart';
import '../models/rest/config.dart';
import '../util/logger.dart';
import 'base_model.dart';

class LoginModel extends BaseModel {
  TextEditingController _uriController = new TextEditingController();
  final TextEditingController _apiKeyController = new TextEditingController();

  TextEditingController get uriController => _uriController;

  TextEditingController get apiKeyController => _apiKeyController;

  final SessionService _sessionService = locator<SessionService>();
  final StorageService _storageService = locator<StorageService>();
  final FileService _configService = locator<FileService>();
  final Logger _logger = getLogger();

  String errorMessage;

  void init() async {
    bool hasLastUrl = await _storageService.hasLastUrl();

    if (hasLastUrl) {
      setState(ViewState.Busy);
      var s = await _storageService.retrieveLastUrl();

      if (s.isNotEmpty) {
        _uriController = new TextEditingController(text: s);
      }

      setState(ViewState.Idle);
    }
  }

  Future<bool> login(String url, String apiKey) async {
    setState(ViewState.Busy);

    url = trim(url);

    if (url.isEmpty) {
      errorMessage = translate('login.errors.empty_url');
      setState(ViewState.Idle);
      return false;
    }

    if (!url.contains("https://") && !url.contains("http://")) {
      errorMessage = translate('login.errors.no_protocol');
      setState(ViewState.Idle);
      return false;
    }

    bool validUri = Uri.parse(url).isAbsolute;
    if (!validUri || !isURL(url)) {
      errorMessage = translate('login.errors.invalid_url');
      setState(ViewState.Idle);
      return false;
    }

    if (apiKey.isEmpty) {
      errorMessage = translate('login.errors.empty_apikey');
      setState(ViewState.Idle);
      return false;
    }

    var success = false;
    try {
      Config config = await _configService.getConfig(url);
      success = await _sessionService.login(url, apiKey, config);
      errorMessage = null;
    } catch (e) {
      if (e is RestServiceException) {
        if (e.statusCode == HttpStatus.unauthorized) {
          errorMessage = translate('login.errors.wrong_credentials');
        } else if (e.statusCode != HttpStatus.unauthorized && e.statusCode == HttpStatus.forbidden) {
          errorMessage = translate('login.errors.forbidden');
        } else if (e.statusCode == HttpStatus.notFound) {
          errorMessage = translate('api.incompatible_error_not_found');
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
        setState(ViewState.Idle);
        _logger.e('An unknown error occurred', e);
        throw e;
      }

      if (errorMessage.isNotEmpty) {
        _sessionService.logout();
      }

      setState(ViewState.Idle);
      return success;
    }

    return success;
  }
}
