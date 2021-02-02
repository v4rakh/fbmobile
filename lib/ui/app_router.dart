import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../ui/views/tabbar_container_view.dart';
import 'views/about_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';
import 'views/profile_view.dart';
import 'views/startup_view.dart';

const String initialRoute = "login";

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case StartUpView.routeName:
        return MaterialPageRoute(builder: (_) => StartUpView());
      case AboutView.routeName:
        return MaterialPageRoute(builder: (_) => AboutView());
      case HomeView.routeName:
        return MaterialPageRoute(builder: (_) => TabBarContainerView());
      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => LoginView());
      case ProfileView.routeName:
        return MaterialPageRoute(builder: (_) => ProfileView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text(translate('dev.no_route', args: {'route': settings.name})),
                  ),
                ));
    }
  }
}
