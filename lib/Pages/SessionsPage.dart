import 'dart:core';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:aloha/Modelle/Week.dart';
import 'package:aloha/Pages/SettingsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SessionPage extends StatefulWidget {
  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final box = Hive.box("Week");
  final settingsBox = Hive.box("settings");
  TextEditingController? amount;
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return PlatformScaffold(
      material: (context, platform) => MaterialScaffoldData(),
      cupertino: (context, platform) => CupertinoPageScaffoldData(),
      body: new Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PlatformText(
                    "Woche $week",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.09),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: width * 0.2,
                        child: PlatformElevatedButton(
                          cupertino: (context, platform) => CupertinoElevatedButtonData(),
                          material: (context, platform) => MaterialElevatedButtonData(style: ElevatedButton.styleFrom(primary: Colors.yellow),),
                          child: Icon(
                            Icons.arrow_left,
                            color: Colors.black,
                            size: width * 0.05,
                          ),
                          onPressed: () {
                            setState(() {
                              if (week > 0) {
                                week--;
                                print("Week: $week");
                                currentWeek = box.getAt(week);
                                autoDecr = settingsBox.get("autoDecr");
                                decrAmount = settingsBox.get("autoDecrAmount");
                                amount = TextEditingController(
                                    text: decrAmount.toString());
                                planSlider = calculateNextWeekSEPlan();
                                daySlider = currentWeek.plannedDay;
                                seValue = currentWeek.getSethisWeek();
                                dayValue = currentWeek.getUsedDays();
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * 0.6,
                        child: Card(
                          color: Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: PlatformText(
                              "Zusammenfassung: \n\n" +
                                  seValue.toString() +
                                  " / " +
                                  currentWeek.plannedSE.toString() +
                                  " SE \n" +
                                  dayValue.toString() +
                                  " / " +
                                  currentWeek.plannedDay.toString() +
                                  " Days\n\n " +
                                  DateFormat.yMd()
                                      .format(currentWeek.getStartDate()) +
                                  " \n - \n " +
                                  DateFormat.yMd()
                                      .format(currentWeek.getEndTime()),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.04),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.2,
                        child: PlatformElevatedButton(
                          cupertino: (context, platform) => CupertinoElevatedButtonData(),
                          material: (context, platform) => MaterialElevatedButtonData(style: ElevatedButton.styleFrom(primary: Colors.yellow),),
                          child: Icon(
                            Icons.arrow_right,
                            size: width * 0.05,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              if (week < maxWeek) {
                                week++;
                                print("Week: $week");
                                currentWeek = box.getAt(week);
                                autoDecr = settingsBox.get("autoDecr");
                                decrAmount = settingsBox.get("autoDecrAmount");
                                amount = TextEditingController(
                                    text: decrAmount.toString());
                                planSlider = calculateNextWeekSEPlan();
                                daySlider = currentWeek.plannedDay;
                                seValue = currentWeek.getSethisWeek();
                                dayValue = currentWeek.getUsedDays();
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PlatformText(
                    "Planung Woche ${week + 1}:  \n" +
                        planSlider!.toStringAsPrecision(2) +
                        " SE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.05),
                  ),
                  PlatformSlider(
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
                        settingsBox.put("SEforNextWeek", value);
                        print("save");
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PlatformText(
                        "Wöchentlich automatisch verringern?",
                        style: TextStyle(fontSize: width * 0.03),
                      ),
                      Transform.scale(
                        scale: 1.6,
                        child: PlatformSwitch(
                          value: autoDecr,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              autoDecr = value;
                              settingsBox.put("autoDecr", autoDecr);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PlatformText("Anzahl: "),
                        SizedBox(
                            height: height * 0.07,
                            width: width * 0.3,
                            child: PlatformTextField(
                              controller: amount,
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                settingsBox.put(
                                    "autoDecrAmount", int.parse(value));
                              },
                            ))
                      ],
                    ),
                    visible: autoDecr,
                  ),
                  Divider(),
                  PlatformText(
                    "Konsumtage: \n" + daySlider!.toStringAsPrecision(1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.05),
                  ),
                  PlatformSlider(
                    activeColor: Colors.yellow,
                    value: daySlider!,
                    min: 0,
                    max: 7,
                    divisions: 7,
                    onChanged: (value) {
                      setState(() {
                        daySlider = value;
                        settingsBox.put("DaysForNextWeek", value);
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
    if (autoDecr) {
      double result = currentWeek.plannedSE! - decrAmount;
      if (result <= 0) {
        return 0;
      }
      return result;
    } else {
      return currentWeek.plannedSE!;
    }
  }
}
