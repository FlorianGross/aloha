import 'package:aloha/BrueckeIcons.dart';
import 'package:aloha/Modelle/Week.dart';
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
  final weekbox = Hive.box("week");

  bool? notifications = true;
  late double ownSE;
  String? name = "Name";
  double? volumen;
  var dropdownValueOwn = 0;
  var dropdownValueIcon = 0;
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
  TextEditingController volumePartController =
  TextEditingController(text: "5");

  String dropdownValue = "Mo";
  final dayList = ["Nichts", "Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];

  @override
  void initState() {
    // Notifications toggle
    if (box.get("notifications") != null) {
      notifications = box.get("notifications");
    }

    // Own drink defaults
    if (ownBox.get("name") != null &&
        ownBox.get("volumen") != null &&
        ownBox.get("volumenpart") != null) {
      name = ownBox.get("name");
      volumen = ownBox.get("volumen") + 0.0;
      volumePart = ownBox.get("volumenpart") + 0.0;
      nameController = TextEditingController(text: name);
      volumeController = TextEditingController(text: volumen.toString());
      volumePartController =
          TextEditingController(text: volumePart.toString());
      ownSE = (volumen! * 0.8 * (volumePart! / 1000)) / 2;
    } else {
      name = "Name";
      volumen = 500;
      volumePart = 5;
      ownSE = (volumen! * 0.8 * (volumePart! / 1000)) / 2;
    }

    // Day button states
    moBut = unselected;
    diBut = unselected;
    miBut = unselected;
    doBut = unselected;
    frBut = unselected;
    saBut = unselected;
    soBut = unselected;

    isMoBut = box.get("isMo");
    if (isMoBut) moBut = selected;
    isDiBut = box.get("isDi");
    if (isDiBut) diBut = selected;
    isMiBut = box.get("isMi");
    if (isMiBut) miBut = selected;
    isDoBut = box.get("isDo");
    if (isDoBut) doBut = selected;
    isFrBut = box.get("isFr");
    if (isFrBut) frBut = selected;
    isSaBut = box.get("isSa");
    if (isSaBut) saBut = selected;
    isSoBut = box.get("isSo");
    if (isSoBut) soBut = selected;

    // Time defaults
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
    final width  = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(width * 0.05),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Einstellungen",
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                  onPressed: pop,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: width * 0.05,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // --- Allgemein Card ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Allgemein",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Darkmode Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Darkmode",
                          style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ChangeModeButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // --- Benachrichtigungen Card ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header + Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Benachrichtigungen",
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Transform.scale(
                          scale: 1.2,
                          child: Switch.adaptive(
                            activeColor: primary,
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

                    SizedBox(height: 12),

                    AnimatedCrossFade(
                      crossFadeState: notifications!
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 200),
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Label
                          Text(
                            "Erinnerungstage",
                            style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          SizedBox(height: 8),

                          // Day Buttons -> Wrap statt volle Row
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 8,
                            spacing: 8,
                            children: [
                              DayButton(
                                weekday: "Mo",
                                size: width * 0.12,
                                fontSize: width * 0.035,
                                onTab: (val) {
                                  isMoBut = val;
                                  if (isMoBut) {
                                    addNotification(1);
                                  } else {
                                    removeNotification(1);
                                  }
                                },
                              ),
                              DayButton(
                                weekday: "Di",
                                size: width * 0.12,
                                fontSize: width * 0.035,
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
                                weekday: "Mi",
                                size: width * 0.12,
                                fontSize: width * 0.035,
                                onTab: (val) {
                                  isMiBut = val;
                                  if (isMiBut) {
                                    addNotification(3);
                                  } else {
                                    removeNotification(3);
                                  }
                                },
                              ),
                              DayButton(
                                weekday: "Do",
                                size: width * 0.12,
                                fontSize: width * 0.035,
                                onTab: (val) {
                                  isDoBut = val;
                                  if (isDoBut) {
                                    addNotification(4);
                                  } else {
                                    removeNotification(4);
                                  }
                                },
                              ),
                              DayButton(
                                weekday: "Fr",
                                size: width * 0.12,
                                fontSize: width * 0.035,
                                onTab: (val) {
                                  isFrBut = val;
                                  if (isFrBut) {
                                    addNotification(5);
                                  } else {
                                    removeNotification(5);
                                  }
                                },
                              ),
                              DayButton(
                                weekday: "Sa",
                                size: width * 0.12,
                                fontSize: width * 0.035,
                                onTab: (val) {
                                  isSaBut = val;
                                  if (isSaBut) {
                                    addNotification(6);
                                  } else {
                                    removeNotification(6);
                                  }
                                },
                              ),
                              DayButton(
                                weekday: "So",
                                size: width * 0.12,
                                fontSize: width * 0.035,
                                onTab: (val) {
                                  isSoBut = val;
                                  if (isSoBut) {
                                    addNotification(7);
                                  } else {
                                    removeNotification(7);
                                  }
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Uhrzeit wählen
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                            onPressed: () => pickTime(context),
                            child: Text(
                              "Uhrzeit wählen: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      secondChild: SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
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

  Future<void> pop() async {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    volumePartController.dispose();
    volumeController.dispose();
    super.dispose();
  }
}
