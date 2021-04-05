import 'package:clipboard/clipboard.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../core/enums/viewstate.dart';
import '../../core/models/session.dart';
import '../../core/util/formatter_util.dart';
import '../../core/viewmodels/history_model.dart';
import '../../ui/widgets/centered_error_row.dart';
import '../shared/app_colors.dart';
import '../widgets/my_appbar.dart';
import 'base_view.dart';

class HistoryView extends StatelessWidget {
  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    var url = Provider.of<Session>(context).url;

    return BaseView<HistoryModel>(
      onModelReady: (model) {
        model.init();
        return model.getHistory();
      },
      builder: (context, model, child) => Scaffold(
          appBar: MyAppBar(title: Text(translate('titles.history'))),
          backgroundColor: backgroundColor,
          body: model.state == ViewState.Busy
              ? Center(child: CircularProgressIndicator())
              : (model.errorMessage == null
                  ? Container(
                      padding: EdgeInsets.all(0),
                      child: RefreshIndicator(onRefresh: () => model.getHistory(), child: _render(model, url, context)))
                  : Container(
                      padding: EdgeInsets.all(25),
                      child: CenteredErrorRow(
                        model.errorMessage,
                        retryCallback: () => model.getHistory(),
                      )))),
    );
  }

  Widget _render(HistoryModel model, String url, BuildContext context) {
    List<Widget> cards = [];

    if (model.pastes.length > 0) {
      model.pastes.reversed.forEach((paste) {
        List<Widget> widgets = [];

        var fullPasteUrl = '$url/${paste.id}';
        var openInBrowserButton = _renderOpenInBrowser(model, fullPasteUrl);

        var dateWidget = ListTile(
          title: Text(FormatterUtil.formatEpoch(paste.date.millisecondsSinceEpoch)),
          subtitle: Text(translate('history.date')),
        );

        var linkWidget = ListTile(
          title: Text(translate('history.open_link')),
          trailing: openInBrowserButton,
        );

        var copyWidget = ListTile(
            title: Text(translate('history.copy_link.description')),
            trailing: IconButton(
                icon: Icon(Icons.copy, color: blueColor, textDirection: TextDirection.ltr),
                onPressed: () {
                  FlutterClipboard.copy(fullPasteUrl).then((value) {
                    final snackBar = SnackBar(
                      action: SnackBarAction(
                        label: translate('history.copy_link.dismiss'),
                        textColor: blueColor,
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                      content: Text(translate('history.copy_link.copied')),
                      duration: Duration(seconds: 10),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }));

        var deleteWidget = ListTile(
            title: Text(translate('history.delete')),
            trailing: IconButton(
                icon: Icon(Icons.delete, color: redColor),
                onPressed: () {
                  return model.deletePaste(paste.id);
                }));

        if (!paste.isMulti) {
          var titleWidget = ListTile(
            title: Text(paste.filename ?? paste.id),
            subtitle: Text(translate('history.filename')),
          );
          var fileSizeWidget = ListTile(
            title: Text(FormatterUtil.formatBytes(paste.filesize, 2)),
            subtitle: Text(translate('history.filesize')),
          );
          var idWidget = ListTile(
            title: Text(paste.id),
            subtitle: Text(translate('history.id')),
          );
          var mimeTypeWidget = ListTile(
            title: Text(paste.mimetype),
            subtitle: Text(translate('history.mimetype')),
          );

          widgets.add(titleWidget);
          widgets.add(idWidget);
          widgets.add(fileSizeWidget);
          widgets.add(mimeTypeWidget);
        } else {
          paste.items.forEach((element) {
            widgets.add(ListTile(
              title: Text(element),
              subtitle: Text(translate('history.multipaste_element')),
              trailing: _renderOpenInBrowser(model, '$url/$element'),
            ));
          });
        }

        widgets.add(dateWidget);
        widgets.add(linkWidget);
        widgets.add(copyWidget);
        widgets.add(deleteWidget);

        var expandable = ExpandableTheme(
          data: ExpandableThemeData(
              iconPlacement: ExpandablePanelIconPlacement.right,
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              hasIcon: true,
              iconColor: blueColor,
              tapHeaderToExpand: true),
          child: ExpandablePanel(
            header: InkWell(
                onLongPress: () => model.deletePaste(paste.id),
                child: Text(
                  paste.id,
                  style: TextStyle(color: blueColor),
                  textAlign: TextAlign.left,
                )),
            expanded: Column(
              mainAxisSize: MainAxisSize.min,
              children: widgets,
            ),
          ),
        );

        cards.add(Card(
          child: ListTile(
            title: expandable,
            trailing: Wrap(children: [
              openInBrowserButton,
              IconButton(
                  icon: Icon(Icons.share, color: blueColor, textDirection: TextDirection.ltr),
                  onPressed: () {
                    return Share.share(fullPasteUrl);
                  })
            ]),
            subtitle: Text(!paste.isMulti ? paste.filename : '', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        ));
      });
    } else {
      cards.add(Card(
        child: ListTile(
          title: Text(translate('history.no_items')),
        ),
      ));
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: cards,
      physics: AlwaysScrollableScrollPhysics(),
    );
  }

  Widget _renderOpenInBrowser(HistoryModel model, String url) {
    return IconButton(
        icon: Icon(Icons.open_in_new, color: blueColor, textDirection: TextDirection.ltr),
        onPressed: () {
          return model.openLink(url);
        });
  }
}
