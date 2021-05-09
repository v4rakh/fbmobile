import 'dart:convert';
import 'dart:io';

import '../../locator.dart';
import '../models/rest/config.dart';
import '../models/rest/config_response.dart';
import '../models/rest/history.dart';
import '../models/rest/history_response.dart';
import '../models/rest/uploaded_multi_response.dart';
import '../models/rest/uploaded_response.dart';
import '../services/api.dart';

class FileRepository {
  Api _api = locator<Api>();

  Future<History> getHistory() async {
    var response = await _api.post('/file/history');
    var parsedResponse = HistoryResponse.fromJson(json.decode(response.body));
    return parsedResponse.data;
  }

  Future<Config> getConfig(String url) async {
    _api.setUrl(url);

    var response = await _api.fetch('/file/get_config');
    var parsedResponse = ConfigResponse.fromJson(json.decode(response.body));
    return parsedResponse.data;
  }

  Future<void> postDelete(String id) async {
    await _api.post('/file/delete', fields: {'ids[1]': id});
  }

  Future<UploadedResponse> postUpload(List<File> files, Map<String, String> additionalFiles) async {
    var response = await _api.post('/file/upload', files: files, additionalFiles: additionalFiles);
    return UploadedResponse.fromJson(json.decode(response.body));
  }

  Future<UploadedMultiResponse> postCreateMultiPaste(List<String> ids) async {
    Map<String, String> multiPasteIds = Map();

    ids.forEach((element) {
      multiPasteIds.putIfAbsent("ids[${ids.indexOf(element) + 1}]", () => element);
    });

    var response = await _api.post('/file/create_multipaste', fields: multiPasteIds);
    return UploadedMultiResponse.fromJson(json.decode(response.body));
  }
}
