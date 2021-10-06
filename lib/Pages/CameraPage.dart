import 'package:aloha/Classification/Classifier.dart';
import 'package:aloha/Classification/ClassifierQuant.dart';
import 'package:aloha/Classification/Utility.dart';
import 'package:aloha/Modelle/Drinks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'dart:io' as Io;
import '../BrueckeIcons.dart';
import '../Modelle/Drinks.dart';
import '../SetupSettings.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final box = Hive.box('drinks');
  final ownBox = Hive.box("own");
  final settings = Hive.box("settings");
  Io.File? _image;
  String? name, uri;
  DateTime? date;
  bool isCustom = false;
  bool isOwn = false;
  bool isNone = true;
  String? ownName;
  double? ownVolume, ownVolumePart;
  String? customName;
  final nameCollector = TextEditingController(text: "Name");
  int? realDate, session, week;
  double? volume, volumepart;
  double volumeSliderMax = 12;
  int selectedButton = 2;
  double _currentSliderValue = 5;
  double _currentSliderValuePart = 0.5;
  IconData getraenkIcon = BrueckeIcons.beer_1;
  double lowValue = 0.2, mediumValue = 0.3, largeValue = 0.5, xLargeValue = 1;
  late Classifier _classifier;
  Image? _imageWidget;
  img.Image? fox;
  Category? category;
  String? dropdownValue = 'Keins';
  List dropdownItems = <String>[
    'Keins',
    'Bier',
    'Schnaps',
    'Wein',
    'Eigenes',
    'Andere'
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
      ),
    );
  }).toList();

  var buttonCentered = MainAxisAlignment.spaceAround;

  ButtonStyle? smallButtonStyle,
      mediumButtonStyle,
      largeButtonStyle,
      xlargeButtonStyle,
      buttonSelected = OutlinedButton.styleFrom(
          side: BorderSide(
            width: 4,
            color: Colors.black,
          ),
          primary: SetupSettings().primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: SetupSettings().primary),
      buttonUnselected = OutlinedButton.styleFrom(
          side: BorderSide(
            width: 4,
            color: Colors.black,
          ),
          primary: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white10);

  @override
  void initState() {
    _classifier = ClassifierQuant();
    smallButtonStyle = buttonUnselected;
    mediumButtonStyle = buttonUnselected;
    largeButtonStyle = buttonSelected;
    xlargeButtonStyle = buttonUnselected;
    ownName = ownBox.get("name");
    ownVolume = ownBox.get("volumen") + 0.0;
    ownVolumePart = ownBox.get("volumenpart") + 0.0;
    super.initState();
    print("Camera initialized");
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _image == null
                          ? CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            )
                          : _imageWidget!),
                  Container(
                    width: width * 0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all()),
                    child: DropdownButton(
                      items: dropdownItems as List<DropdownMenuItem>?,
                      value: dropdownValue,
                      elevation: 19,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold),
                      onChanged: (dynamic value) {
                        setState(() {
                          dropdownValue = value;
                          if (value == "Bier" || value == "Bierflasche") {
                            setState(() {
                              lowValue = 0.2;
                              mediumValue = 0.3;
                              largeValue = 0.5;
                              xLargeValue = 1;
                              _currentSliderValue = 5;
                              volumeSliderMax = 12;
                              getraenkIcon = BrueckeIcons.beer_1;
                              isOwn = false;
                              isCustom = false;
                              isNone = false;
                              buttonCentered = MainAxisAlignment.spaceAround;
                            });
                          } else if (value == "Wein" ||
                              value == "Weinflasche") {
                            setState(() {
                              getraenkIcon = BrueckeIcons.wine_glass;
                              lowValue = 0.1;
                              mediumValue = 0.2;
                              largeValue = 0.7;
                              xLargeValue = 1;
                              volumeSliderMax = 20;
                              _currentSliderValue = 12;
                              isOwn = false;
                              isCustom = false;
                              isNone = false;
                              buttonCentered = MainAxisAlignment.spaceAround;
                            });
                          } else if (value == "Eigenes") {
                            setState(() {
                              isOwn = true;
                              isNone = false;
                              isCustom = false;
                              buttonCentered = MainAxisAlignment.spaceAround;
                            });
                          } else if (value == "Andere") {
                            setState(() {
                              isCustom = true;
                              isNone = false;
                              isOwn = false;
                              buttonCentered = MainAxisAlignment.spaceAround;
                            });
                          } else if (value == "Keins") {
                            setState(() {
                              isNone = true;
                              isCustom = false;
                              isOwn = false;
                              buttonCentered = MainAxisAlignment.center;
                            });
                          } else if (value == "Schnaps") {
                            getraenkIcon = BrueckeIcons.glass;
                            lowValue = 0.02;
                            mediumValue = 0.2;
                            largeValue = 0.7;
                            xLargeValue = 1;
                            volumeSliderMax = 60;
                            _currentSliderValue = 40;
                            isOwn = false;
                            isCustom = false;
                            isNone = false;
                            buttonCentered = MainAxisAlignment.spaceAround;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isCustom,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Name: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                      ),
                      controller: nameCollector,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: isOwn,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Name: $ownName",
                        style: TextStyle(fontSize: width * 0.05),
                      ),
                      Text(
                        "Volumen: $ownVolume ml",
                        style: TextStyle(fontSize: width * 0.05),
                      ),
                      Text(
                        "Volumenprozent: $ownVolumePart vol%",
                        style: TextStyle(fontSize: width * 0.05),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isOwn && !isNone || isCustom,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Volumenprozent: ",
                      style: TextStyle(
                          fontSize: width * 0.05, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _currentSliderValue.toStringAsPrecision(2),
                      style: TextStyle(fontSize: width * 0.04),
                    ),
                    PlatformSlider(
                      value: _currentSliderValue,
                      min: 0,
                      max: volumeSliderMax,
                      divisions: 1000,
                      activeColor: SetupSettings().primary,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
              visible: isCustom,
              child: Card(
                margin: EdgeInsets.all(4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Volumen: ",
                        style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _currentSliderValuePart.toStringAsPrecision(2),
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                      PlatformSlider(
                        activeColor: SetupSettings().primary,
                        value: _currentSliderValuePart,
                        min: 0.0,
                        max: 2.0,
                        divisions: 20,
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValuePart = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )),
          Visibility(
            visible: !isCustom && !isOwn && !isNone,
            child: Card(
              margin: EdgeInsets.all(4),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Volumen: ",
                        style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: smallButtonStyle,
                          onPressed: () {
                            setState(() {
                              selectedButton = 0;
                              smallButtonStyle = buttonSelected;
                              mediumButtonStyle = buttonUnselected;
                              largeButtonStyle = buttonUnselected;
                              xlargeButtonStyle = buttonUnselected;
                            });
                          },
                          child: SizedBox(
                            width: width / 8,
                            height: height / 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  getraenkIcon,
                                  size: width * 0.1,
                                  color: selectedButton != 0
                                      ? (settings.get("darkmode")
                                          ? Theme.of(context).primaryColor
                                          : Colors.black)
                                      : Colors.black,
                                ),
                                Text(
                                  getTextDisplayed(lowValue),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selectedButton != 0
                                          ? (settings.get("darkmode")
                                              ? Theme.of(context).primaryColor
                                              : Colors.black)
                                          : Colors.black,
                                      fontSize: width * 0.035),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: mediumButtonStyle,
                          onPressed: () {
                            setState(() {
                              selectedButton = 1;
                              mediumButtonStyle = buttonSelected;
                              smallButtonStyle = buttonUnselected;
                              largeButtonStyle = buttonUnselected;
                              xlargeButtonStyle = buttonUnselected;
                            });
                          },
                          child: SizedBox(
                            width: width / 8,
                            height: height / 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  getraenkIcon,
                                  size: width * 0.11,
                                  color: selectedButton != 1
                                      ? (settings.get("darkmode")
                                          ? Theme.of(context).primaryColor
                                          : Colors.black)
                                      : Colors.black,
                                ),
                                Text(
                                  getTextDisplayed(mediumValue),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selectedButton != 1
                                          ? (settings.get("darkmode")
                                              ? Theme.of(context).primaryColor
                                              : Colors.black)
                                          : Colors.black,
                                      fontSize: width * 0.035),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: largeButtonStyle,
                          onPressed: () {
                            setState(() {
                              selectedButton = 2;
                              largeButtonStyle = buttonSelected;
                              smallButtonStyle = buttonUnselected;
                              mediumButtonStyle = buttonUnselected;
                              xlargeButtonStyle = buttonUnselected;
                            });
                          },
                          child: SizedBox(
                            width: width / 8,
                            height: height / 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  getraenkIcon,
                                  size: width * 0.12,
                                  color: selectedButton != 2
                                      ? (settings.get("darkmode")
                                          ? Theme.of(context).primaryColor
                                          : Colors.black)
                                      : Colors.black,
                                ),
                                Text(
                                  getTextDisplayed(largeValue),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selectedButton != 2
                                          ? (settings.get("darkmode")
                                              ? Theme.of(context).primaryColor
                                              : Colors.black)
                                          : Colors.black,
                                      fontSize: width * 0.035),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: xlargeButtonStyle,
                          onPressed: () {
                            setState(() {
                              selectedButton = 3;
                              xlargeButtonStyle = buttonSelected;
                              smallButtonStyle = buttonUnselected;
                              mediumButtonStyle = buttonUnselected;
                              largeButtonStyle = buttonUnselected;
                            });
                          },
                          child: SizedBox(
                            width: width / 8,
                            height: height / 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  getraenkIcon,
                                  size: width * 0.13,
                                  color: selectedButton != 3
                                      ? (settings.get("darkmode")
                                          ? Theme.of(context).primaryColor
                                          : Colors.black)
                                      : Colors.black,
                                ),
                                Text(
                                  getTextDisplayed(xLargeValue),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selectedButton != 3
                                          ? (settings.get("darkmode")
                                              ? Theme.of(context).primaryColor
                                              : Colors.black)
                                          : Colors.black,
                                      fontSize: width * 0.035),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    primary: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Abbrechen",
                  style: TextStyle(
                      fontSize: width * 0.05, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    primary: Colors.black),
                onPressed: () {
                  getImage();
                },
                child: Text(
                  "Nochmal",
                  style: TextStyle(
                      fontSize: width * 0.05, fontWeight: FontWeight.bold),
                ),
              ),
              Visibility(
                visible: !isNone,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      primary: Colors.black),
                  onPressed: () {
                    save(context);
                  },
                  child: Text(
                    "Speichern",
                    style: TextStyle(
                        fontSize: width * 0.05, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Benutzt die ImagePicker funktion der Kamera. Bei Fehler wird die Seite geschlossen und eine SnackBar angezeigt.
  Future<void> getImage() async {
    print("Started importing Image");
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _image = Io.File(image!.path);
        _imageWidget = Image.file(
          _image!,
          height: 200,
        );
      });
      _predict();
    } catch (e) {
      var snackBar = SnackBar(
        content: Text("Problem mit Ihrer Kamera"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
  }

  /// Startet den Prozess der Bilderkennung
  Future<void> _predict() async {
    print("Started predicting Image");
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    var prediction = _classifier.predict(imageInput);
    setState(() {
      this.category = prediction;
      checkPred(prediction);
    });
  }

  /// Speichert das erstellte Getränk in der Hive DB
  Future<void> save(BuildContext context) async {
    DateTime date = DateTime.now();
    session = 0;
    String imgString = Utility.base64String(_image!.readAsBytesSync());
    Drinks getraenk = new Drinks(
      uri: imgString,
      volumepart: await checkVolumePart(dropdownValue),
      volume: await checkVolume(dropdownValue),
      date: date.millisecondsSinceEpoch,
      name: await getName(dropdownValue),
      session: session,
      week: await getWeek(),
    );
    box.add(getraenk);
    print("Image saved: " + getraenk.toString());

    Navigator.pop(context);
  }

  /// Überprüft die Prediction des ML Prozesses und stellt entsprechendes Element im Dropdown Menu ein
  Future<void> checkPred(Category pred) async {
    switch (pred.label) {
      case "Bierflasche":
        setState(() {
          dropdownValue = "Bier";
          getraenkIcon = BrueckeIcons.beer_1;
          largeButtonStyle = buttonSelected;
          selectedButton = 2;
          lowValue = 0.2;
          mediumValue = 0.3;
          largeValue = 0.5;
          xLargeValue = 1;
          _currentSliderValue = 5;
        });
        break;
      case "Bier":
        setState(() {
          dropdownValue = "Bier";
          getraenkIcon = BrueckeIcons.beer_1;
          largeButtonStyle = buttonSelected;
          selectedButton = 2;
          lowValue = 0.2;
          mediumValue = 0.3;
          largeValue = 0.5;
          _currentSliderValue = 5;
          xLargeValue = 1;
        });
        break;
      case "Weinflasche":
        setState(() {
          dropdownValue = "Wein";
          getraenkIcon = BrueckeIcons.wine_glass;
          xlargeButtonStyle = buttonSelected;
          selectedButton = 3;
          lowValue = 0.1;
          mediumValue = 0.2;
          largeValue = 0.75;
          xLargeValue = 1;
          _currentSliderValue = 12;
        });
        break;
      case "Wein":
        setState(() {
          dropdownValue = "Wein";
          getraenkIcon = BrueckeIcons.wine_glass;
          mediumButtonStyle = buttonSelected;
          selectedButton = 2;
          lowValue = 0.1;
          mediumValue = 0.2;
          largeValue = 0.75;
          xLargeValue = 1;
          _currentSliderValue = 12;
        });
        break;
      case "Schnaps":
        setState(() {
          dropdownValue = "Schnaps";
          getraenkIcon = BrueckeIcons.glass;
          mediumButtonStyle = buttonSelected;
          selectedButton = 2;
          lowValue = 0.02;
          mediumValue = 0.2;
          largeValue = 0.7;
          xLargeValue = 1;
          _currentSliderValue = 40;
        });
        break;
      default:
        dropdownValue = "Keins";
        break;
    }
  }

  /// Überprüft die Auswahl des Dropdown Menus und gibt entsprechend den Wert der Auswahl zurück
  Future<double?> checkVolume(String? name) async {
    if (name == "Bier" || name == "Wein" || name == "Schnaps") {
      switch (selectedButton) {
        case 0:
          return lowValue * 1000;
        case 1:
          return mediumValue * 1000;
        case 2:
          return largeValue * 1000;
        case 3:
          return xLargeValue * 1000;
        default:
          return -1;
      }
    } else if (name == "Eigenes") {
      return ownBox.get("volumen");
    } else if (name == "Andere") {
      return _currentSliderValuePart;
    } else
      return 0;
  }

  /// Überprüft die Auswahl des Dropdownmemus und gibt entsprechend den Wert der Auswahl an
  Future<double?> checkVolumePart(String? name) async {
    if (name == "Bier" ||
        name == "Wein" ||
        name == "Andere" ||
        name == "Schnaps") {
      return _currentSliderValue;
    } else if (name == "Eigenes") {
      return ownBox.get("volumenpart");
    } else
      return 0;
  }

  /// Setzt den Namen der Auswahl in das Namensfeld des Getränke Objekts ein
  Future<String?> getName(String? name) async {
    if (name == "Bier" || name == "Wein" || name == "Schnaps") {
      return name;
    } else if (name == "Eigenes") {
      return ownBox.get("name");
    } else if (name == "Andere") {
      customName = nameCollector.text;
      return customName.toString();
    } else {
      print("Name = " + name.toString());
      return "Name";
    }
  }

  /// Gibt den Interator der Hive DB mit den Wochen an und returnt die letze Woche
  Future<int> getWeek() async {
    if (box.isNotEmpty && box.getAt(0) != null) {
      Drinks first = box.getAt(0);
      DateTime now = DateTime.now();
      DateTime firstTime = DateTime.fromMillisecondsSinceEpoch(first.date!);
      Duration duration = now.difference(firstTime);
      double resultDouble = duration.inDays / 7;
      int result = resultDouble.toInt();
      print("$result Woche");
      return result;
    } else {
      return 0;
    }
  }

  String getTextDisplayed(double value) {
    if(value == 1.0){
      return "Flasche \n $value L";
    }else if(value == 0.02){
      return "Shot \n $value L";
    }else if(value == 0.2){
      return "Glas \n $value L";
    }
    return "$value L";
  }

  @override
  void dispose() {
    nameCollector.dispose();
    super.dispose();
  }
}
