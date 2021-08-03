import 'package:aloha/Modelle/Drinks.dart';
import 'package:aloha/Modelle/Week.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import '../Modelle/Drinks.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = Hive.box('Week');
  final settingsBox = Hive.box("settings");
  final ownBox = Hive.box("own");
  final drinkBox = Hive.box("drinks");
  double? plannedForWeek = 0.0, usedThisWeek = 0.0, plannedDay = 0, usedDay = 0;
  bool fastAdd = false;
  late Week currentWeek;

  @override
  void initState() {
    try {
      weekTest();
      print("Current Week: " + box.getAt(box.length - 1).toString());
      currentWeek = box.getAt(box.length - 1);
      plannedDay = currentWeek.plannedDay;
      plannedForWeek = currentWeek.plannedSE;
      usedThisWeek = currentWeek.getSethisWeek();
      usedDay = currentWeek.getUsedDays();
    } catch (e) {
      usedThisWeek = 0;
      usedDay = 0;
      plannedDay = 0;
      plannedForWeek = 0;
    }

    super.initState();
    print("HomePage initialized");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    try {
      weekTest();
      print(box.getAt(box.length - 1).toString());
      currentWeek = box.getAt(box.length - 1);
      plannedDay = currentWeek.plannedDay;
      plannedForWeek = currentWeek.plannedSE;
      usedThisWeek = currentWeek.getSethisWeek();
      usedDay = currentWeek.getUsedDays();
    } catch (e) {
      usedThisWeek = 0;
      usedDay = 0;
      plannedDay = 0;
      plannedForWeek = 0;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.1),
            child: Center(
              child: PlatformText(
                usedDay!.toStringAsPrecision(2) +
                    " / " +
                    plannedDay!.toStringAsPrecision(2) +
                    " Tage \n " +
                    usedThisWeek!.toStringAsPrecision(2) +
                    " / " +
                    plannedForWeek!.toStringAsPrecision(2) +
                    " SE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.07,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          GestureDetector(
            child: Image(
              image: AssetImage('assets/LaunchImage.png'),
              width: width * 0.6,
              height: height * 0.6,
            ),
            onTap: () {
              onTap(false);
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.04),
            child: PlatformElevatedButton(
              child: PlatformText('Schnell', style: TextStyle(color: Colors.black),),
              onPressed: () => onTap(true),
              material: (context, platform) => MaterialElevatedButtonData(style: OutlinedButton.styleFrom(backgroundColor: Colors.yellow)),
              cupertino: (context, platform) => CupertinoElevatedButtonData(color: Colors.yellow),
            ),
          ),
        ],
      ),
    );
  }

  int? getCurrentSession() {
    int? session = 0;
    for (int i = 0; i < drinkBox.length; i++) {
      Drinks current = drinkBox.getAt(i);
      if (current.session! > session!) {
        session = current.session;
      }
    }
    return session;
  }

  /// Returns the value of the ownDrink volumen
  double? checkVolume() {
    double volume = ownBox.get("volumen") + 0.0;
    return volume;
  }

  /// Returns the value of the ownDrink volumenpart
  double? checkVolumePart() {
    double volumePart = ownBox.get("volumenpart") + 0.0;
    return volumePart;
  }

  /// Returns the value of the ownDrink name
  String? getName() {
    String name = ownBox.get("name");
    return name;
  }

  /// Checks if the week planned surpassed and creates a new one
  Future<void> weekTest() async {
    Week currentWeek = box.getAt(box.length - 1);
    int now = DateTime.now().millisecondsSinceEpoch;
    print(DateTime.now().toString() +
        " - " +
        currentWeek.getEndTime().toString());
    while (now > currentWeek.endDate!) {
      print("WeekTest: " +
          DateTime.now().toString() +
          " - " +
          currentWeek.getEndTime().toString());
      DateTime newStartDate = currentWeek.getStartDate().add(Duration(days: 7));
      DateTime newEndDate = newStartDate.add(Duration(
          days: 6,
          hours: 23,
          minutes: 59,
          microseconds: 999,
          milliseconds: 99,
          seconds: 59));
      double days = settingsBox.get("DaysForNextWeek");
      int decrAmount = settingsBox.get("autoDecrAmount");
      double sePlanned = settingsBox.get("SEforNextWeek");
      sePlanned -= decrAmount;
      if (sePlanned < 0) {
        sePlanned = 0;
      }
      Week newWeek = Week(
          plannedDay: days,
          plannedSE: sePlanned,
          week: box.length,
          startdate: newStartDate.millisecondsSinceEpoch,
          endDate: newEndDate.millisecondsSinceEpoch);
      box.add(newWeek);
      settingsBox.put("SEforNextWeek", sePlanned);
      currentWeek = box.getAt(box.length - 1);
      print("New Week Added: " + newWeek.toString());
    }
  }

  void onTap(bool fastAdd) {
    if (!fastAdd) {
      Navigator.of(context).pushNamed('/camera');
    } else {
      try {
        Drinks current = Drinks(
          week: currentWeek.week,
          session: getCurrentSession(),
          name: getName(),
          date: DateTime.now().millisecondsSinceEpoch,
          volume: checkVolume(),
          volumepart: checkVolumePart(),
          uri: null,
        );
        drinkBox.add(current);

        print("Added drink: " + current.toString());
      } catch (e) {
        print("Error saving preset: " + e.toString());
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
