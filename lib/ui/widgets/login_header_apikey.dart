import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../shared/app_colors.dart';
import 'login_text_field.dart';

class LoginApiKeyHeaders extends StatelessWidget {
  final TextEditingController uriController;
  final TextEditingController apiKeyController;

  final String validationMessage;

  LoginApiKeyHeaders({@required this.uriController, @required this.apiKeyController, this.validationMessage});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      this.validationMessage != null ? Text(validationMessage, style: TextStyle(color: redColor)) : Container(),
      LoginTextField(uriController, translate('login.url_placeholder'), Icon(Icons.link),
          keyboardType: TextInputType.url),
      LoginTextField(
        apiKeyController,
        translate('login.apikey_placeholder'),
        Icon(Icons.vpn_key),
        obscureText: true,
      ),
    ]);
  }
}
