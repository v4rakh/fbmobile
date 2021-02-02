import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../util/logger.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  final Logger logger = getLogger();

  void pop() {
    logger.d('NavigationService: pop');
    _navigationKey.currentState.pop();
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    logger.d('NavigationService: navigateTo $routeName');
    return _navigationKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateAndReplaceTo(String routeName, {dynamic arguments}) {
    logger.d('NavigationService: navigateAndReplaceTo $routeName');
    return _navigationKey.currentState.pushReplacementNamed(routeName, arguments: arguments);
  }
}
