import 'package:flutter/material.dart';

import '../widgets/about_iconbutton.dart';

class MyAppBar extends AppBar {
  static final List<Widget> aboutEnabledWidgets = [AboutIconButton()];
  static final List<Widget> aboutDisabledWidgets = [];

  MyAppBar({Key key, Widget title, List<Widget> actionWidgets, bool enableAbout = true})
      : super(key: key, title: Row(children: <Widget>[title]), actions: _renderIconButtons(actionWidgets, enableAbout));

  static List<Widget> _renderIconButtons(List<Widget> actionWidgets, bool aboutEnabled) {
    if (actionWidgets == null) {
      actionWidgets = [];
    }

    List<Widget> widgets = [...actionWidgets];

    if (aboutEnabled) {
      widgets.add(AboutIconButton());
    }

    return widgets;
  }
}
