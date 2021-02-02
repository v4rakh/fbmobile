import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../core/enums/viewstate.dart';
import '../../core/services/dialog_service.dart';
import '../../core/services/navigation_service.dart';
import '../../core/viewmodels/login_model.dart';
import '../../locator.dart';
import '../../ui/shared/text_styles.dart';
import '../../ui/views/home_view.dart';
import '../../ui/widgets/my_appbar.dart';
import '../shared/app_colors.dart';
import '../widgets/login_header.dart';
import 'base_view.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 96.0,
        child: Image.asset('assets/logo_caption.png'),
      ),
    );

    return BaseView<LoginModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: MyAppBar(title: Text(translate('titles.login'))),
        backgroundColor: backgroundColor,
        body: model.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  Center(child: logo),
                  Center(
                      child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          children: <Widget>[
                        Text(
                          translate('login.help'),
                          style: subHeaderStyle,
                        ),
                        InkWell(
                          child: Icon(Icons.help, color: buttonBackgroundColor),
                          onTap: () {
                            _dialogService.showDialog(
                                title: translate('login.compatibility_dialog.title'),
                                description: translate('login.compatibility_dialog.body'));
                          },
                        )
                      ])),
                  LoginHeaders(
                    validationMessage: model.errorMessage,
                    uriController: model.uriController,
                    apiKeyController: model.apiKeyController,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.all(12),
                    color: primaryAccentColor,
                    child: Text(translate('login.button'), style: TextStyle(color: buttonForegroundColor)),
                    onPressed: () async {
                      var loginSuccess = await model.login(model.uriController.text, model.apiKeyController.text);
                      if (loginSuccess) {
                        _navigationService.navigateAndReplaceTo(HomeView.routeName);
                      }
                    },
                  )
                ],
              ),
      ),
    );
  }
}
