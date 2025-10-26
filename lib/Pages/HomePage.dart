import 'package:aloha/Modelle/Drinks.dart';
import 'package:aloha/Modelle/Week.dart';
import 'package:aloha/Widgets/AddDrinkButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../BrueckeIcons.dart';
import '../Modelle/Drinks.dart';
import '../Widgets/AddCustomDrinkButton.dart';
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
    try {
      currentWeek = box.getAt(box.length - 1);
      plannedDay = currentWeek.plannedDay;
      plannedForWeek = currentWeek.plannedSE;
      usedThisWeek = currentWeek.getSethisWeek();
      usedDay = currentWeek.getUsedDays();
    } catch (e) {
      // fallback wie gehabt
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
      currentWeek = box.getAt(box.length - 1);
      plannedDay = currentWeek.plannedDay;
      plannedForWeek = currentWeek.plannedSE;
      usedThisWeek = currentWeek.getSethisWeek();
      usedDay = currentWeek.getUsedDays();
    } catch (e) {
      // fallback wie gehabt
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
                        "     SE: " +
                        plannedForWeek!.toStringAsFixed(1),
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
                          "    SE: " + usedThisWeek!.toStringAsFixed(1),
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
          Image(
            image: AssetImage('assets/Aloha-PNG.png'),
            width: width * 0.4,
            height: height * 0.3,
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
              AddCustomDrinkButton(
                onTap: () {
                  onTapCustomDrink();
                },
                id: 3,
                height: height * 0.1,
                width: width,
              ),
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

  /// WIrd ausgeführt, wenn der User von der CameraPage zurück kommt. Es aktualisiert die Werte entsprechend der Eingabe
  Future<void> onComeBack() async {
    setState(() {
      usedThisWeek = currentWeek.getSethisWeek();
      usedDay = currentWeek.getUsedDays();
    });
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
        return "Bier";
      case 1:
        return "Shot";
      default:
        return "";
    }
  }

  double getVolumeId(int id){
    switch(id){
      case 0: return 500;
      case 1: return 40;
      default: return 0.0;
    }
  }

  double getVolumePartId(int id) {
    switch (id) {
      case 0:
        return 5.0;
      case 1:
        return 40.0;
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

  Future<void> onTapCustomDrink() async {
    double? volumeMl;
    double? volPercent;
    String? customName;
    int? customIconIndex;

    await showDialog(
      context: context,
      barrierDismissible: false, // Nutzer muss aktiv bestätigen / abbrechen
      builder: (context) {
        // Controller lokal im Dialog halten
        final TextEditingController nameController = TextEditingController();
        final TextEditingController volumeController = TextEditingController();
        final TextEditingController volPercentController = TextEditingController();

        // Icon-Auswahl-State muss über StatefulBuilder gemanaged werden
        int dropdownIconValue = 0;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                "Getränk hinzufügen",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Volumen (ml) *",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    TextField(
                      controller: volumeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*")),
                      ],
                      decoration: InputDecoration(
                        hintText: "z.B. 500",
                      ),
                    ),
                    SizedBox(height: 16),

                    // Alkoholgehalt vol% (Pflicht)
                    Text(
                      "Volumen% Alkohol *",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    TextField(
                      controller: volPercentController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*")),
                      ],
                      decoration: InputDecoration(
                        hintText: "z.B. 5.0",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "Abbrechen",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dialog schließen ohne Speichern
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    "Hinzufügen",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    // Validierung der Pflichtfelder
                    if (volumeController.text.trim().isEmpty ||
                        volPercentController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Bitte Volumen und Volumen% ausfüllen.",
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      final parsedVol = double.parse(volumeController.text.trim());
                      final parsedVolPercent = double.parse(volPercentController.text.trim());

                      volumeMl = parsedVol;
                      volPercent = parsedVolPercent;
                      customName = nameController.text.trim().isEmpty
                          ? null
                          : nameController.text.trim();
                      customIconIndex = dropdownIconValue;

                      Navigator.of(context).pop(); // Dialog schließen -> Erfolg
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Ungültige Eingabe."),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    // Wenn der Nutzer abgebrochen hat, sind volumeMl / volPercent null -> dann nichts tun
    if (volumeMl == null || volPercent == null) {
      return;
    }

    // Jetzt Getränk in Hive schreiben.
    // Name-Fallback:
    final drinkName = customName ?? "Sonstiges";

    Drinks newDrink = Drinks(
      week: currentWeek.week,
      session: getCurrentSession(),
      name: "Sonstiges",
      date: DateTime.now().millisecondsSinceEpoch,
      volume: volumeMl,
      volumepart: volPercent,
      uri: null,
    );

    drinkBox.add(newDrink);

    setState(() {
      usedThisWeek = currentWeek.getSethisWeek();
      usedDay = currentWeek.getUsedDays();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Getränk $drinkName hinzugefügt')),
    );
  }

}
