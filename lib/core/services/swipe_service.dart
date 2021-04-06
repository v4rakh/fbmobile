import 'dart:async';

import '../enums/swipe_event.dart';

class SwipeService {
  StreamController<SwipeEvent> swipeEventController = StreamController<SwipeEvent>.broadcast();

  void addEvent(SwipeEvent event) {
    if (swipeEventController.hasListener) {
      swipeEventController.add(event);
    }
  }
}
