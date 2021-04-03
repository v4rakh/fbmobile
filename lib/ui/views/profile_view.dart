import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../core/enums/viewstate.dart';
import '../../core/models/session.dart';
import '../../core/util/formatter_util.dart';
import '../../core/viewmodels/profile_model.dart';
import '../shared/app_colors.dart';
import '../shared/text_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/my_appbar.dart';
import 'base_view.dart';

class ProfileView extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    var url = Provider.of<Session>(context).url;
    var apiKey = Provider.of<Session>(context).apiKey;
    var config = Provider.of<Session>(context).config;

    return BaseView<ProfileModel>(
      builder: (context, model, child) => Scaffold(
          appBar: MyAppBar(title: Text(translate('titles.profile'))),
          floatingActionButton: FloatingActionButton(
            heroTag: "logoutButton",
            child: Icon(Icons.exit_to_app),
            backgroundColor: primaryAccentColor,
            onPressed: () {
              model.logout();
            },
          ),
          backgroundColor: backgroundColor,
          body: model.state == ViewState.Busy
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: <Widget>[
                    UIHelper.verticalSpaceMedium(),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        translate('profile.welcome'),
                        style: headerStyle,
                      ),
                    ),
                    UIHelper.verticalSpaceMedium(),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Linkify(
                          onOpen: (link) => model.openLink(link.url),
                          text: translate('profile.connection', args: {'url': url}),
                          options: LinkifyOptions(humanize: false),
                        )),
                    UIHelper.verticalSpaceMedium(),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: ElevatedButton.icon(
                            icon: Icon(Icons.remove_red_eye, color: Colors.blue),
                            label: Text(
                              translate('profile.reveal_api_key'),
                              style: TextStyle(color: buttonForegroundColor),
                            ),
                            onPressed: () {
                              return model.revealApiKey(apiKey);
                            })),
                    UIHelper.verticalSpaceMedium(),
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          translate('profile.config', args: {
                            'uploadMaxSize': FormatterUtil.formatBytes(config.uploadMaxSize, 2),
                            'maxFilesPerRequest': config.maxFilesPerRequest,
                            'maxInputVars': config.maxInputVars,
                            'requestMaxSize': FormatterUtil.formatBytes(config.requestMaxSize, 2)
                          }),
                        )),
                  ],
                )),
    );
  }
}
