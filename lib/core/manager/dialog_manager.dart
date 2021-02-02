import 'package:flutter/material.dart';

import '../../locator.dart';
import '../datamodels/dialog_request.dart';
import '../datamodels/dialog_response.dart';
import '../services/dialog_service.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    List<Widget> actions = <Widget>[];

    if (request.buttonTitleDeny != null && request.buttonTitleDeny.isNotEmpty) {
      Widget denyBtn = FlatButton(
        child: Text(request.buttonTitleDeny),
        onPressed: () {
          _dialogService.dialogComplete(DialogResponse(confirmed: false));
        },
      );
      actions.add(denyBtn);
    }

    Widget confirmBtn = FlatButton(
      child: Text(request.buttonTitleAccept),
      onPressed: () {
        _dialogService.dialogComplete(DialogResponse(confirmed: true));
      },
    );
    actions.add(confirmBtn);

    AlertDialog alert = AlertDialog(
      title: Text(request.title),
      content: Text(request.description),
      actions: actions,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
