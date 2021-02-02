import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/session.dart';
import 'tabbar_anonymous.dart';
import 'tabbar_authenticated.dart';

class TabBarContainerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Session currentSession = Provider.of<Session>(context);
    bool isAuthenticated = currentSession != null && currentSession.apiKey.isNotEmpty;

    if (isAuthenticated) {
      return AuthenticatedTabBarView();
    }

    return AnonymousTabBarView();
  }
}
