import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';

import '../../core/enums/swipe_event.dart';
import '../../core/services/swipe_service.dart';
import '../../core/util/logger.dart';
import '../../locator.dart';
import '../shared/app_colors.dart';
import 'history_view.dart';
import 'profile_view.dart';
import 'upload_view.dart';

class AuthenticatedTabBarView extends StatefulWidget {
  @override
  AuthenticatedTabBarState createState() => AuthenticatedTabBarState();
}

class AuthenticatedTabBarState extends State<AuthenticatedTabBarView> with SingleTickerProviderStateMixin {
  final Logger _logger = getLogger();
  final SwipeService _swipeService = locator<SwipeService>();

  StreamSubscription _swipeEventSubscription;
  TabController _tabController;
  int _currentTabIndex = 0;

  List<Widget> _realPages = [UploadView(), HistoryView(), ProfileView()];
  List<Widget> _tabPages = [
    UploadView(),
    Container(),
    Container(),
  ];
  List<bool> _hasInit = [true, false, false];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _realPages.length, vsync: this)
      ..addListener(() {
        int selectedIndex = _tabController.index;
        if (_currentTabIndex != selectedIndex) {
          if (!_hasInit[selectedIndex]) {
            _tabPages[selectedIndex] = _realPages[selectedIndex];
            _hasInit[selectedIndex] = true;
          }
          setState(() => _currentTabIndex = selectedIndex);
        }
      });

    _swipeEventSubscription = _swipeService.swipeEventController.stream.listen((SwipeEvent event) {
      _logger.d('Received a swipe event for the authenticated tab bar: $event');

      int targetIndex = _currentTabIndex;
      if (SwipeEvent.Left == event) {
        targetIndex = min(_currentTabIndex + 1, _realPages.length - 1);
      }

      if (SwipeEvent.Right == event) {
        targetIndex = max(_currentTabIndex - 1, 0);
      }

      if (SwipeEvent.Start == event) {
        targetIndex = 0;
      }

      if (SwipeEvent.End == event) {
        targetIndex = _tabPages.length - 1;
      }

      _logger.d("Changing to tab '$targetIndex' because of a swipe event '$event'");
      _tabController.animateTo(targetIndex);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _swipeEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double yourWidth = width / 3;
    double yourHeight = 55;

    Color colorTabItem0 = _currentTabIndex == 0 ? blueColor : primaryAccentColor;
    Color colorTabItem1 = _currentTabIndex == 1 ? blueColor : primaryAccentColor;
    Color colorTabItem2 = _currentTabIndex == 2 ? blueColor : primaryAccentColor;

    List<Widget> _tabsButton = [
      Container(
        width: yourWidth,
        height: yourHeight,
        alignment: Alignment.center,
        child: Tab(
          icon: Icon(
            _currentTabIndex == 0 ? Icons.upload_outlined : Icons.upload_rounded,
            color: colorTabItem0,
          ),
          child: Text(translate('tabs.upload'), style: TextStyle(color: colorTabItem0)),
        ),
      ),
      Container(
        width: yourWidth,
        height: yourHeight,
        alignment: Alignment.center,
        child: Tab(
          icon: Icon(
            _currentTabIndex == 1 ? Icons.history_outlined : Icons.history_rounded,
            color: colorTabItem1,
          ),
          child: Text(translate('tabs.history'), style: TextStyle(color: colorTabItem1)),
        ),
      ),
      Container(
        width: yourWidth,
        height: yourHeight,
        alignment: Alignment.center,
        child: Tab(
          icon: Icon(
            _currentTabIndex == 2 ? Icons.person_outlined : Icons.person_rounded,
            color: colorTabItem2,
          ),
          child: Text(translate('tabs.profile'), style: TextStyle(color: colorTabItem2)),
        ),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentTabIndex, children: _tabPages),
      bottomNavigationBar: BottomAppBar(
          child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: primaryAccentColor,
        indicatorColor: blueColor,
        indicatorWeight: 3.0,
        labelPadding: EdgeInsets.all(0),
        tabs: _tabsButton,
        isScrollable: true,
        controller: _tabController,
      )),
    );
  }
}
