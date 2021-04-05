import 'dart:async';

import 'package:logger/logger.dart';

import '../../core/services/stoppable_service.dart';
import '../../locator.dart';
import '../models/session.dart';
import '../services/storage_service.dart';
import '../util/logger.dart';
import 'api.dart';

class SessionService extends StoppableService {
  final Logger _logger = getLogger();
  final StorageService _storageService = locator<StorageService>();
  final Api _api = locator<Api>();

  StreamController<Session> sessionController = StreamController<Session>();

  void setApiConfig(String url, String apiKey) {
    _logger.d('Setting API config for session');
    _api.setUrl(url);
    _api.addApiKeyAuthorization(apiKey);
  }

  void unsetApiConfig() {
    _logger.d('Removing API config');
    _api.removeApiKeyAuthorization();
    _api.removeUrl();
  }

  Future<bool> login(String url, String apiKey) async {
    setApiConfig(url, apiKey);

    var session = new Session(url: url, apiKey: apiKey);
    sessionController.add(session);
    await _storageService.storeSession(session);
    _logger.d('Session created');
    return true;
  }

  Future<bool> logout() async {
    unsetApiConfig();
    sessionController.add(null);
    _logger.d('Session destroyed');
    return await _storageService.removeSession();
  }

  Future restoreSession() async {
    bool hasSession = await _storageService.hasSession();

    if (hasSession) {
      Session session = await _storageService.retrieveSession();

      _api.setUrl(session.url);
      _api.addApiKeyAuthorization(session.apiKey);

      sessionController.add(session);
      _logger.d('Session restored');
    }
  }

  @override
  Future start() async {
    super.start();
    await restoreSession();
    _logger.d('SessionService started');
  }

  @override
  void stop() {
    super.stop();
    _logger.d('SessionService stopped');
  }
}
