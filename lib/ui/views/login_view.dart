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
import '../shared/ui_helpers.dart';
import '../widgets/login_header_apikey.dart';
import '../widgets/login_header_credentials.dart';
import 'base_view.dart';

class LoginView extends StatelessWidget {
  static const routeName = '/login';

  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 36.0,
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
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                children: <Widget>[
                  UIHelper.verticalSpaceMedium(),
                  Center(child: logo),
                  UIHelper.verticalSpaceMedium(),
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
                        ),
                        InkWell(
                          child:
                              Icon(model.useCredentialsLogin ? Icons.person_outline : Icons.vpn_key, color: blueColor),
                          onTap: () {
                            model.toggleLoginMethod();
                          },
                        )
                      ])),
                  UIHelper.verticalSpaceMedium(),
                  model.useCredentialsLogin
                      ? LoginCredentialsHeaders(
                          validationMessage: model.errorMessage,
                          uriController: model.uriController,
                          usernameController: model.userNameController,
                          passwordController: model.passwordController,
                        )
                      : LoginApiKeyHeaders(
                          validationMessage: model.errorMessage,
                          uriController: model.uriController,
                          apiKeyController: model.apiKeyController),
                  UIHelper.verticalSpaceMedium(),
                  ElevatedButton(
                    child: Text(translate('login.button'), style: TextStyle(color: buttonForegroundColor)),
                    onPressed: () async {
                      var loginSuccess = await model.login();
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
