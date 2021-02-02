import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../core/services/session_service.dart';
import '../../locator.dart';
import '../services/stoppable_service.dart';
import '../util/logger.dart';

/// Stop and start long running services
class LifeCycleManager extends StatefulWidget {
  final Widget child;

  LifeCycleManager({Key key, this.child}) : super(key: key);

  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {
  final Logger logger = getLogger();

  List<StoppableService> servicesToManage = [locator<SessionService>()];

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.d('LifeCycle event ${state.toString()}');
    super.didChangeAppLifecycleState(state);

    servicesToManage.forEach((service) {
      if (state == AppLifecycleState.resumed) {
        service.start();
      } else {
        service.stop();
      }
    });
  }
}
