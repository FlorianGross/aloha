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
  final ownBox = Hive.box("own");
  bool fastAdd = false;

  @override
  void initState() {
    try {
      usedThisWeek = calculateSE(getCurrentSession());
      usedDay = calculateUsedDay(getCurrentWeek()!);
    } catch (e) {
      usedThisWeek = 0;
      usedDay = 0;
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
                    week: getWeek(),
                    session: getCurrentSession(),
                    name: getName(),
                    date: DateTime.now().millisecondsSinceEpoch,
                    volume: checkVolume(),
                    volumepart: checkVolumePart(),
                    uri: null,
                  );
                  box.add(current);
                } catch (e) {
                  print("Error saving preset");
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

  int? calculateUsedDay(int currentWeek) {
    return 0;
  }

  int? getCurrentWeek() {
    return 0;
  }

  double? checkVolume() {
    double volume = ownBox.get("volumen");
    return volume;
  }

  double? checkVolumePart() {
    double volumePart = ownBox.get("volumenpart");
    return volumePart;
  }

  String? getName() {
    String name = ownBox.get("name");
    return name;
  }

  int getWeek() {
    if (box.isNotEmpty && box.getAt(0) != null) {
      Drinks first = box.getAt(0);
      DateTime now = DateTime.now();
      DateTime firstTime = DateTime.fromMillisecondsSinceEpoch(first.date!);
      Duration duration = now.difference(firstTime);
      double resultDouble = duration.inDays / 7;
      int result = resultDouble.toInt();
      print("$result Woche");
      return result;
    } else {
      return 0;
    }
  }
}
