import 'package:flutter/material.dart';

import '../../core/services/navigation_service.dart';
import '../../locator.dart';
import '../../ui/views/about_view.dart';
import '../shared/app_colors.dart';

class AboutIconButton extends StatelessWidget {
  AboutIconButton();

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.help),
        color: whiteColor,
        onPressed: () {
          _navigationService.navigateTo(AboutView.routeName);
        });
  }
}
