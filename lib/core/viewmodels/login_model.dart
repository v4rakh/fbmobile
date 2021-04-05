import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';
import 'package:validators/sanitizers.dart';
import 'package:validators/validators.dart';

import '../../core/services/session_service.dart';
import '../../core/services/storage_service.dart';
import '../../locator.dart';
import '../enums/error_code.dart';
import '../enums/viewstate.dart';
import '../error/rest_service_exception.dart';
import '../error/service_exception.dart';
import '../models/rest/create_apikey_response.dart';
import '../services/user_service.dart';
import '../util/logger.dart';
import 'base_model.dart';

class LoginModel extends BaseModel {
  TextEditingController _uriController = new TextEditingController();

  final TextEditingController _userNameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  final TextEditingController _apiKeyController = new TextEditingController();

  TextEditingController get uriController => _uriController;

  TextEditingController get userNameController => _userNameController;

  TextEditingController get passwordController => _passwordController;

  TextEditingController get apiKeyController => _apiKeyController;

  final SessionService _sessionService = locator<SessionService>();
  final StorageService _storageService = locator<StorageService>();
  final UserService _userService = locator<UserService>();
  final Logger _logger = getLogger();

  bool useCredentialsLogin = true;
  String errorMessage;

  void toggleLoginMethod() {
    setState(ViewState.Busy);
    useCredentialsLogin = !useCredentialsLogin;
    setState(ViewState.Idle);
  }

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

  Future<bool> login() async {
    var url = uriController.text;
    var username = userNameController.text;
    var password = passwordController.text;
    var apiKey = apiKeyController.text;

    setState(ViewState.Busy);
    url = trim(url);
    username = trim(username);

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

    if (useCredentialsLogin) {
      if (username.isEmpty) {
        errorMessage = translate('login.errors.empty_username');
        setState(ViewState.Idle);
        return false;
      }

      if (password.isEmpty) {
        errorMessage = translate('login.errors.empty_password');
        setState(ViewState.Idle);
        return false;
      }
    } else {
      if (apiKey.isEmpty) {
        errorMessage = translate('login.errors.empty_apikey');
        setState(ViewState.Idle);
        return false;
      }
    }

    var success = false;
    try {
      if (useCredentialsLogin) {
        CreateApiKeyResponse apiKeyResponse = await _userService.createApiKey(
            url, username, password, 'apikey', 'fbmobile-${new DateTime.now().millisecondsSinceEpoch}');
        success = await _sessionService.login(url, apiKeyResponse.data['new_key']);
      } else {
        _sessionService.setApiConfig(url, apiKey);
        success = await _userService.checkAccessLevelIsAtLeastApiKey();
        success = await _sessionService.login(url, apiKey);
      }
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
      } else if (e is ServiceException && e.code == ErrorCode.INVALID_API_KEY) {
        errorMessage = translate('login.errors.invalid_api_key');
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
