import 'dart:async';

import '../../locator.dart';
import '../enums/error_code.dart';
import '../error/service_exception.dart';
import '../models/rest/apikeys_response.dart';
import '../models/rest/create_apikey_response.dart';
import '../repositories/user_repository.dart';
import 'file_service.dart';

class UserService {
  final FileService _fileService = locator<FileService>();
  final UserRepository _userRepository = locator<UserRepository>();

  Future<CreateApiKeyResponse> createApiKey(
      String url, String username, String password, String accessLevel, String comment) async {
    return await _userRepository.postApiKey(url, username, password, accessLevel, comment);
  }

  Future<ApiKeysResponse> getApiKeys() async {
    return await _userRepository.getApiKeys();
  }

  /// Use 'getHistory' to check currently used API key to require 'apikey' access level
  Future<void> checkAccessLevelIsAtLeastApiKey() async {
    try {
      await _fileService.getHistory();
    } catch (e) {
      throw new ServiceException(code: ErrorCode.INVALID_API_KEY, message: e.message);
    }
  }
}
