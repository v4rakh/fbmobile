import 'dart:async';

import '../enums/refresh_event.dart';

class RefreshService {
  StreamController<RefreshEvent> refreshHistoryController = StreamController<RefreshEvent>();

  void addEvent(RefreshEvent event) {
    if (refreshHistoryController.hasListener) {
      refreshHistoryController.add(event);
    }
  }
}
