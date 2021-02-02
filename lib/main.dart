import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'core/util/logger.dart';
import 'locator.dart';

/// main entry point used to configure log level, locales, ...
void main() async {
  setupLogger(Level.info);
//  setupLogger(Level.debug);
  setupLocator();

  var delegate = await LocalizationDelegate.create(fallbackLocale: 'en', supportedLocales: ['en']);

  runApp(LocalizedApp(delegate, MyApp()));
}
