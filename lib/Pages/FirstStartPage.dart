import 'package:aloha/Modelle/Week.dart';
import 'package:aloha/Widgets/DayButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import '../MyApp.dart';
import '../Notifications.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;

class FirstStartPage extends StatefulWidget {
  @override
  _FirstStartPageState createState() => _FirstStartPageState();
}

class _FirstStartPageState extends State<FirstStartPage> {
  final settingsBox = Hive.box("settings");
  final ownBox = Hive.box("own");
  final weekBox = Hive.box("Week");
  TextEditingController seFirstWeek = TextEditingController(text: "0"),
      consumptionDays = TextEditingController(text: "0");
  bool notificationsOn = false;
  int hour = 12, minute = 00;
  Color selected = Colors.yellow, unselected = Colors.black38;
  Color? moBut, diBut, miBut, doBut, frBut, saBut, soBut;
  bool isMoBut = false,
      isDiBut = false,
      isMiBut = false,
      isDoBut = false,
      isFrBut = false,
      isSaBut = false,
      isSoBut = false;
  double autoDecrAmount = 0.0;
  double seFirstWeekDouble = 0.0;
  double consumptionDaysDouble = 0.0;

  @override
  void initState() {
    moBut = unselected;
    diBut = unselected;
    miBut = unselected;
    doBut = unselected;
    frBut = unselected;
    saBut = unselected;
    soBut = unselected;
    super.initState();
    print("FirstStartPage initialized");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Image(
                image: AssetImage('assets/Aloha-PNG.png'),
                width: 244,
                height: 244,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.black38,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("SE für die erste Woche:"),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: TextField(
                            controller: seFirstWeek,
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^\d*\.?\d*"))
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Konsumtage: "),
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: TextField(
                              controller: consumptionDays,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[0-7]"))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Benachrichtigungen: "),
                          PlatformSwitch(
                              cupertino: (context, platform) =>
                                  CupertinoSwitchData(
                                      activeColor:
                                          Theme.of(context).primaryColor),
                              activeColor: Theme.of(context).primaryColor,
                              value: notificationsOn,
                              onChanged: (value) {
                                setState(() {
                                  notificationsOn = value;
                                });
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.02),
                      child: Visibility(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DayButton(
                                    fontSize: width * 0.06,
                                    onTab: (val) {
                                      isMoBut = val;
                                    },
                                    size: 50,
                                    weekday: "Mo"),
                                DayButton(
                                    fontSize: width * 0.06,
                                    onTab: (value) {
                                      isDiBut = value;
                                    },
                                    size: 50,
                                    weekday: "Di"),
                                DayButton(
                                    fontSize: width * 0.06,
                                    onTab: (value) {
                                      isMiBut = value;
                                    },
                                    size: 50,
                                    weekday: "Mi"),
                                DayButton(
                                    fontSize: width * 0.06,
                                    onTab: (val) {
                                      isDoBut = val;
                                    },
                                    size: 50,
                                    weekday: "Do"),
                                DayButton(
                                    fontSize: width * 0.06,
                                    onTab: (val) {
                                      isFrBut = val;
                                    },
                                    size: 50,
                                    weekday: "Fr"),
                                DayButton(
                                    fontSize: width * 0.06,
                                    onTab: (val) {
                                      isSaBut = val;
                                    },
                                    size: 50,
                                    weekday: "Sa"),
                                DayButton(
                                    fontSize: width * 0.06,
                                    onTab: (val) {
                                      isSoBut = val;
                                    },
                                    size: 50,
                                    weekday: "So"),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  child: Text(
                                    "Uhrzeit wählen: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () => pickTime(context)),
                            ),
                          ],
                        ),
                        visible: notificationsOn,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: () => onPressed(),
                        child: Text(
                          "Speichern",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
              child: Text("Erster Start: " +
                  settingsBox.get("firstStartDate").toString())),
        ],
      ),
    );
  }

  /// Speichert die eingestellten Werte. Bei Fehler wird ein SnackBar angezeigt
  Future<void> onPressed() async {
    try {
      seFirstWeekDouble = double.parse(seFirstWeek.text);
      consumptionDaysDouble = double.parse(consumptionDays.text);
      settingsBox.put("SEforNextWeek", seFirstWeekDouble);
      settingsBox.put("DaysForNextWeek", consumptionDaysDouble);
      settingsBox.put("isMo", isMoBut);
      settingsBox.put("isDi", isDiBut);
      settingsBox.put("isMi", isMiBut);
      settingsBox.put("isDo", isDoBut);
      settingsBox.put("isFr", isFrBut);
      settingsBox.put("isSa", isSaBut);
      settingsBox.put("isSo", isSoBut);
      settingsBox.put("notifications", notificationsOn);
      settingsBox.put("hour", hour);
      settingsBox.put("minute", minute);
      /// Drink 0
      ownBox.put("name", "Name");
      ownBox.put("volumen", 500.0);
      ownBox.put("volumenpart", 5.0);
      ownBox.put("icon", 0);
      /// Drink 1
      ownBox.put("name-1", "Name-1");
      ownBox.put("volumen-1", 500.0);
      ownBox.put("volumenpart-1", 5.0);
      ownBox.put("icon-1", 0);
      /// Drink 2
      ownBox.put("name-2", "Name-2");
      ownBox.put("volumen-2", 500.0);
      ownBox.put("volumenpart-2", 5.0);
      ownBox.put("icon-2", 0);
      /// Drink 3
      ownBox.put("name-3", "Name-3");
      ownBox.put("volumen-3", 500.0);
      ownBox.put("volumenpart-3", 5.0);
      ownBox.put("icon-3", 0);

      DateTime startDate = settingsBox.get("firstStartDate");
      Week firstWeek = Week(
        plannedSE: double.parse(seFirstWeek.text),
        week: 0,
        endDate: startDate
            .add(Duration(
                days: 6,
                hours: 23,
                minutes: 59,
                microseconds: 999,
                milliseconds: 99,
                seconds: 59))
            .millisecondsSinceEpoch,
        plannedDay: consumptionDaysDouble,
        startdate: startDate.millisecondsSinceEpoch,
      );
      weekBox.add(firstWeek);
      print(weekBox.getAt(0).toString());
      await setupNotifications();
      settingsBox.put("firstStart", false);
      print("Save standard Settings: " + settingsBox.toMap().toString());
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ));
    } catch (e) {
      print("Error: " + e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Fehler bei der Eingabe"),
      ));
    }
  }

  /// Setzt die eingestellten Benachrichtigungen
  Future<void> setupNotifications() async {
    LocalNotifyManager manager = LocalNotifyManager.init();
    if (isMoBut) {
      await manager.scheduleNotificationNew(1, hour, minute);
    }
    if (isDiBut) {
      await manager.scheduleNotificationNew(2, hour, minute);
    }
    if (isMiBut) {
      await manager.scheduleNotificationNew(3, hour, minute);
    }
    if (isDoBut) {
      await manager.scheduleNotificationNew(4, hour, minute);
    }
    if (isFrBut) {
      await manager.scheduleNotificationNew(5, hour, minute);
    }
    if (isSaBut) {
      await manager.scheduleNotificationNew(6, hour, minute);
    }
    if (isSoBut) {
      await manager.scheduleNotificationNew(7, hour, minute);
    }
    // await manager.scheduleNotificationOnce(DateTime.now().weekday, hour, minute);
    settingsBox.put(hour, hour);
    settingsBox.put(minute, minute);
  }

  /// Öffnet das TimePicker popup
  Future<void> pickTime(BuildContext context) async {
    var platform = Theme.of(context).platform;

    if (platform == TargetPlatform.android) {
      final initialTime = TimeOfDay(hour: hour, minute: minute);
      final newTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
        cancelText: "Abbrechen",
        confirmText: "Bestätigen",
        initialEntryMode: TimePickerEntryMode.dial,
        helpText: "Hilfe",
      );
      if (newTime == null) return;
      setState(() {
        hour = newTime.hour;
        minute = newTime.minute;
      });
    } else {
      var newTime;
      showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
          height: 500,
          color: Colors.black87,
          child: Column(
            children: [
              Container(
                height: 400,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(0, 0, hour, minute),
                  onDateTimeChanged: (val) {
                    setState(
                      () {
                        newTime = val;
                      },
                    );
                  },
                ),
              ),
              CupertinoButton.filled(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
      );
      if (newTime == null) return;
      setState(() {
        hour = newTime.hour;
        minute = newTime.minute;
      });
    }
  }

  @override
  void dispose() {
    consumptionDays.dispose();
    seFirstWeek.dispose();
    super.dispose();
  }
}
