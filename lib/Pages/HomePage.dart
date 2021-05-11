import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import '../Drinks.dart';
import '../Week.dart';

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
    super.initState();
    print("HomePage initialized");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
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
            },
          ),
          Column(
            children: [
              Text(
                "Schnell:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                width: 80,
                child: Switch(
                    activeColor: Colors.yellow,
                    value: fastAdd,
                    onChanged: (value) {
                      setState(() {
                        fastAdd = value;
                      });
                    }),
              ),
            ],
          ),
          Center(
            child: Container(
              child: Text(
                "Drücken Sie den Button um zu starten!",
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
    DateTime startDate = settingsBox.get("firstStartDate");
    /*
    Difference between now and the general startdate && difference between now and the endtime of the last week
    -> no overlap between weeks and no unnecessary weeks created
    */
    if (DateTime.now().difference(startDate).inDays / 7 >= 1 &&
        DateTime.now().difference(currentWeek.getEndTime()).inMicroseconds >
            0) {
      int tempWeek = DateTime.now().difference(startDate).inDays ~/ 7;
      Week newWeek = new Week(
          plannedDay: currentWeek.plannedDay,
          plannedSE: currentWeek.plannedSE! - settingsBox.get("autoDecrAmount"),
          week: tempWeek + 1,
          startdate: startDate
              .add(Duration(days: 7 * tempWeek))
              .millisecondsSinceEpoch,
          endDate: startDate
              .add(Duration(days: 7 * (tempWeek + 1)))
              .millisecondsSinceEpoch);
      box.add(newWeek);
      currentWeek = box.getAt(box.length - 1);
      print("New Week: " + newWeek.toString());
    } else {
      print("Week is okay");
    }
  }
}
