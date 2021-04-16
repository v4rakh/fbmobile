import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../../locator.dart';
import '../enums/error_code.dart';
import '../enums/refresh_event.dart';
import '../enums/viewstate.dart';
import '../error/rest_service_exception.dart';
import '../error/service_exception.dart';
import '../models/rest/rest_error.dart';
import '../models/rest/uploaded_multi_response.dart';
import '../models/rest/uploaded_response.dart';
import '../services/file_service.dart';
import '../services/link_service.dart';
import '../services/refresh_service.dart';
import '../util/logger.dart';
import '../util/paste_util.dart';
import 'base_model.dart';

class UploadModel extends BaseModel {
  final Logger _logger = getLogger();
  final FileService _fileService = locator<FileService>();
  final LinkService _linkService = locator<LinkService>();
  final RefreshService _refreshService = locator<RefreshService>();

  TextEditingController _pasteTextController = TextEditingController();
  bool pasteTextTouched = false;

  StreamSubscription _intentDataStreamSubscription;

  bool createMulti = false;
  String fileName;
  List<PlatformFile> paths;
  String _extension;
  bool loadingPath = false;
  String errorMessage;

  TextEditingController get pasteTextController => _pasteTextController;

  void init() {
    _pasteTextController.addListener(() {
      pasteTextTouched = pasteTextController.text.isNotEmpty;
      setStateValue("PASTE_TEXT_TOUCHED", pasteTextTouched);
    });

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value != null && value.length > 0) {
        setStateView(ViewState.Busy);
        paths = value.map((sharedFile) {
          return PlatformFile.fromMap({
            'path': sharedFile.path,
            'name': basename(sharedFile.path),
            'size': File(sharedFile.path).lengthSync(),
            'bytes': null
          });
        }).toList();
        setStateView(ViewState.Idle);
      }
    }, onError: (err) {
      setStateView(ViewState.Busy);
      errorMessage = translate('upload.retrieval_intent');
      _logger.e('Error while retrieving shared data: $err');
      setStateView(ViewState.Idle);
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value != null && value.length > 0) {
        setStateView(ViewState.Busy);
        paths = value.map((sharedFile) {
          return PlatformFile.fromMap({
            'path': sharedFile.path,
            'name': basename(sharedFile.path),
            'size': File(sharedFile.path).lengthSync(),
            'bytes': null
          });
        }).toList();
        setStateView(ViewState.Idle);
      }
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value != null && value.isNotEmpty) {
        setStateView(ViewState.Busy);
        pasteTextController.text = value;
        setStateView(ViewState.Idle);
      }
    }, onError: (err) {
      setStateView(ViewState.Busy);
      errorMessage = translate('upload.retrieval_intent');
      _logger.e('Error while retrieving shared data: $err');
      setStateView(ViewState.Idle);
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value != null && value.isNotEmpty) {
        setStateView(ViewState.Busy);
        pasteTextController.text = value;
        setStateView(ViewState.Idle);
      }
    });
  }

  String generatePasteLinks(Map<String, bool> uploads, String url) {
    if (uploads != null && uploads.length > 0) {
      var links = '';

      uploads.forEach((id, isMulti) {
        if (isMulti && createMulti || !isMulti && !createMulti) {
          links += '${PasteUtil.generateLink(url, id)}\n';
        }
      });

      return links;
    }

    return null;
  }

  void toggleCreateMulti() {
    setStateView(ViewState.Busy);
    createMulti = !createMulti;
    setStateView(ViewState.Idle);
  }

  void openFileExplorer() async {
    setStateView(ViewState.Busy);
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
    setStateView(ViewState.Idle);
  }

  void clearCachedFiles() async {
    setStateView(ViewState.Busy);
    await FilePicker.platform.clearTemporaryFiles();
    paths = null;
    fileName = null;
    errorMessage = null;
    setStateView(ViewState.Idle);
  }

  Future<Map<String, bool>> upload() async {
    setStateView(ViewState.Busy);
    setStateMessage(translate('upload.uploading_now'));

    Map<String, bool> uploadedPasteIds = new Map();
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
      response.data.ids.forEach((element) {
        uploadedPasteIds.putIfAbsent(element, () => false);
      });

      if (createMulti && response.data.ids.length > 1) {
        UploadedMultiResponse multiResponse = await _fileService.createMulti(response.data.ids);
        uploadedPasteIds.putIfAbsent(multiResponse.data.urlId, () => true);
      }

      clearCachedFiles();
      _pasteTextController.clear();
      _refreshService.addEvent(RefreshEvent.RefreshHistory);
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
        setStateView(ViewState.Idle);
        _logger.e('An unknown error occurred', e);
        throw e;
      }
    }

    setStateMessage(null);
    setStateView(ViewState.Idle);
    return null;
  }

  void openLink(String link) {
    _linkService.open(link);
  }

  @override
  void dispose() {
    _pasteTextController.dispose();
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
}
