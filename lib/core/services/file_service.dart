import 'dart:async';
import 'dart:io';

import '../../core/repositories/file_repository.dart';
import '../../locator.dart';

class FileService {
  final FileRepository _fileRepository = locator<FileRepository>();

  Future getConfig(String url) async {
    return await _fileRepository.getConfig(url);
  }

  Future getHistory() async {
    return await _fileRepository.getHistory();
  }

  Future deletePaste(String id) async {
    return await _fileRepository.delete(id);
  }

  Future upload(List<File> files, Map<String, String> additionalFiles) async {
    return await _fileRepository.upload(files, additionalFiles);
  }

  Future createMulti(List<String> ids) async {
    return await _fileRepository.createMulti(ids);
  }
}
