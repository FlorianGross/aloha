import 'package:dieBruecke/Pages/SettingsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Week.dart';

class SessionPage extends StatefulWidget {
  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final box = Hive.box("Week");
  double? planSlider = 0, daySlider = 0;
  int week = 0;
  int maxWeek = 0;
  late Week currentWeek;

  @override
  void initState() {
    maxWeek = box.length - 1;
    week = box.getAt(box.length - 1).week;
    currentWeek = box.getAt(week);
    planSlider = currentWeek.plannedSE;
    daySlider = currentWeek.plannedDay;
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

  Future<void> openSettings() async {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  generateWeeks() {
    List<int?> weeks = [];
    for (int i = 0; i < box.length; i++) {
      weeks.add(box.getAt(i).week);
    }
    return weeks;
  }
}
