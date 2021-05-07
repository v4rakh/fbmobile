import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../core/enums/viewstate.dart';
import '../../core/viewmodels/startup_model.dart';
import '../shared/app_colors.dart';

class StartUpView extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
        viewModelBuilder: () => StartUpViewModel(),
        onModelReady: (model) => model.handleStartUpLogic(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: whiteColor,
            body: model.state == ViewState.Busy
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        CircularProgressIndicator(),
                        (model.stateMessage.isNotEmpty ? Text(model.stateMessage) : Container())
                      ]))
                : Container()));
  }
}
