import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/app_colors.dart';

class CenteredErrorRow extends StatelessWidget {
  final Function retryCallback;
  final String message;

  CenteredErrorRow(this.message, {this.retryCallback});

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return Container();
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Center(child: Text(message, style: TextStyle(color: Colors.red)))),
          ],
        ),
        (retryCallback != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    Center(
                        child: IconButton(
                      icon: Icon(Icons.refresh),
                      color: primaryAccentColor,
                      onPressed: () {
                        retryCallback();
                      },
                    ))
                  ])
            : Container())
      ],
    );
  }
}
