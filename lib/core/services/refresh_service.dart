import 'dart:async';

import '../enums/refresh_event.dart';

class RefreshService {
  StreamController<RefreshEvent> refreshEventController = StreamController<RefreshEvent>.broadcast();

  void addEvent(RefreshEvent event) {
    if (refreshEventController.hasListener) {
      refreshEventController.add(event);
    }
  }
}
