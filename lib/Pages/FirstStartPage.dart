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

  TextEditingController seFirstWeek = TextEditingController(text: "0");
  TextEditingController consumptionDays = TextEditingController(text: "0");

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

  String dropdownValue = "Mo";
  final dayList = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];

  @override
  void initState() {
    moBut = unselected;
    diBut = unselected;
    miBut = unselected;
    doBut = unselected;
    frBut = unselected;
    saBut = unselected;
    soBut = unselected;

    DateTime firstStart = settingsBox.get("firstStartDate");
    dropdownValue = setWeekStart(firstStart);

    super.initState();
    print("FirstStartPage initialized");
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
            // Logo / Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/Aloha-PNG.png'),
                  width: width * 0.5,
                  height: width * 0.5,
                ),
                SizedBox(height: 16),
              ],
            ),

            // Abschnitt: Zielwerte Woche 1
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
                      "Plan für die erste Woche",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    _LabeledNumberField(
                      label: "SE gesamt",
                      hint: "z.B. 12.5",
                      controller: seFirstWeek,
                      maxLength: 5,
                      width: width,
                      suffix: "SE",
                      keyboardType: TextInputType.number,
                      formatter: FilteringTextInputFormatter.allow(
                        RegExp(r"^\d*\.?\d*"),
                      ),
                    ),
                    SizedBox(height: 12),
                    _LabeledNumberField(
                      label: "Konsumtage",
                      hint: "0 - 7",
                      controller: consumptionDays,
                      maxLength: 1,
                      width: width,
                      suffix: "Tage",
                      keyboardType: TextInputType.number,
                      formatter: FilteringTextInputFormatter.allow(
                        RegExp(r"[0-7]"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Abschnitt: Benachrichtigungen
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
                        PlatformSwitch(
                          activeColor: primary,
                          value: notificationsOn,
                          onChanged: (value) {
                            setState(() {
                              notificationsOn = value;
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    AnimatedCrossFade(
                      crossFadeState: notificationsOn
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 200),
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Wochentage Auswahl
                          Text(
                            "Erinnerungstage",
                            style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 8,
                            spacing: 8,
                            children: [
                              DayButton(
                                weekday: "Mo",
                                size: width * 0.12,
                                fontSize: width * 0.04,
                                onTab: (val) {
                                  isMoBut = val;
                                },
                              ),
                              DayButton(
                                weekday: "Di",
                                size: width * 0.12,
                                fontSize: width * 0.04,
                                onTab: (val) {
                                  isDiBut = val;
                                },
                              ),
                              DayButton(
                                weekday: "Mi",
                                size: width * 0.12,
                                fontSize: width * 0.04,
                                onTab: (val) {
                                  isMiBut = val;
                                },
                              ),
                              DayButton(
                                weekday: "Do",
                                size: width * 0.12,
                                fontSize: width * 0.04,
                                onTab: (val) {
                                  isDoBut = val;
                                },
                              ),
                              DayButton(
                                weekday: "Fr",
                                size: width * 0.12,
                                fontSize: width * 0.04,
                                onTab: (val) {
                                  isFrBut = val;
                                },
                              ),
                              DayButton(
                                weekday: "Sa",
                                size: width * 0.12,
                                fontSize: width * 0.04,
                                onTab: (val) {
                                  isSaBut = val;
                                },
                              ),
                              DayButton(
                                weekday: "So",
                                size: width * 0.12,
                                fontSize: width * 0.04,
                                onTab: (val) {
                                  isSoBut = val;
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Uhrzeit-Button
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

            SizedBox(height: 16),

            // Speichern-Button (volle Breite)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
              onPressed: () => onPressed(),
              child: Text(
                "Speichern & Starten",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: height * 0.05),
          ],
        ),
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

      /// Presets definieren
      ownBox.put("name", "Name");
      ownBox.put("volumen", 500.0);
      ownBox.put("volumenpart", 5.0);
      ownBox.put("icon", 0);

      ownBox.put("name-1", "Name-1");
      ownBox.put("volumen-1", 500.0);
      ownBox.put("volumenpart-1", 5.0);
      ownBox.put("icon-1", 0);

      ownBox.put("name-2", "Name-2");
      ownBox.put("volumen-2", 500.0);
      ownBox.put("volumenpart-2", 5.0);
      ownBox.put("icon-2", 0);

      ownBox.put("name-3", "Name-3");
      ownBox.put("volumen-3", 500.0);
      ownBox.put("volumenpart-3", 5.0);
      ownBox.put("icon-3", 0);

      DateTime startDate = settingsBox.get("firstStartDate");
      int days = getDaystilStart();

      Week firstWeek = Week(
        plannedSE: double.parse(seFirstWeek.text),
        week: 0,
        endDate: startDate
            .add(Duration(
          days: days,
          hours: 23,
          minutes: 59,
          milliseconds: 999,
          seconds: 59,
        ))
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
        ),
      );
    } catch (e) {
      print("Error: " + e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fehler bei der Eingabe"),
        ),
      );
    }
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

    settingsBox.put(hour, hour);
    settingsBox.put(minute, minute);
  }

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
                    setState(() {
                      newTime = val;
                    });
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

  int getDaystilStart() {
    int weekday = 0;
    switch (dropdownValue) {
      case "Mo":
        weekday = 1;
        break;
      case "Di":
        weekday = 2;
        break;
      case "Mi":
        weekday = 3;
        break;
      case "Do":
        weekday = 4;
        break;
      case "Fr":
        weekday = 5;
        break;
      case "Sa":
        weekday = 6;
        break;
      case "So":
        weekday = 7;
        break;
      default:
        break;
    }
    DateTime now = DateTime.now();
    int iterator = 0;
    while (now.weekday != weekday) {
      iterator++;
      now = now.add(Duration(days: 1));
      print(now.toString());
    }
    print(iterator.toString());
    return 6 + iterator;
  }

  String setWeekStart(DateTime firstStart) {
    int weekday = firstStart.weekday;
    switch (weekday) {
      case 1:
        return "Mo";
      case 2:
        return "Di";
      case 3:
        return "Mi";
      case 4:
        return "Do";
      case 5:
        return "Fr";
      case 6:
        return "Sa";
      case 7:
        return "So";
    }
    return "Mo";
  }
}

/// Hilfs-Widget: Label links, kompakter Number-TextField rechts
class _LabeledNumberField extends StatelessWidget {
  final String label;
  final String hint;
  final String suffix;
  final TextEditingController controller;
  final int maxLength;
  final TextInputType keyboardType;
  final TextInputFormatter formatter;
  final double width;

  const _LabeledNumberField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.maxLength,
    required this.keyboardType,
    required this.formatter,
    required this.width,
    this.suffix = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: width * 0.04,
            ),
          ),
        ),
        SizedBox(width: width * 0.05),
        // Input
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 48,
            child: TextField(
              controller: controller,
              maxLength: maxLength,
              keyboardType: keyboardType,
              inputFormatters: [formatter],
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                counterText: "",
                hintText: hint,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixText: suffix.isNotEmpty ? suffix : null,
              ),
              style: TextStyle(fontSize: width * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}
