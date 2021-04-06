import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../../core/enums/swipe_event.dart';
import '../../core/services/swipe_service.dart';
import '../../locator.dart';

class SwipeNavigation extends StatefulWidget {
  /// Widget to be augmented with gesture detection.
  final Widget child;

  /// Creates a [SwipeNavigation] widget.
  const SwipeNavigation({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  _SwipeNavigationState createState() => _SwipeNavigationState();
}

class _SwipeNavigationState extends State<SwipeNavigation> {
  final SwipeService _swipeService = locator<SwipeService>();

  void _onHorizontalSwipe(SwipeDirection direction) {
    if (direction == SwipeDirection.left) {
      _swipeService.addEvent(SwipeEvent.Left);
    } else {
      _swipeService.addEvent(SwipeEvent.Right);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleGestureDetector(onHorizontalSwipe: _onHorizontalSwipe, child: widget.child);
  }
}
