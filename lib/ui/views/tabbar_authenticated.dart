import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../shared/app_colors.dart';
import 'history_view.dart';
import 'profile_view.dart';
import 'upload_view.dart';

class AuthenticatedTabBarView extends StatefulWidget {
  @override
  AuthenticatedTabBarState createState() => AuthenticatedTabBarState();
}

class AuthenticatedTabBarState extends State<AuthenticatedTabBarView> with SingleTickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double yourWidth = width / 3;
    double yourHeight = 55;

    List<Widget> _tabsButton = [
      Container(
          width: yourWidth,
          height: yourHeight,
          alignment: Alignment.center,
          child: Tab(
              icon: Icon(
                Icons.upload_file,
                color: _currentTabIndex == 0 ? Colors.blue : primaryAccentColor,
              ),
              text: translate('tabs.upload'))),
      Container(
          width: yourWidth,
          height: yourHeight,
          alignment: Alignment.center,
          child: Tab(
              icon: Icon(
                Icons.history,
                color: _currentTabIndex == 1 ? Colors.blue : primaryAccentColor,
              ),
              text: translate('tabs.history'))),
      Container(
          width: yourWidth,
          height: yourHeight,
          alignment: Alignment.center,
          child: Tab(
              icon: Icon(
                Icons.person,
                color: _currentTabIndex == 2 ? Colors.blue : primaryAccentColor,
              ),
              text: translate('tabs.profile'))),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentTabIndex, children: _tabPages),
      bottomNavigationBar: BottomAppBar(
          child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: primaryAccentColor,
        indicatorColor: Colors.blue,
        indicatorWeight: 3.0,
        labelPadding: EdgeInsets.all(0),
        tabs: _tabsButton,
        isScrollable: true,
        controller: _tabController,
      )),
    );
  }
}
