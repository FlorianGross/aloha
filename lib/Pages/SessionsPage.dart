import 'package:aloha/Pages/SettingsPage.dart';
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
  final settingsBox = Hive.box("settings");
  late TextEditingController amount;
  double? planSlider = 0, daySlider = 0;
  double seValue = 0, dayValue = 0;
  int week = 0;
  int maxWeek = 0;
  late Week currentWeek;
  bool autoDecr = true;
  int decrAmount = 0;

  @override
  void initState() {
    maxWeek = box.length - 1;
    week = box.getAt(box.length - 1).week;
    currentWeek = box.getAt(box.length - 1);
    autoDecr = settingsBox.get("autoDecr");
    decrAmount = settingsBox.get("autoDecrAmount");
    amount = TextEditingController(text: decrAmount.toString());
    planSlider = calculateNextWeekSEPlan();
    daySlider = currentWeek.plannedDay;
    seValue = currentWeek.getSethisWeek();
    dayValue = currentWeek.getUsedDays();

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
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          if (week > 0) {
                            week--;
                          }
                        });
                      },
                    ),
                    Card(
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Informations \n" +
                              seValue.toString() +
                              " / " +
                              currentWeek.plannedSE.toString() +
                              " SE \n" +
                              dayValue.toString() +
                              " / " +
                              currentWeek.plannedDay.toString() +
                              " Days\n " +
                              currentWeek.getStartDate().toString() +
                              " \n - \n " +
                              currentWeek.getEndTime().toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.yellow),
                      child: Icon(
                        Icons.arrow_right,
                        color: Colors.black,
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
                    "Planung Woche ${week + 1}:  \n" + planSlider!.toStringAsPrecision(2) + " SE",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Slider(
                    activeColor: Colors.yellow,
                    value: planSlider!,
                    min: 0,
                    max: 80,
                    divisions: 70,
                    onChanged: (value) {
                      setState(() {
                        planSlider = value;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        print("save");
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Wöchentlich automatisch verringern?"),
                      Switch(
                        value: autoDecr,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) {
                          setState(() {
                            autoDecr = value;
                            settingsBox.put("autoDecr", autoDecr);
                          });
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Anzahl: "),
                        SizedBox(
                            height: 50,
                            width: 150,
                            child: TextField(
                              controller: amount,
                              keyboardType: TextInputType.number,
                              onSubmitted: (value){
                                settingsBox.put("autoDecrAmount", int.parse(value));
                              },
                            ))
                      ],
                    ),
                    visible: autoDecr,
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
                    onChangeEnd: (value) {
                      setState(() {
                        print("save");
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

  /// Opens the Settings Tab
  Future<void> openSettings() async {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  double calculateNextWeekSEPlan() {
    if(autoDecr){
      double result = currentWeek.plannedSE! - decrAmount;
      if(result <= 0){
        return 0;
      }
      return result;
    }else{
      return currentWeek.plannedSE!;
    }
  }
}
