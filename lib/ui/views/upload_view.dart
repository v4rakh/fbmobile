import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../core/enums/viewstate.dart';
import '../../core/viewmodels/upload_model.dart';
import '../shared/app_colors.dart';
import '../widgets/centered_error_row.dart';
import '../widgets/my_appbar.dart';
import 'base_view.dart';

class UploadView extends StatelessWidget {
  static const routeName = '/upload';

  @override
  Widget build(BuildContext context) {
    return BaseView<UploadModel>(
        builder: (context, model, child) => Scaffold(
            appBar: MyAppBar(title: Text(translate('titles.upload'))),
            backgroundColor: backgroundColor,
            body: model.state == ViewState.Busy
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        CircularProgressIndicator(),
                        (model.stateMessage != null && model.stateMessage.isNotEmpty
                            ? Text(model.stateMessage)
                            : Container())
                      ]))
                : ListView(children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: TextFormField(
                                    minLines: 1,
                                    maxLines: 7,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.text_snippet,
                                        color: buttonBackgroundColor,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () => model.pasteTextController.clear(),
                                        icon: Icon(Icons.clear),
                                      ),
                                      hintText: translate('upload.text_to_be_pasted'),
                                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                    ),
                                    controller: model.pasteTextController)),
                            Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    RaisedButton.icon(
                                        icon: Icon(Icons.file_copy_sharp, color: Colors.blue),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        color: primaryAccentColor,
                                        onPressed: () => model.openFileExplorer(),
                                        label: Text(
                                          translate('upload.open_file_explorer'),
                                          style: TextStyle(color: buttonForegroundColor),
                                        )),
                                    RaisedButton.icon(
                                        icon: Icon(Icons.cancel, color: Colors.orange),
                                        onPressed: model.paths != null && model.paths.length > 0
                                            ? () => model.clearCachedFiles()
                                            : null,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        color: primaryAccentColor,
                                        label: Text(
                                          translate('upload.clear_temporary_files'),
                                          style: TextStyle(color: buttonForegroundColor),
                                        )),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      RaisedButton.icon(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          color: primaryAccentColor,
                                          onPressed: () => model.upload(),
                                          icon: Icon(Icons.upload_rounded, color: Colors.green),
                                          label: Text(
                                            translate('upload.upload'),
                                            style: TextStyle(color: buttonForegroundColor),
                                          )),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: model.createMulti,
                                            onChanged: (v) => model.toggleCreateMulti(),
                                          ),
                                          Text(translate('upload.multipaste')),
                                        ],
                                      )
                                    ])),
                            model.errorMessage != null && model.errorMessage.isNotEmpty
                                ? (Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: CenteredErrorRow(model.errorMessage)))
                                : Container(),
                            Builder(
                              builder: (BuildContext context) => model.loadingPath
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: const CircularProgressIndicator(),
                                    )
                                  : model.paths != null
                                      ? Container(
                                          padding: const EdgeInsets.only(bottom: 30.0),
                                          height: MediaQuery.of(context).size.height * 0.50,
                                          child: ListView.separated(
                                            itemCount:
                                                model.paths != null && model.paths.isNotEmpty ? model.paths.length : 1,
                                            itemBuilder: (BuildContext context, int index) {
                                              final bool isMultiPath = model.paths != null && model.paths.isNotEmpty;
                                              final String name = (isMultiPath
                                                  ? model.paths.map((e) => e.name).toList()[index]
                                                  : model.fileName ?? '...');
                                              final path = model.paths.length > 0
                                                  ? model.paths.map((e) => e.path).toList()[index].toString()
                                                  : '';

                                              return Card(
                                                  child: ListTile(
                                                title: Text(
                                                  name,
                                                ),
                                                subtitle: Text(path),
                                              ));
                                            },
                                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                                          ),
                                        )
                                      : Container(),
                            ),
                          ],
                        ))
                  ])));
  }
}
