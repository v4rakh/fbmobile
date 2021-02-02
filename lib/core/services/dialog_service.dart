import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../datamodels/dialog_request.dart';
import '../datamodels/dialog_response.dart';

class DialogService {
  GlobalKey<NavigatorState> _dialogNavigationKey = GlobalKey<NavigatorState>();
  Function(DialogRequest) _showDialogListener;
  Completer<DialogResponse> _dialogCompleter;

  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;

  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  Future<DialogResponse> showDialog({
    String title,
    String description,
    String buttonTitleAccept,
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(
        title: title,
        description: description,
        buttonTitleAccept:
            buttonTitleAccept == null || buttonTitleAccept.isEmpty ? translate('dialog.confirm') : buttonTitleAccept));
    return _dialogCompleter.future;
  }

  Future<DialogResponse> showConfirmationDialog(
      {String title, String description, String buttonTitleAccept, String buttonTitleDeny}) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(
        title: title,
        description: description,
        buttonTitleAccept:
            buttonTitleAccept == null || buttonTitleAccept.isEmpty ? translate('dialog.confirm') : buttonTitleAccept,
        buttonTitleDeny:
            buttonTitleDeny == null || buttonTitleDeny.isEmpty ? translate('dialog.cancel') : buttonTitleDeny));
    return _dialogCompleter.future;
  }

  void dialogComplete(DialogResponse response) {
    _dialogNavigationKey.currentState.pop();
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
  }
}
