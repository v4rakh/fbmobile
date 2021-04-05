import 'package:flutter/material.dart';

import '../shared/app_colors.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeHolder;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget prefixIcon;

  LoginTextField(this.controller, this.placeHolder, this.prefixIcon,
      {this.keyboardType = TextInputType.text, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      height: 50.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.0)),
      child: TextFormField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => controller.clear(),
              icon: Icon(Icons.clear),
            ),
            prefixIcon: prefixIcon,
            hintText: placeHolder,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          controller: controller),
    );
  }
}
