import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';

import '../../locator.dart';
import '../enums/error_code.dart';
import '../enums/viewstate.dart';
import '../error/rest_service_exception.dart';
import '../error/service_exception.dart';
import '../models/rest/rest_error.dart';
import '../models/rest/uploaded_multi_response.dart';
import '../models/rest/uploaded_response.dart';
import '../services/file_service.dart';
import '../util/logger.dart';
import 'base_model.dart';

class UploadModel extends BaseModel {
  final Logger _logger = getLogger();
  final FileService _fileService = locator<FileService>();
  TextEditingController _pasteTextController = TextEditingController();
  bool createMulti = false;

  String fileName;
  List<PlatformFile> paths;
  String _extension;
  bool loadingPath = false;
  String errorMessage;

  TextEditingController get pasteTextController => _pasteTextController;

  void toggleCreateMulti() {
    setState(ViewState.Busy);
    createMulti = !createMulti;
    setState(ViewState.Idle);
  }

  void openFileExplorer() async {
    setState(ViewState.Busy);
    setStateMessage(translate('upload.file_explorer_open'));
    loadingPath = true;

    try {
      paths = (await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
        withData: false,
        withReadStream: true,
        allowedExtensions: (_extension?.isNotEmpty ?? false) ? _extension?.replaceAll(' ', '')?.split(',') : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logger.e('Unsupported operation', e);
    } catch (ex) {
      _logger.e('An unknown error occurred', ex);
    }

    loadingPath = false;
    fileName = paths != null ? paths.map((e) => e.name).toString() : '...';

    setStateMessage(null);
    setState(ViewState.Idle);
  }

  void clearCachedFiles() async {
    setState(ViewState.Busy);
    await FilePicker.platform.clearTemporaryFiles();
    paths = null;
    fileName = null;
    errorMessage = null;
    setState(ViewState.Idle);
  }

  Future<List<String>> upload() async {
    setState(ViewState.Busy);
    setStateMessage(translate('upload.uploading_now'));

    List<String> uploadedPasteIds = [];
    try {
      List<File> files;
      Map<String, String> additionalFiles;

      if (pasteTextController.text != null && pasteTextController.text.isNotEmpty) {
        additionalFiles = Map.from(
            {'paste-${(new DateTime.now().millisecondsSinceEpoch / 1000).round()}.txt': pasteTextController.text});
      }

      if (paths != null && paths.length > 0) {
        files = paths.map((e) => new File(e.path)).toList();
      }

      UploadedResponse response = await _fileService.upload(files, additionalFiles);
      uploadedPasteIds.addAll(response.data.ids);

      if (createMulti && response.data.ids.length > 1) {
        UploadedMultiResponse multiResponse = await _fileService.createMulti(response.data.ids);
        uploadedPasteIds.add(multiResponse.data.urlId);
      }

      clearCachedFiles();
      _pasteTextController.clear();
      errorMessage = null;
      return uploadedPasteIds;
    } catch (e) {
      if (e is RestServiceException) {
        if (e.statusCode == HttpStatus.notFound) {
          errorMessage = translate('upload.errors.not_found');
        } else if (e.statusCode == HttpStatus.forbidden) {
          errorMessage = translate('api.forbidden');
        } else if (e.statusCode != HttpStatus.notFound &&
            e.statusCode != HttpStatus.forbidden &&
            e.responseBody is RestError &&
            e.responseBody.message != null) {
          if (e.statusCode == HttpStatus.badRequest) {
            errorMessage = translate('api.bad_request', args: {'reason': e.responseBody.message});
          } else {
            errorMessage = translate('api.general_rest_error_payload', args: {'message': e.responseBody.message});
          }
        } else {
          errorMessage = translate('api.general_rest_error');
        }
      } else if (e is ServiceException && e.code == ErrorCode.SOCKET_ERROR) {
        errorMessage = translate('api.socket_error');
      } else if (e is ServiceException && e.code == ErrorCode.SOCKET_TIMEOUT) {
        errorMessage = translate('api.socket_timeout');
      } else {
        errorMessage = translate('app.unknown_error');
        setStateMessage(null);
        setState(ViewState.Idle);
        _logger.e('An unknown error occurred', e);
        throw e;
      }
    }

    setStateMessage(null);
    setState(ViewState.Idle);
    return null;
  }

  @override
  void dispose() {
    _pasteTextController.dispose();
    super.dispose();
  }
}
