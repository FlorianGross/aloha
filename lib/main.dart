import 'dart:ui';
import 'package:aloha/Pages/CameraPage.dart';
import 'package:aloha/Pages/SettingsPage.dart';
import 'package:aloha/Week.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Drinks.dart';
import 'LocalNotifyManager.dart';
import 'Pages/FirstStartPage.dart';
import 'Pages/HomePage.dart';
import 'Pages/SessionsPage.dart';
import 'Pages/TimelinePage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  LocalNotifyManager.init();
  tz.initializeTimeZones();
  await setupTimeZone();
  await Hive.initFlutter();
  Hive.registerAdapter(DrinksAdapter());
  Hive.registerAdapter(WeekAdapter());
  await Hive.openBox("drinks");
  await Hive.openBox("settings");
  await Hive.openBox("Week");
  await Hive.openBox("own");
  print("Hive initialized");
  var box = Hive.box("settings");
  if (box.isEmpty) {
    print("Box empty");
    box.put("darkmode", true);
    box.put("audio", true);
    box.put("firstStart", true);
    box.put("notifications", true);
    box.put("firstStartDate", DateTime.now());
    print("Standard settings loaded: " + box.toMap().toString());
  }

  ThemeData theme;
  if (box.get("darkmode")) {
    theme = nightTheme();
    print("Theme - nightTheme");
  } else {
    theme = dayTheme();
    print("Theme - dayTheme");
  }
  var home;
  if (box.get("firstStart")) {
    home = FirstStartPage();
  } else {
    home = MyApp();
  }
  runApp(
    MaterialApp(
      home: home,
      theme: theme,
      routes: <String, WidgetBuilder>{
        '/homePage': (BuildContext context) => new HomePage(),
        '/camera': (BuildContext context) => new Camera(),
        '/settings': (BuildContext context) => new Settings(),
        '/firstStart': (BuildContext context) => new FirstStartPage(),
      },
    ),
  );
}

Future<void> setupTimeZone() async{
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
}


ThemeData dayTheme() {
  return ThemeData(
      fontFamily: "Roboto",
      brightness: Brightness.light,
      primaryColor: Colors.yellow,
      backgroundColor: Colors.yellowAccent,
      accentColor: Colors.yellowAccent);
}

ThemeData nightTheme() {
  return ThemeData(
      fontFamily: "Roboto",
      brightness: Brightness.dark,
      primaryColor: Colors.yellow,
      backgroundColor: Colors.yellowAccent,
      accentColor: Colors.yellowAccent);
}

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
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time,
                color: Theme.of(context).textTheme.bodyText1!.color),
            label: 'Timeline',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.center_focus_strong_rounded,
                color: Theme.of(context).textTheme.bodyText1!.color),
            label: 'Scannen',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: Theme.of(context).textTheme.bodyText1!.color),
            label: 'Woche',
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
