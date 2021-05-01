import 'package:dieBruecke/Pages/SettingsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../Drinks.dart';

class SessionPage extends StatefulWidget {
  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final box = Hive.box('drinks');
  final settingsBox = Hive.box("settings");
  double? planSlider = 0, daySlider = 0;
  int week = 0;
  late int maxWeek;
  late List<int?> weeks;

  @override
  void initState() {
    weeks = generateWeeks();
    maxWeek = weeks.length - 1;
    planSlider = settingsBox.get("seFirstWeek");
    daySlider = 0.0 + settingsBox.get("consumptionDays");
    super.initState();
    print("Sessions initialized");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView(
        children: [
          Card(
            child: Column(
              children: [
                Text(
                  "Week: $week",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.yellow),
                      child: Icon(
                        Icons.arrow_left,
                      ),
                      onPressed: () {
                        setState(() {
                          if (week > 0) {
                            week--;
                          }
                        });
                      },
                    ),
                    Column(
                      children: [
                        Text(
                          "Informations",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.yellow),
                      child: Icon(
                        Icons.arrow_right,
                      ),
                      onPressed: () {
                        setState(() {
                          if (week < maxWeek) {
                            week++;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Planung: \n" + planSlider!.toStringAsPrecision(2),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Slider(
                    activeColor: Colors.yellow,
                    value: planSlider!,
                    min: 0,
                    max: 70,
                    divisions: 70,
                    onChanged: (value) {
                      setState(() {
                        planSlider = value;
                      });
                    },
                  ),
                  Divider(),
                  Text(
                    "Konsumtage: \n" + daySlider!.toStringAsPrecision(1),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Slider(
                    activeColor: Colors.yellow,
                    value: daySlider!,
                    min: 0,
                    max: 7,
                    divisions: 7,
                    onChanged: (value) {
                      setState(() {
                        daySlider = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.settings),
          onPressed: openSettings),
    );
  }

  double calculateSE(int session) {
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

  List<int?> generateWeeks() {
    List<int?> generate = [];
    for (int i = 0; i < box.length; i++) {
      Drinks current = box.getAt(i);
      generate.add(current.week);
    }
    generate = generate.toSet().toList();
    print("Generated Weeks: " + generate.toString());
    return generate;
  }

  void openSettings() {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => Settings()));
  }
}
