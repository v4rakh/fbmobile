import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/session.dart';

class StorageService {
  static const _SESSION_KEY = 'session';
  static const _LAST_URL_KEY = 'last_url';
  static const _STORAGE_PERMISSION_DIALOG_IGNORED = 'storage_permission_ignored';

  Future<bool> storeLastUrl(String url) {
    return _store(_LAST_URL_KEY, url);
  }

  Future<String> retrieveLastUrl() async {
    return await _retrieve(_LAST_URL_KEY);
  }

  Future<bool> hasLastUrl() async {
    return await _exists(_LAST_URL_KEY);
  }

  Future<bool> storeSession(Session session) {
    return _store(_SESSION_KEY, json.encode(session));
  }

  Future<Session> retrieveSession() async {
    var retrieve = await _retrieve(_SESSION_KEY);
    return Session.fromJson(json.decode(retrieve));
  }

  Future<bool> hasSession() {
    return _exists(_SESSION_KEY);
  }

  Future<bool> removeSession() {
    return _remove(_SESSION_KEY);
  }

  Future<bool> storeStoragePermissionDialogIgnored() {
    return _store(_STORAGE_PERMISSION_DIALOG_IGNORED, true.toString());
  }

  Future<bool> hasStoragePermissionDialogIgnored() {
    return _exists(_STORAGE_PERMISSION_DIALOG_IGNORED);
  }

  Future<bool> _exists(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  Future<bool> _remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  Future<String> _retrieve(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> _store(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
