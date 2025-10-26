import 'dart:core';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:aloha/Modelle/Week.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_view_indicators/arrow_page_indicator.dart';
import 'package:aloha/Modelle/Drinks.dart';
import 'package:flutter/services.dart';


class SessionPage extends StatefulWidget {
  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final box = Hive.box("Week");
  final settingsBox = Hive.box("settings");
  final drinksBox = Hive.box("drinks");

  TextEditingController? _plannedSEController;
  TextEditingController? _plannedDaysController;

  double? planSlider = 0, daySlider = 0;
  double seValue = 0, dayValue = 0;
  int week = 0;
  int maxWeek = 0;
  late Week currentWeek;
  var _pageController;
  var _currentPageNotifier;
  final snackBar = SnackBar(content: Text('Woche geplant!'));

  @override
  void initState() {
    maxWeek = box.length;
    week = box.getAt(box.length - 1).week;
    currentWeek = box.getAt(box.length - 1);

    planSlider = calculateNextWeekSEPlan();
    daySlider = settingsBox.get("DaysForNextWeek") + 0.0;

    _plannedSEController = TextEditingController(
      text: planSlider!.toStringAsFixed(1),
    );
    _plannedDaysController = TextEditingController(
      text: daySlider!.toStringAsFixed(1),
    );

    seValue = currentWeek.getSethisWeek();
    dayValue = currentWeek.getUsedDays();

    _pageController = PageController(initialPage: week);
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
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _showWeekDrinksDialog(week);
                    },
                    child: Text(
                      "Getränke dieser Woche",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                  // Überschrift / Kontext
                  Text(
                    "Planung Woche ${box.length}:\n${getPlannedWeekDates()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.05,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Geplante SE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Geplante SE",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.05),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 48,
                          child: TextField(
                            controller: _plannedSEController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^\d*\.?\d*")),
                            ],
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              suffixText: "SE",
                            ),
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Geplante Konsumtage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Geplante Konsumtage",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.05),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 48,
                          child: TextField(
                            controller: _plannedDaysController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^\d*\.?\d*")),
                            ],
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              suffixText: "Tage",
                            ),
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      startWeekNow();
                    },
                    child: Text(
                      "Woche jetzt Starten",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  /// Speichert die Einstellung
  Future<void> saveSetup() async {
    settingsBox.put("DaysForNextWeek", daySlider);
    settingsBox.put("SEforNextWeek", planSlider);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Berechnet den Wert der nachfolgenden Woche
  double calculateNextWeekSEPlan() {
    return settingsBox.get("SEforNextWeek") + 0.0;
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
        final startDateStr =
            DateFormat("dd.MM.yyyy").format(currentWeek.getStartDate());
        final rawEnd = currentWeek.getEndTime();
        final endDateStr = (rawEnd.year >= 2100)
            ? "offen"
            : DateFormat("dd.MM.yyyy").format(rawEnd);

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
                  " Tage\n\n " +
                  startDateStr +
                  " \n - \n " +
                  endDateStr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: width * 0.04),
            ),
          ),
        );
      },
    );
  }

  String? getPlannedWeekDates() {
    DateTime newStartDate = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, microsecond: 0,);
    DateTime newEndDate = newStartDate.add(Duration(
        days: 6, hours: 23, minutes: 59, milliseconds: 999, seconds: 59));
    return DateFormat("dd.MM.yyyy").format(newStartDate) +
        " - " +
        DateFormat("dd.MM.yyyy").format(newEndDate);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    _plannedSEController?.dispose();
    _plannedDaysController?.dispose();
    super.dispose();
  }


  Future<void> startWeekNow() async {
    // 1. Aktuelle Woche abschließen (Ende = jetzt - 1 ms)
    Week currentWeek = box.getAt(box.length - 1);
    DateTime now = DateTime.now();

    // Ende der alten Woche setzen: "bis gerade eben"
    final endedAt = now.subtract(Duration(milliseconds: 1));
    currentWeek.endDate = endedAt.millisecondsSinceEpoch;
    await box.putAt(box.length - 1, currentWeek);

    // 2. Neue Woche planen nach den aktuellen Settings-Werten
    final double daysPlanned = settingsBox.get("DaysForNextWeek") + 0.0;
    double sePlanned = settingsBox.get("SEforNextWeek") + 0.0;
    if (sePlanned < 0) {
      sePlanned = 0;
    }

    final startOfToday = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);

    // Ende der neuen Woche: aktuell setzen wir KEIN fixes Ende.
    // Wichtig: Da die Woche jetzt offen bleiben soll, bis man manuell wieder "startWeekNow" drückt,
    // setzen wir vorerst endDate = sehr weit in der Zukunft oder null.
    // Hive-Feld endDate ist int?, also Pflicht. Wir brauchen einen Wert.
    //
    // Wir können zwei Wege gehen:
    // - EndDate = maxInt / placeholder
    // - EndDate = startOfToday + 365 Jahre
    //
    // Empfehlung: Platzhalter weit in der Zukunft, z.B. Jahr 2100.
    final futureEnd = DateTime(2100, 1, 1, 0, 0, 0, 0, 0);

    Week newWeek = Week(
      plannedDay: daysPlanned,
      plannedSE: sePlanned,
      week: box.length,
      // nächste Indexnummer wird neue Woche
      startdate: startOfToday.millisecondsSinceEpoch,
      endDate: futureEnd.millisecondsSinceEpoch,
    );

    await box.add(newWeek);

    // 3. Lokalen State der Page aktualisieren
    setState(() {
      maxWeek = box.length;
      week = newWeek.week!;
      currentWeek = newWeek;
      planSlider = sePlanned;
      daySlider = daysPlanned;
      seValue = newWeek.getSethisWeek();
      dayValue = newWeek.getUsedDays();
      _pageController.jumpToPage(week);
      _currentPageNotifier.value = week;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Neue Woche gestartet')),
    );
  }

  List<Map<String, dynamic>> _getDrinksForWeek(int weekNumber) {
    List<Map<String, dynamic>> result = [];
    for (int i = 0; i < drinksBox.length; i++) {
      final Drinks d = drinksBox.getAt(i);
      if (d.week == weekNumber) {
        final dt = DateTime.fromMillisecondsSinceEpoch(d.date!);
        final timeStr = DateFormat("dd.MM.yyyy HH:mm").format(dt);
        result.add({
          "index": i,          // Index in Hive für späteres Löschen/Bearbeiten
          "name": d.name ?? "Getränk",
          "volume": d.volume ?? 0.0,
          "volumepart": d.volumepart ?? 0.0,
          "time": timeStr,
          "drink": d,
        });
      }
    }
    // optional: sortieren nach Zeit, neueste zuerst
    result.sort((a, b) {
      final da = (a["drink"] as Drinks).date!;
      final db = (b["drink"] as Drinks).date!;
      return db.compareTo(da); // absteigend
    });
    return result;
  }
  Future<void> _showWeekDrinksDialog(int weekNumber) async {
    // Drinks dieser Woche sammeln
    List<Map<String, dynamic>> drinksForWeek = _getDrinksForWeek(weekNumber);

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Wir brauchen StatefulBuilder, weil wir nach Delete/Edit
            // die Liste im Dialog aktualisieren wollen, ohne ihn neu zu öffnen.
            Future<void> refresh() async {
              setState(() {
                // Globale Werte neu berechnen
                seValue = currentWeek.getSethisWeek();
                dayValue = currentWeek.getUsedDays();
              });
              setStateDialog(() {
                drinksForWeek = _getDrinksForWeek(weekNumber);
              });
            }

            Future<void> _confirmDelete(int hiveIndex) async {
              final bool? reallyDelete = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Text("Löschen bestätigen"),
                  content: Text("Getränk wirklich löschen?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text("Abbrechen", style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Löschen", style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              );
              if (reallyDelete == true) {
                drinksBox.deleteAt(hiveIndex);
                await refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Getränk gelöscht")),
                );
              }
            }

            Future<void> _editDrink(int hiveIndex, Drinks drink) async {
              final nameController =
              TextEditingController(text: drink.name ?? "");
              final volumeController =
              TextEditingController(text: (drink.volume ?? 0.0).toString());
              final volPercentController = TextEditingController(
                  text: (drink.volumepart ?? 0.0).toString());

              final bool? saved = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Getränk bearbeiten"),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Name (optional)"),
                          TextField(
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 12),
                          Text("Volumen (ml) *"),
                          TextField(
                            controller: volumeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^\d*\.?\d*")),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text("Volumen% Alkohol *"),
                          TextField(
                            controller: volPercentController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^\d*\.?\d*")),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text("Abbrechen",
                            style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          // Validierung
                          final volText = volumeController.text.trim();
                          final volPctText = volPercentController.text.trim();
                          if (volText.isEmpty || volPctText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Volumen und Volumen% sind Pflicht.")),
                            );
                            return;
                          }

                          try {
                            final newVol = double.parse(volText);
                            final newVolPct = double.parse(volPctText);

                            drink.name = nameController.text.trim().isEmpty
                                ? drink.name
                                : nameController.text.trim();
                            drink.volume = newVol;
                            drink.volumepart = newVolPct;

                            drink.save(); // HiveObject.save()

                            Navigator.of(context).pop(true);
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Ungültige Eingabe.")),
                            );
                          }
                        },
                        child: Text("Speichern",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  );
                },
              );

              if (saved == true) {
                await refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Getränk aktualisiert")),
                );
              }
            }

            return AlertDialog(
              title: Text(
                "Getränke Woche $weekNumber",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: drinksForWeek.isEmpty
                    ? Text("Keine Einträge.")
                    : ListView.separated(
                  shrinkWrap: true,
                  itemCount: drinksForWeek.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, idx) {
                    final entry = drinksForWeek[idx];
                    final drink = entry["drink"] as Drinks;
                    final hiveIndex = entry["index"] as int;
                    final name = entry["name"] as String;
                    final vol = entry["volume"] as double;
                    final volPct = entry["volumepart"] as double;
                    final timeStr = entry["time"] as String;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$name",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Text(
                          "$timeStr",
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[600]),
                        ),
                        Text(
                          "${vol.toStringAsFixed(0)} ml @ ${volPct.toStringAsFixed(1)} vol%",
                          style: TextStyle(fontSize: 13),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                _editDrink(hiveIndex, drink);
                              },
                              child: Text(
                                "Bearbeiten",
                                style: TextStyle(
                                    color:
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _confirmDelete(hiveIndex);
                              },
                              child: Text(
                                "Löschen",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                  Text("Schließen", style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );

    setState(() {
      currentWeek = box.getAt(week);
      seValue = currentWeek.getSethisWeek();
      dayValue = currentWeek.getUsedDays();
    });
  }

}
