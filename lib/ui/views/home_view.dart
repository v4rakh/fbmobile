import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../core/enums/viewstate.dart';
import '../../core/viewmodels/home_model.dart';
import '../shared/app_colors.dart';
import '../widgets/my_appbar.dart';
import 'base_view.dart';

class HomeView extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      builder: (context, model, child) => Scaffold(
          appBar: MyAppBar(title: Text(translate('app.title'))),
          backgroundColor: backgroundColor,
          body: model.state == ViewState.Busy ? Center(child: CircularProgressIndicator()) : Container()),
    );
  }
}
