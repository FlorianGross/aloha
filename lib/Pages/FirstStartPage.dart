import 'package:aloha/Modelle/Week.dart';
import 'package:aloha/Widgets/DayButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import '../MyApp.dart';
import '../Notifications.dart';

class FirstStartPage extends StatefulWidget {
  @override
  _FirstStartPageState createState() => _FirstStartPageState();
}

class _FirstStartPageState extends State<FirstStartPage> {
  final settingsBox = Hive.box("settings");
  final ownBox = Hive.box("own");
  final weekBox = Hive.box("Week");
  TextEditingController seFirstWeek = TextEditingController(text: "0"),
      amount = TextEditingController(text: "0"),
      consumptionDays = TextEditingController(text: "0");
  bool autoDecr = false;
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
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Image(
                image: AssetImage('assets/LaunchImage.png'),
                width: 244,
                height: 244,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
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
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^\d*\.?\d*"))
                            ],
                          ),
                        ),
                      ],
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"^\d*\.?\d*"))
                              ],
                            ),
                          ),
                        ],
                      ),
                      visible: autoDecr,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Konsumtage: "),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: TextField(
                            controller: consumptionDays,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r"^\d*"))
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Benachrichtigungen: "),
                        Switch(
                            activeColor: Theme.of(context).primaryColor,
                            value: notificationsOn,
                            onChanged: (value) {
                              setState(() {
                                notificationsOn = value;
                              });
                            }),
                      ],
                    ),
                    Visibility(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DayButton(
                                  onTab: (val) {
                                    isMoBut = val;
                                  },
                                  size: 50,
                                  weekday: "Mo"),
                              DayButton(
                                  onTab: (value) {
                                    isDiBut = value;
                                  },
                                  size: 50,
                                  weekday: "Di"),
                              DayButton(
                                  onTab: (value) {
                                    isMiBut = value;
                                  },
                                  size: 50,
                                  weekday: "Mi"),
                              DayButton(
                                  onTab: (val) {
                                    isDoBut = val;
                                  },
                                  size: 50,
                                  weekday: "Do"),
                              DayButton(
                                  onTab: (val) {
                                    isFrBut = val;
                                  },
                                  size: 50,
                                  weekday: "Fr"),
                              DayButton(
                                  onTab: (val) {
                                    isSaBut = val;
                                  },
                                  size: 50,
                                  weekday: "Sa"),
                              DayButton(
                                  onTab: (val) {
                                    isSoBut = val;
                                  },
                                  size: 50,
                                  weekday: "So"),
                            ],
                          ),
                          ElevatedButton(
                              child: Text(
                                "Uhrzeit wählen: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.yellow),
                              onPressed: () => pickTime(context)),
                        ],
                      ),
                      visible: notificationsOn,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          try {
                            saveSettings();
                            settingsBox.put("firstStart", false);
                            print("Save standard Settings: " +
                                settingsBox.toMap().toString());
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          } catch (e) {
                            print("Error: " + e.toString());
                          }
                        },
                        child: Text(
                          "Speichern",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
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

  Future<void> saveSettings() async {
    settingsBox.put("isMo", isMoBut);
    settingsBox.put("isDi", isDiBut);
    settingsBox.put("isMi", isMiBut);
    settingsBox.put("isDo", isDoBut);
    settingsBox.put("isFr", isFrBut);
    settingsBox.put("isSa", isSaBut);
    settingsBox.put("isSo", isSoBut);
    settingsBox.put("autoDecr", autoDecr);
    settingsBox.put("SEforNextWeek", double.parse(seFirstWeek.text));
    settingsBox.put("DaysForNextWeek", double.parse(consumptionDays.text));
    settingsBox.put("autoDecrAmount", int.parse(amount.text));
    settingsBox.put("notifications", notificationsOn);
    settingsBox.put("hour", hour);
    settingsBox.put("minute", minute);
    ownBox.put("name", "Name");
    ownBox.put("volumen", 500);
    ownBox.put("volumenpart", 5);
    DateTime startDate = settingsBox.get("firstStartDate");
    Week firstWeek = Week(
        plannedSE: 0,
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
        plannedDay: 0,
        startdate: startDate.millisecondsSinceEpoch);
    weekBox.add(firstWeek);
    print(weekBox.getAt(0).toString());
    await setupNotifications();
  }

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

  Future<void> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: hour, minute: minute);
    final newTime =
        await showTimePicker(context: context, initialTime: initialTime);
    if (newTime == null) return;
    setState(() {
      hour = newTime.hour;
      minute = newTime.minute;
    });
  }

  @override
  void dispose() {
    seFirstWeek.dispose();
    super.dispose();
  }
}
