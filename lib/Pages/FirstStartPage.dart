import 'package:aloha/Week.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import '../main.dart';
import '../LocalNotifyManager.dart';

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
                            )),
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
                              ))
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
                            )),
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
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isMoBut) {
                                      isMoBut = false;
                                      moBut = unselected;
                                    } else {
                                      isMoBut = true;
                                      moBut = selected;
                                    }
                                  });
                                },
                                child: Container(
                                  child: Center(
                                    child: Text("Mo"),
                                  ),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: moBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isDiBut) {
                                      isDiBut = false;
                                      diBut = unselected;
                                    } else {
                                      isDiBut = true;
                                      diBut = selected;
                                    }
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("Di")),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: diBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isMiBut) {
                                      isMiBut = false;
                                      miBut = unselected;
                                    } else {
                                      isMiBut = true;
                                      miBut = selected;
                                    }
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("Mi")),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: miBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isDoBut) {
                                      isDoBut = false;
                                      doBut = unselected;
                                    } else {
                                      isDoBut = true;
                                      doBut = selected;
                                    }
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("Do")),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: doBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isFrBut) {
                                      isFrBut = false;
                                      frBut = unselected;
                                    } else {
                                      isFrBut = true;
                                      frBut = selected;
                                    }
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("Fr")),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: frBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSaBut) {
                                      isSaBut = false;
                                      saBut = unselected;
                                    } else {
                                      isSaBut = true;
                                      saBut = selected;
                                    }
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("Sa")),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: saBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSoBut) {
                                      isSoBut = false;
                                      soBut = unselected;
                                    } else {
                                      isSoBut = true;
                                      soBut = selected;
                                    }
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("So")),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: soBut),
                                ),
                              ),
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
    settingsBox.put("SEforNextWeek", double.parse(seFirstWeek.text));
    settingsBox.put("DaysForNextWeek", double.parse(consumptionDays.text));
    settingsBox.put("autoDecr", autoDecr);
    settingsBox.put("autoDecrAmount", int.parse(amount.text));
    settingsBox.put("notifications", notificationsOn);
    settingsBox.put("hour", hour);
    settingsBox.put("minute", minute);
    ownBox.put("name", "Name");
    ownBox.put("volumen", 500);
    ownBox.put("volumenpart", 5);
    weekBox.add(Week(
      week: 0,
      startdate: DateTime.now().millisecondsSinceEpoch,
      endDate: DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch,
      plannedDay: settingsBox.get("DaysForNextWeek"),
      plannedSE: settingsBox.get("SEforNextWeek"),
    ));
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
