import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../core/enums/viewstate.dart';
import '../../core/viewmodels/startup_model.dart';
import '../shared/app_colors.dart';

class StartUpView extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpViewModel>.withConsumer(
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
