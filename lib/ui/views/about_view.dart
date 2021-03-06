import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../core/enums/viewstate.dart';
import '../../core/viewmodels/about_model.dart';
import '../../ui/shared/text_styles.dart';
import '../../ui/shared/ui_helpers.dart';
import '../shared/app_colors.dart';
import '../widgets/my_appbar.dart';
import 'base_view.dart';

class AboutView extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 30.0,
        child: Image.asset('assets/logo_caption.png'),
      ),
    );

    return BaseView<AboutModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
          appBar: MyAppBar(
            title: Text(translate('titles.about')),
            enableAbout: false,
          ),
          backgroundColor: backgroundColor,
          body: model.state == ViewState.Busy
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.all(0),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10, top: 10),
                    children: <Widget>[
                      UIHelper.verticalSpaceMedium(),
                      Center(child: logo),
                      UIHelper.verticalSpaceMedium(),
                      Center(
                          child: Text(
                        translate('about.versions', args: {
                          'appName': model.packageInfo.appName,
                          'packageName': model.packageInfo.packageName,
                          'version': model.packageInfo.version,
                          'buildNumber': model.packageInfo.buildNumber
                        }),
                      )),
                      UIHelper.verticalSpaceMedium(),
                      Center(
                          child: Text(
                        translate('about.description'),
                      )),
                      UIHelper.verticalSpaceMedium(),
                      Center(
                          child: Text(
                        translate('about.faq_headline'),
                        style: subHeaderStyle,
                      )),
                      Center(
                          child: Text(
                        translate(('about.faq')),
                      )),
                      UIHelper.verticalSpaceMedium(),
                      Center(
                          child: Text(
                        translate('about.contact_us'),
                        style: subHeaderStyle,
                      )),
                      UIHelper.verticalSpaceSmall(),
                      Center(
                        child: Linkify(
                          text: translate('about.website'),
                          options: LinkifyOptions(humanize: false),
                          onOpen: (link) => model.openLink(link.url),
                        ),
                      )
                    ],
                  ))),
    );
  }
}
