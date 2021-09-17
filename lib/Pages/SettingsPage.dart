import 'package:aloha/Notifications.dart';
import 'package:aloha/Widgets/ChangeModeButton.dart';
import 'package:aloha/Widgets/DayButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../SetupSettings.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final box = Hive.box("settings");
  final ownBox = Hive.box("own");
  bool? notifications = true;
  late double ownSE;
  String? name = "Name";
  double? volumen;
  double? volumePart;
  int hour = 0;
  int minute = 0;
  Color selected = SetupSettings().primary, unselected = Colors.black38;
  Color? moBut, diBut, miBut, doBut, frBut, saBut, soBut;
  bool isMoBut = false,
      isDiBut = false,
      isMiBut = false,
      isDoBut = false,
      isFrBut = false,
      isSaBut = false,
      isSoBut = false;
  TextEditingController nameController = TextEditingController(text: "Name");
  TextEditingController volumeController =
      TextEditingController(text: "1000.0");
  TextEditingController volumePartController = TextEditingController(text: "5");

  @override
  void initState() {
    if (box.get("notifications") != null) {
      notifications = box.get("notifications");
    }
    if (ownBox.get("name") != null &&
        ownBox.get("volumen") != null &&
        ownBox.get("volumenpart") != null) {
      name = ownBox.get("name");
      volumen = ownBox.get("volumen") + 0.0;
      volumePart = ownBox.get("volumenpart") + 0.0;
      nameController = TextEditingController(text: name);
      volumeController = TextEditingController(text: volumen.toString());
      volumePartController = TextEditingController(text: volumePart.toString());
      ownSE = (volumen! * 0.8 * (volumePart! / 1000)) / 2;
    } else {
      name = "Name";
      volumen = 500;
      volumePart = 5;
      ownSE = (volumen! * 0.8 * (volumePart! / 1000)) / 2;
    }
    moBut = unselected;
    diBut = unselected;
    miBut = unselected;
    doBut = unselected;
    frBut = unselected;
    saBut = unselected;
    soBut = unselected;
    isMoBut = box.get("isMo");
    if (isMoBut) {
      moBut = selected;
    }
    isDiBut = box.get("isDi");
    if (isDiBut) {
      diBut = selected;
    }
    isMiBut = box.get("isMi");
    if (isMiBut) {
      miBut = selected;
    }
    isDoBut = box.get("isDo");
    if (isDoBut) {
      doBut = selected;
    }
    isFrBut = box.get("isFr");
    if (isFrBut) {
      frBut = selected;
    }
    isSaBut = box.get("isSa");
    if (isSaBut) {
      saBut = selected;
    }
    isSoBut = box.get("isSo");
    if (isSoBut) {
      soBut = selected;
    }
    try {
      minute = box.get("minute");
      hour = box.get("hour");
    } catch (e) {
      minute = 0;
      hour = 18;
      print(e);
    }
    super.initState();
    print("Settings initialized");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Einstellungen",
                    style: TextStyle(
                        fontSize: width * 0.06, fontWeight: FontWeight.w500),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: width * 0.05,
                    ),
                    onPressed: pop,
                  ),
                ],
              ),
              Divider(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    primary: false,
                    shrinkWrap: true,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Darkmode: ",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                          ChangeModeButton(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Benachrichtigungen: ",
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                            Transform.scale(
                              scale: 1.6,
                              child: Switch.adaptive(
                                activeColor: Theme.of(context).primaryColor,
                                value: notifications!,
                                onChanged: (value) {
                                  setState(() {
                                    notifications = value;
                                    box.put("notifications", value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  DayButton(
                                      weekday: "Mo",
                                      fontSize: width * 0.03,
                                      size: width * 0.07,
                                      onTab: (val) {
                                        isMoBut = val;
                                        if (isMoBut) {
                                          addNotification(1);
                                        } else {
                                          removeNotification(1);
                                        }
                                      }),
                                  DayButton(
                                    weekday: "Di",
                                    fontSize: width * 0.03,
                                    size: width * 0.07,
                                    onTab: (val) {
                                      isDiBut = val;
                                      if (isDiBut) {
                                        addNotification(2);
                                      } else {
                                        removeNotification(2);
                                      }
                                    },
                                  ),
                                  DayButton(
                                      fontSize: width * 0.03,
                                      size: width * 0.07,
                                      onTab: (val) {
                                        isMiBut = val;
                                      },
                                      weekday: "Mi"),
                                  DayButton(
                                    fontSize: width * 0.03,
                                    size: width * 0.07,
                                    onTab: (val) {
                                      isMiBut = val;
                                      if (isMiBut) {
                                        addNotification(3);
                                      } else {
                                        removeNotification(3);
                                      }
                                    },
                                    weekday: "Mi",
                                  ),
                                  DayButton(
                                    fontSize: width * 0.03,
                                    size: width * 0.07,
                                    onTab: (val) {
                                      isDoBut = val;
                                      if (isDoBut) {
                                        addNotification(4);
                                      } else {
                                        removeNotification(4);
                                      }
                                    },
                                    weekday: "Do",
                                  ),
                                  DayButton(
                                    fontSize: width * 0.03,
                                    size: width * 0.07,
                                    onTab: (val) {
                                      isFrBut = val;
                                      if (isFrBut) {
                                        addNotification(5);
                                      } else {
                                        removeNotification(5);
                                      }
                                    },
                                    weekday: "Fr",
                                  ),
                                  DayButton(
                                    fontSize: width * 0.03,
                                    size: width * 0.07,
                                    onTab: (val) {
                                      isSaBut = val;
                                      if (isSaBut) {
                                        addNotification(6);
                                      } else {
                                        removeNotification(6);
                                      }
                                    },
                                    weekday: "Sa",
                                  ),
                                  DayButton(
                                    fontSize: width * 0.03,
                                    size: width * 0.07,
                                    onTab: (val) {
                                      isSoBut = val;
                                      if (isSoBut) {
                                        addNotification(7);
                                      } else {
                                        removeNotification(7);
                                      }
                                    },
                                    weekday: "So",
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Theme.of(context).primaryColor),
                                  child: Text(
                                    "Uhrzeit wählen: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: width * 0.03),
                                  ),
                                  onPressed: () => pickTime(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        visible: notifications!,
                      ),
                    ],
                  ),
                ),
              ),
              Row(children: [
                Text(
                  "Eigenes Getränk",
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer()
              ]),
              Divider(),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name: ",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                          SizedBox(
                            width: width * 0.4,
                            height: height * 0.08,
                            child: TextField(
                              style: TextStyle(fontSize: width * 0.03),
                              controller: nameController,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Volumen in ml: ",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                          SizedBox(
                            width: width * 0.4,
                            height: height * 0.08,
                            child: TextField(
                              style: TextStyle(fontSize: width * 0.03),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"^\d*\.?\d*"))
                              ],
                              controller: volumeController,
                              onSubmitted: (value) {
                                setState(() {
                                  volumen = double.parse(value);
                                  ownSE =
                                      (volumen! * 0.8 * (volumePart! / 1000)) /
                                          2;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Volumen%: ",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                          SizedBox(
                            width: width * 0.4,
                            height: height * 0.08,
                            child: TextField(
                              style: TextStyle(fontSize: width * 0.03),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"^\d*\.?\d*"))
                              ],
                              keyboardType: TextInputType.number,
                              controller: volumePartController,
                              onSubmitted: (value) {
                                setState(() {
                                  volumePart = double.parse(value);
                                  ownSE =
                                      (volumen! * 0.8 * (volumePart! / 1000)) /
                                          2;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Entspricht in SE: ",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: width * 0.17),
                            child: Text(
                              ownSE.toStringAsPrecision(2) + " SE",
                              style: TextStyle(fontSize: width * 0.03),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      ElevatedButton(
                          style: OutlinedButton.styleFrom(
                              primary: Colors.black,
                              backgroundColor: Theme.of(context).primaryColor,
                              alignment: Alignment.center),
                        child: Text(
                          "Speichern",
                          style: TextStyle(
                              color: Colors.black, fontSize: width * 0.03),
                        ),
                        onPressed: confirmOwnDrink,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Saves the values from the controllers to the Hivedb
  Future<void> confirmOwnDrink() async {
    try {
      String name = nameController.text;
      double volume = double.parse(volumeController.text);
      double volumePart = double.parse(volumePartController.text);
      ownBox.put("name", name);
      ownBox.put("volumen", volume);
      ownBox.put("volumenpart", volumePart);
      print("Save successful: " + ownBox.toMap().toString());
      final SnackBar snackBar = SnackBar(content: Text('Getränk $name gespeichert'),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print("Error while saving Drink: " + e.toString());
    }
  }

  Future<void> removeNotification(int number) async {
    LocalNotifyManager manager = LocalNotifyManager.init();
    manager.cancelNotification(number);
  }

  Future<void> addNotification(int number) async {
    LocalNotifyManager manager = LocalNotifyManager.init();
    manager.scheduleNotificationNew(number, hour, minute);
  }

  Future<void> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: hour, minute: minute);
    final newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (newTime == null) return;
    setState(() {
      hour = newTime.hour;
      minute = newTime.minute;
      box.put("hour", hour);
      box.put("minute", minute);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    volumePartController.dispose();
    volumeController.dispose();
    super.dispose();
  }

  Future<void> pop() async {
    Navigator.pop(context);
  }
}
