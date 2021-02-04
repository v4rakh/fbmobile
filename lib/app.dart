import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_translate/localization_provider.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:provider/provider.dart';

import 'core/enums/refresh_event.dart';
import 'core/manager/dialog_manager.dart';
import 'core/manager/lifecycle_manager.dart';
import 'core/models/session.dart';
import 'core/services/dialog_service.dart';
import 'core/services/navigation_service.dart';
import 'core/services/refresh_service.dart';
import 'core/services/session_service.dart';
import 'locator.dart';
import 'ui/app_router.dart';
import 'ui/shared/app_colors.dart';
import 'ui/views/startup_view.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: StreamProvider<RefreshEvent>(
            initialData: null,
            create: (context) => locator<RefreshService>().refreshHistoryController.stream,
            child: StreamProvider<Session>(
              initialData: Session.initial(),
              create: (context) => locator<SessionService>().sessionController.stream,
              child: LifeCycleManager(
                  child: MaterialApp(
                title: translate('app.title'),
                builder: (context, child) => Navigator(
                  key: locator<DialogService>().dialogNavigationKey,
                  onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) => DialogManager(child: child)),
                ),
                theme: ThemeData(
                    brightness: Brightness.light, primarySwatch: primaryAccentColor, primaryColor: primaryAccentColor),
                onGenerateRoute: AppRouter.generateRoute,
                navigatorKey: locator<NavigationService>().navigationKey,
                home: StartUpView(),
                supportedLocales: localizationDelegate.supportedLocales,
                locale: localizationDelegate.currentLocale,
              )),
            )));
  }
}
