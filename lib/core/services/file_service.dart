import 'dart:async';
import 'dart:io';

import '../../core/repositories/file_repository.dart';
import '../../locator.dart';
import '../models/rest/config.dart';
import '../models/rest/history.dart';
import '../models/rest/uploaded_multi_response.dart';
import '../models/rest/uploaded_response.dart';

class FileService {
  final FileRepository _fileRepository = locator<FileRepository>();

  Future<Config> getConfig(String url) async {
    return await _fileRepository.getConfig(url);
  }

  Future<History> getHistory() async {
    return await _fileRepository.getHistory();
  }

  Future<void> deletePaste(String id) async {
    return await _fileRepository.postDelete(id);
  }

  Future<UploadedResponse> uploadPaste(List<File> files, Map<String, String> additionalFiles) async {
    return await _fileRepository.postUpload(files, additionalFiles);
  }

  Future<UploadedMultiResponse> uploadMultiPaste(List<String> ids) async {
    return await _fileRepository.postCreateMultiPaste(ids);
  }
}
