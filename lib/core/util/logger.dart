import 'package:logger/logger.dart';

void setupLogger(Level level) {
  Logger.level = level;
}

Logger getLogger() {
  return Logger(printer: SimplePrinter(colors: false));
}
