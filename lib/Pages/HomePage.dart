import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

import '../Drinks.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? plannedForWeek = 12.0, usedThisWeek = 0.0;
  int? plannedDay = 0, usedDay = 0;
  final box = Hive.box('drinks');
  final settingsBox = Hive.box("settings");

  @override
  void initState() {
    try {
      usedThisWeek = calculateSE(getCurrentSession());
    } catch (e) {
      usedThisWeek = 0;
    }
    plannedDay = settingsBox.get("consumptionDays");
    plannedForWeek = settingsBox.get("seFirstWeek");

    super.initState();
    print("HomePage initialized");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              "$usedDay / $plannedDay Tage \n $usedThisWeek / $plannedForWeek SE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          InkWell(
            child: Image(
              image: AssetImage('assets/LaunchImage.png'),
              width: 244,
              height: 244,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/camera');
            },
          ),
          Center(
            child: Container(
              child: Text(
                "Drücken sie den Button um zu starten!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  double calculateSE(int? session) {
    double se = 0;
    for (int i = 0; i < box.length; i++) {
      Drinks index = box.getAt(i);
      if (index.session == session) {
        se += index.getSE();
      }
    }
    return se;
  }

  int? getCurrentSession() {
    int? session = 0;
    for (int i = 0; i < box.length; i++) {
      Drinks current = box.getAt(i);
      if (current.session! > session!) {
        session = current.session;
      }
    }
    return session;
  }
}
