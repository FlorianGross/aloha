import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'Pages/HomePage.dart';
import 'Pages/SessionsPage.dart';
import 'Pages/TimelinePage.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Box settingsBox = Hive.box("settings");
  int _currentIndex = 1;
  final tabs = [
    Center(
      child: TimelinePage(),
    ),
    Center(
      child: HomePage(),
    ),
    Center(
      child: SessionPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    print("MyApp initialized");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return PlatformScaffold(
      body: tabs[_currentIndex],
      material: (context, platform) => MaterialScaffoldData(),
      cupertino: (context, platform) => CupertinoPageScaffoldData(),
      bottomNavBar: PlatformNavBar(
        material: (context, platform) => MaterialNavBarData(
          enableFeedback: true,
          iconSize: height * 0.05,
          selectedLabelStyle: TextStyle(fontSize: width * 0.03),
          unselectedLabelStyle: TextStyle(fontSize: width * 0.03),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
        ),
        cupertino: (context, platform) => CupertinoTabBarData(
          iconSize: height * 0.04,
          activeColor: Theme.of(context).primaryColor,
          currentIndex: _currentIndex,
        ),
        items: [
          BottomNavigationBarItem(
            label: "Timeline",
            icon: Icon(PlatformIcons(context).time,
                color: Theme.of(context).primaryColor),
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(PlatformIcons(context).home,
                color: Theme.of(context).primaryColor),
          ),
          BottomNavigationBarItem(
            label: "Woche",
            icon: Icon(PlatformIcons(context).person,
                color: Theme.of(context).primaryColor),
          ),
        ],
        itemChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
