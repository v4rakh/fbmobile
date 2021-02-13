import 'dart:async';

import '../../locator.dart';
import '../repositories/user_repository.dart';

class UserService {
  final UserRepository _userRepository = locator<UserRepository>();

  Future createApiKey(String url, String username, String password, String accessLevel, String comment) async {
    return await _userRepository.createApiKey(url, username, password, accessLevel, comment);
  }
}
