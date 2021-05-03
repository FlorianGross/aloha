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
  double? plannedForWeek = 12.0, usedThisWeek = 0.0;
  double? plannedDay = 0, usedDay = 0;
  final drinkBox = Hive.box("drinks");
  final box = Hive.box('Week');
  final settingsBox = Hive.box("settings");
  final ownBox = Hive.box("own");
  bool fastAdd = false;
  late Week currentWeek;

  @override
  void initState() {
    try {
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

  double? checkVolume() {
    double volume = ownBox.get("volumen") + 0.0;
    return volume;
  }

  double? checkVolumePart() {
    double volumePart = ownBox.get("volumenpart") + 0.0;
    return volumePart;
  }

  String? getName() {
    String name = ownBox.get("name");
    return name;
  }
}
