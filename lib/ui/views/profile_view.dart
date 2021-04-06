import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../core/enums/viewstate.dart';
import '../../core/models/session.dart';
import '../../core/viewmodels/profile_model.dart';
import '../shared/app_colors.dart';
import '../shared/text_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/my_appbar.dart';
import '../widgets/swipe_navigation.dart';
import 'base_view.dart';

class ProfileView extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(
        builder: (context, model, child) => Scaffold(
            appBar: MyAppBar(title: Text(translate('titles.profile'))),
            backgroundColor: backgroundColor,
            body: SwipeNavigation(child: _render(model, context))));
  }

  Widget _render(ProfileModel model, BuildContext context) {
    var url = Provider.of<Session>(context).url;
    var apiKey = Provider.of<Session>(context).apiKey;

    return model.state == ViewState.Busy
        ? Center(child: CircularProgressIndicator())
        : ListView(
            children: <Widget>[
              UIHelper.verticalSpaceMedium(),
              Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Center(
                      child: Text(
                    translate('profile.instance'),
                    style: subHeaderStyle,
                  ))),
              UIHelper.verticalSpaceMedium(),
              Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Center(
                      child: Linkify(
                    onOpen: (link) => model.openLink(link.url),
                    text: translate('profile.connection', args: {'url': url}),
                    options: LinkifyOptions(humanize: false),
                  ))),
              UIHelper.verticalSpaceMedium(),
              Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.settings, color: blueColor),
                      label: Text(
                        translate('profile.show_config'),
                        style: TextStyle(color: buttonForegroundColor),
                      ),
                      onPressed: () {
                        return model.showConfig(url);
                      })),
              UIHelper.verticalSpaceMedium(),
              Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.lock, color: orangeColor),
                      label: Text(
                        translate('profile.reveal_api_key'),
                        style: TextStyle(color: buttonForegroundColor),
                      ),
                      onPressed: () {
                        return model.revealApiKey(apiKey);
                      })),
              UIHelper.verticalSpaceMedium(),
              Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.exit_to_app, color: redColor),
                      label: Text(
                        translate('profile.logout'),
                        style: TextStyle(color: buttonForegroundColor),
                      ),
                      onPressed: () {
                        return model.logout();
                      })),
            ],
          );
  }
}
