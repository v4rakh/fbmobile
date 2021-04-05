import 'dart:async';

import '../enums/refresh_event.dart';

class RefreshService {
  StreamController<RefreshEvent> refreshHistoryController = StreamController<RefreshEvent>.broadcast();

  void addEvent(RefreshEvent event) {
    if (refreshHistoryController.hasListener) {
      refreshHistoryController.add(event);
    }
  }
}
