import 'package:aloha/Modelle/Drinks.dart';
import 'package:aloha/Modelle/Week.dart';
import 'package:aloha/Widgets/addDrinkButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import '../Modelle/Drinks.dart';
import 'SettingsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = Hive.box('Week');
  final settingsBox = Hive.box("settings");
  final ownBox = Hive.box("own");
  final drinkBox = Hive.box("drinks");
  double? plannedForWeek = 0.0, usedThisWeek = 0.0, plannedDay = 0, usedDay = 0;
  bool fastAdd = false;
  late Week currentWeek;

  @override
  void initState() {
    if (ownBox.get("name") == null ||
        ownBox.get("name-1") == null ||
        ownBox.get("name-2") == null ||
        ownBox.get("name-3") == null) {
      createOwnBox();
    }
    try {
      weekTest();
      print("Current Week: " + box.getAt(box.length - 1).toString());
      currentWeek = box.getAt(box.length - 1);
      plannedDay = currentWeek.plannedDay;
      plannedForWeek = currentWeek.plannedSE;
      usedThisWeek = currentWeek.getSethisWeek();
      usedDay = currentWeek.getUsedDays();
    } catch (e) {
      usedThisWeek = 0;
      usedDay = 0;
      plannedDay = 0;
      plannedForWeek = 0;
    }

    super.initState();
    print("HomePage initialized");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    try {
      weekTest();
      print(box.getAt(box.length - 1).toString());
      currentWeek = box.getAt(box.length - 1);
      plannedDay = currentWeek.plannedDay;
      plannedForWeek = currentWeek.plannedSE;
      usedThisWeek = currentWeek.getSethisWeek();
      usedDay = currentWeek.getUsedDays();
    } catch (e) {
      usedThisWeek = 0;
      usedDay = 0;
      plannedDay = 0;
      plannedForWeek = 0;
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: width * 0.05, right: width * .05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image(
                      image: AssetImage('assets/bruecke-augsburg-logo.png'),
                      width: width * 0.4,
                      height: height * 0.1,
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.settings,
                        size: height * 0.05,
                      ),
                      onTap: openSettings,
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    "Tage: " +
                        plannedDay!.toInt().toString() +
                        " SE: " +
                        plannedForWeek!.toStringAsPrecision(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.09,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Tage: " + usedDay!.toInt().toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.09,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          " SE: " + usedThisWeek!.toStringAsPrecision(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.09,
                            color: Colors.red,
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            child: Image(
              image: AssetImage('assets/Aloha-PNG.png'),
              width: width * 0.4,
              height: height * 0.3,
            ),
            onTap: () {
              onTap();
            },
          ),
          Column(
            children: [
              Row(
                children: [
                  AddDrinkButton(
                    id: 0,
                    onTap: () {
                      onTapId(0);
                    },
                    height: height * 0.15,
                    width: width * 0.5,
                  ),
                  AddDrinkButton(
                    onTap: () {
                      onTapId(1);
                    },
                    id: 1,
                    height: height * 0.15,
                    width: width * 0.5,
                  ),
                ],
              ),
              Row(
                children: [
                  AddDrinkButton(
                    onTap: () {
                      onTapId(2);
                    },
                    id: 2,
                    height: height * 0.15,
                    width: width * 0.5,
                  ),
                  AddDrinkButton(
                    onTap: () {
                      onTapId(3);
                    },
                    id: 3,
                    height: height * 0.15,
                    width: width * 0.5,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Setz den Wert der Session ein - Deprecated bzw. nicht genutztes Feature
  int? getCurrentSession() {
    int? session = 0;
    for (int i = 0; i < drinkBox.length; i++) {
      Drinks current = drinkBox.getAt(i);
      if (current.session! > session!) {
        session = current.session;
      }
    }
    return session;
  }

  /// Returns the value of the ownDrink volumen
  double? checkVolume() {
    double volume = ownBox.get("volumen") + 0.0;
    return volume;
  }

  /// Returns the value of the ownDrink volumenpart
  double? checkVolumePart() {
    double volumePart = ownBox.get("volumenpart") + 0.0;
    return volumePart;
  }

  /// Returns the value of the ownDrink name
  String? getName() {
    String name = ownBox.get("name");
    return name;
  }

  /// Checks if the week planned surpassed and creates a new one
  Future<void> weekTest() async {
    Week currentWeek = box.getAt(box.length - 1);
    int now = DateTime.now().millisecondsSinceEpoch;
    print(DateTime.now().toString() +
        " - " +
        currentWeek.getEndTime().toString());
    while (now > currentWeek.endDate!) {
      print("WeekTest: " +
          DateTime.now().toString() +
          " - " +
          currentWeek.getEndTime().toString());
      DateTime newStartDate = currentWeek.getStartDate().add(Duration(days: 7));
      DateTime newEndDate = newStartDate.add(
        Duration(
          days: 7,
        ),
      );
      double days = settingsBox.get("DaysForNextWeek");
      double sePlanned = settingsBox.get("SEforNextWeek");
      if (sePlanned < 0) {
        sePlanned = 0;
      }
      Week newWeek = Week(
          plannedDay: days,
          plannedSE: sePlanned,
          week: box.length,
          startdate: newStartDate.millisecondsSinceEpoch,
          endDate: newEndDate.millisecondsSinceEpoch - 1);
      box.add(newWeek);
      settingsBox.put("SEforNextWeek", sePlanned);
      currentWeek = box.getAt(box.length - 1);
      print("New Week Added: " + newWeek.toString());
    }
  }

  /// WIrd ausgeführt, wenn der User von der CameraPage zurück kommt. Es aktualisiert die Werte entsprechend der Eingabe
  Future<void> onComeBack() async {
    setState(() {
      usedThisWeek = currentWeek.getSethisWeek();
      usedDay = currentWeek.getUsedDays();
    });
  }

  /// Erstellt entsprechend der Auswahl ein Getränk mit den FastAdd Eigenschaften oder öfnet die CameraPage
  void onTap() {
    Navigator.of(context).pushNamed('/camera').then((value) => onComeBack());
  }

  /// Öffnet das Einstellugnsmenu
  Future<void> openSettings() async {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  String getNameId(int id) {
    switch (id) {
      case 0:
        return ownBox.get("name");
      case 1:
        return ownBox.get("name-1");
      case 2:
        return ownBox.get("name-2");
      case 3:
        return ownBox.get("name-3");
      default:
        return "Name";
    }
  }

  double getVolumeId(int id) {
    switch (id) {
      case 0:
        return ownBox.get("volumen") + 0.0;
      case 1:
        return ownBox.get("volumen-1") + 0.0;
      case 2:
        return ownBox.get("volumen-2") + 0.0;
      case 3:
        return ownBox.get("volumen-3") + 0.0;
      default:
        return 0.0;
    }
  }

  double getVolumePartId(int id) {
    switch (id) {
      case 0:
        return ownBox.get("volumenpart") + 0.0;
      case 1:
        return ownBox.get("volumenpart-1") + 0.0;
      case 2:
        return ownBox.get("volumenpart-2") + 0.0;
      case 3:
        return ownBox.get("volumenpart-3") + 0.0;
      default:
        return 0.0;
    }
  }

  /// Erstellt getränk nach owndrink Nummer
  void onTapId(int id) {
    var name = getNameId(id);
    var volumen = getVolumeId(id);
    var volumenpart = getVolumePartId(id);
    Drinks current = Drinks(
      week: currentWeek.week,
      session: getCurrentSession(),
      name: name,
      date: DateTime.now().millisecondsSinceEpoch,
      volume: volumen,
      volumepart: volumenpart,
      uri: null,
    );
    drinkBox.add(current);
    setState(() {
      usedThisWeek = currentWeek.getSethisWeek();
      usedDay = currentWeek.getUsedDays();
    });
    print("Added drink: " + current.toString());
    var snackBar = SnackBar(content: Text('Getränk $name hinzugefügt'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void createOwnBox() {
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
  }
}

class OutputText extends StatefulWidget {
  const OutputText(
      {Key? key,
      required this.usedDay,
      required this.plannedDay,
      required this.usedThisWeek,
      required this.plannedForWeek,
      required this.width})
      : super(key: key);
  final double usedDay, plannedDay, usedThisWeek, plannedForWeek, width;

  @override
  _OutputTextState2 createState() => _OutputTextState2(
      plannedDay: plannedDay,
      plannedForWeek: plannedForWeek,
      usedDay: usedDay,
      usedThisWeek: usedThisWeek,
      width: width);
}

class _OutputTextState2 extends State<OutputText> {
  _OutputTextState2(
      {required this.usedDay,
      required this.plannedDay,
      required this.usedThisWeek,
      required this.plannedForWeek,
      required this.width});

  final double usedDay, plannedDay, usedThisWeek, plannedForWeek, width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Tage: " +
              plannedDay.toInt().toString() +
              " SE: " +
              plannedForWeek.toStringAsPrecision(2),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: width * 0.09,
            color: Colors.green,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tage: " + usedDay.toInt().toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.09,
                  color: Colors.red,
                ),
              ),
              Text(
                " SE: " + usedThisWeek.toStringAsPrecision(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.09,
                  color: Colors.red,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ],
    );
  }
}
