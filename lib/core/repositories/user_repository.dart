import 'dart:convert';

import '../../locator.dart';
import '../models/rest/apikeys_response.dart';
import '../models/rest/create_apikey_response.dart';
import '../services/api.dart';

class UserRepository {
  Api _api = locator<Api>();

  Future<CreateApiKeyResponse> postApiKey(
      String url, String username, String password, String accessLevel, String comment) async {
    _api.setUrl(url);

    var response = await _api.post('/user/create_apikey',
        fields: {'username': username, 'password': password, 'access_level': accessLevel, 'comment': comment});
    return CreateApiKeyResponse.fromJson(json.decode(response.body));
  }

  Future<ApiKeysResponse> getApiKeys() async {
    var response = await _api.post('/user/apikeys');
    return ApiKeysResponse.fromJson(json.decode(response.body));
  }
}
