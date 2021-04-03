import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../shared/app_colors.dart';
import 'login_view.dart';

class AnonymousTabBarView extends StatefulWidget {
  @override
  AnonymousTabBarState createState() => AnonymousTabBarState();
}

class AnonymousTabBarState extends State<AnonymousTabBarView> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentTabIndex = 0;

  List<Widget> _realPages = [LoginView()];
  List<Widget> _tabPages = [LoginView()];
  List<bool> _hasInit = [true];

  List<Widget> _tabsButton = [Tab(icon: Icon(Icons.person_outline, color: Colors.blue), text: translate('tabs.login'))];

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
    return Scaffold(
      body: IndexedStack(index: _currentTabIndex, children: _tabPages),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          labelColor: primaryAccentColor,
          indicatorColor: Colors.blue,
          indicatorWeight: 3.0,
          tabs: _tabsButton,
          controller: _tabController,
        ),
      ),
    );
  }
}
