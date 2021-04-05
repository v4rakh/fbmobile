import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../shared/app_colors.dart';
import 'login_text_field.dart';

class LoginCredentialsHeaders extends StatelessWidget {
  final TextEditingController uriController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  final String validationMessage;

  LoginCredentialsHeaders(
      {@required this.uriController,
      @required this.usernameController,
      @required this.passwordController,
      this.validationMessage});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      this.validationMessage != null ? Text(validationMessage, style: TextStyle(color: redColor)) : Container(),
      LoginTextField(uriController, translate('login.url_placeholder'), Icon(Icons.link),
          keyboardType: TextInputType.url),
      LoginTextField(usernameController, translate('login.username_placeholder'), Icon(Icons.person),
          keyboardType: TextInputType.name),
      LoginTextField(passwordController, translate('login.password_placeholder'), Icon(Icons.vpn_key),
          obscureText: true),
    ]);
  }
}
