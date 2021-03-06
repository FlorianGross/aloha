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
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        iconSize: height * 0.04,
        selectedLabelStyle: TextStyle(fontSize: width * 0.03),
        unselectedLabelStyle: TextStyle(fontSize: width * 0.03),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Timeline",
            icon: Icon(
              PlatformIcons(context).time,
            ),
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(
              PlatformIcons(context).home,
            ),
          ),
          BottomNavigationBarItem(
            label: "Woche",
            icon: Icon(
              PlatformIcons(context).person,
            ),
          ),
        ],
      ),
    );
  }
}
