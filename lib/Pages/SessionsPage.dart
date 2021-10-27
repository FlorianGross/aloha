import 'dart:core';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:aloha/Modelle/Week.dart';
import 'package:aloha/Pages/SettingsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_view_indicators/arrow_page_indicator.dart';

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
  double decrAmount = 0.0;
  var _pageController;
  var _currentPageNotifier;
  final snackBar = SnackBar(content: Text('Woche geplant!'));

  @override
  void initState() {
    maxWeek = box.length;
    week = box.getAt(box.length - 1).week;
    currentWeek = box.getAt(box.length - 1);
    autoDecr = settingsBox.get("autoDecr");
    decrAmount = settingsBox.get("autoDecrAmount");
    amount = TextEditingController(text: decrAmount.toString());
    planSlider = calculateNextWeekSEPlan();
    daySlider = settingsBox.get("DaysForNextWeek");
    seValue = currentWeek.getSethisWeek();
    dayValue = currentWeek.getUsedDays();
    _pageController = PageController(
      initialPage: week
    );
    _currentPageNotifier = ValueNotifier<int>(week);
    super.initState();
    print("Sessions initialized");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        primary: true,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Woche $week",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.09),
                  ),
                  SizedBox(
                    height: height * 0.3,
                    child: ArrowPageIndicator(
                        pageController: _pageController,
                        currentPageNotifier: _currentPageNotifier,
                        itemCount: maxWeek,
                        child: _buildPageView(width)),
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Planung Woche ${box.length}:  \n" +
                        planSlider!.toStringAsPrecision(2) +
                        " SE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.05),
                  ),
                  PlatformSlider(
                    activeColor: Theme.of(context).primaryColor,
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
                      settingsBox.put("SEforNextWeek", value);
                      print("save");
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
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
                        Text("Anzahl: "),
                        SizedBox(
                            height: height * 0.07,
                            width: width * 0.3,
                            child: TextField(
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
                  Text(
                    "Konsumtage: \n" + daySlider!.toStringAsPrecision(1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.05),
                  ),
                  PlatformSlider(
                    activeColor: Theme.of(context).primaryColor,
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
                      print("save");
                      settingsBox.put("DaysForNextWeek", value);
                    },
                  ),
                  ElevatedButton(
                      onPressed: saveSetup,
                      child: Text(
                        "Speichern",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor)),
                ],
              ),
            ),
          ),
          ElevatedButton(
              onPressed: openSettings,
              child: Text(
                "Einstellungen",
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor)),
        ],
      ),
    );
  }

  /// Öffnet das Einstellugnsmenu
  Future<void> openSettings() async {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  /// Speichert die Einstellung
  Future<void> saveSetup() async {
    settingsBox.put("DaysForNextWeek", daySlider);
    settingsBox.put("autoDecrAmount", int.parse(amount.toString()));
    settingsBox.put("SEforNextWeek", planSlider);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Berechnet den Wert der nachfolgenden Woche
  double calculateNextWeekSEPlan() {
    if (autoDecr) {
      double result = currentWeek.plannedSE! - decrAmount;
      if (result <= 0) {
        return 0;
      }
      return result;
    } else {
      return settingsBox.get("SEforNextWeek");
    }
  }

  /// Setz die Aktuelle Woche entsprechend der Werte
  Future<void> setWeek(int value) async {
    setState(() {
      week = value;
      currentWeek = box.getAt(week);
      seValue = currentWeek.getSethisWeek();
      dayValue = currentWeek.getUsedDays();
    });
  }

  /// Setzt initial die Werte der Aktuellen Woche (ohne setState)
  Future<void> initWeek(int value) async {
    week = value;
    currentWeek = box.getAt(week);
    seValue = currentWeek.getSethisWeek();
    dayValue = currentWeek.getUsedDays();
  }

  _buildPageView(double width) {
    return PageView.builder(
      itemCount: maxWeek,
      controller: _pageController,
      onPageChanged: (value) {
        setWeek(value);
        _currentPageNotifier.value = value;
        print("$value current page: $week current week");
      },
      itemBuilder: (context, index) {
        initWeek(index);
        return Card(
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Zusammenfassung: \n\n" +
                  seValue.toStringAsPrecision(3) +
                  " / " +
                  currentWeek.plannedSE!.toStringAsPrecision(3) +
                  " SE \n" +
                  dayValue.toString() +
                  " / " +
                  currentWeek.plannedDay.toString() +
                  " Days\n\n " +
                  DateFormat.yMd().format(currentWeek.getStartDate()) +
                  " \n - \n " +
                  DateFormat.yMd().format(currentWeek.getEndTime()),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: width * 0.04),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    amount!.dispose();
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }
}
