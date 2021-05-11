import 'package:aloha/LocalNotifyManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final box = Hive.box("settings");
  final ownBox = Hive.box("own");
  bool? darkmode = true;
  bool? audio = true;
  bool? notifications = true;
  late double ownSE;
  String? name = "Name";
  double? volumen;
  double? volumePart;
  int hour = 0;
  int minute = 0;
  Color selected = Colors.yellow, unselected = Colors.black38;
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
    if (box.get("darkmode") != null &&
        box.get("audio") != null &&
        box.get("notifications") != null) {
      darkmode = box.get("darkmode");
      audio = box.get("audio");
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
    }catch(e){
      minute = 0;
      hour = 18;
      print(e);
    }
    super.initState();
    print("Settings initialized");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "Einstellungen",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            Divider(),
            Card(
              child: ListView(
                padding: EdgeInsets.only(left: 16, right: 16),
                primary: false,
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Darkmode: "),
                      Switch(
                        activeColor: Theme.of(context).primaryColor,
                        value: darkmode!,
                        onChanged: (value) {
                          setState(() {
                            darkmode = value;
                            box.put("darkmode", value);
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Audio: "),
                      Switch(
                        activeColor: Theme.of(context).primaryColor,
                        value: audio!,
                        onChanged: (value) {
                          setState(() {
                            audio = value;
                            box.put("audio", value);
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Benachrichtigungen: "),
                      Switch(
                        activeColor: Theme.of(context).primaryColor,
                        value: notifications!,
                        onChanged: (value) {
                          setState(() {
                            notifications = value;
                            box.put("notifications", value);
                          });
                        },
                      ),
                    ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isMoBut) {
                                      isMoBut = false;
                                      removeNotification(1);
                                      moBut = unselected;
                                    } else {
                                      isMoBut = true;
                                      addNotification(1);
                                      moBut = selected;
                                    }
                                    box.put("isMo", isMoBut);
                                  });
                                },
                                child: Container(
                                  child: Center(
                                    child: Text("Mo"),
                                  ),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: moBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isDiBut) {
                                      isDiBut = false;
                                      removeNotification(2);
                                      diBut = unselected;
                                    } else {
                                      isDiBut = true;
                                      addNotification(2);
                                      diBut = selected;
                                    }
                                    box.put("isDi", isDiBut);
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("Di")),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: diBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isMiBut) {
                                      isMiBut = false;
                                      removeNotification(3);
                                      miBut = unselected;
                                    } else {
                                      isMiBut = true;
                                      addNotification(3);
                                      miBut = selected;
                                    }
                                    box.put("isMi", isMiBut);
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("Mi")),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: miBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isDoBut) {
                                      isDoBut = false;
                                      removeNotification(4);
                                      doBut = unselected;
                                    } else {
                                      isDoBut = true;
                                      addNotification(4);
                                      doBut = selected;
                                    }
                                    box.put("isDo", isDoBut);
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("Do")),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: doBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isFrBut) {
                                      isFrBut = false;
                                      removeNotification(5);
                                      frBut = unselected;
                                    } else {
                                      isFrBut = true;
                                      addNotification(5);
                                      frBut = selected;
                                    }
                                    box.put("isFr", isFrBut);
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("Fr")),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: frBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSaBut) {
                                      isSaBut = false;
                                      removeNotification(6);
                                      saBut = unselected;
                                    } else {
                                      isSaBut = true;
                                      addNotification(6);
                                      saBut = selected;
                                    }
                                    box.put("isSa", isSaBut);
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("Sa")),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: saBut),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSoBut) {
                                      isSoBut = false;
                                      removeNotification(7);
                                      soBut = unselected;
                                    } else {
                                      isSoBut = true;
                                      addNotification(7);
                                      soBut = selected;
                                    }
                                    box.put("isSo", isSoBut);
                                  });
                                },
                                child: Container(
                                  child: Center(child: Text("So")),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: soBut),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: ElevatedButton(
                              child: Text(
                                "Uhrzeit wählen: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.yellow),
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
            Text(
              "Eigenes Getränk",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            Divider(),
            Card(
              child: ListView(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                primary: false,
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Name: "),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
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
                          controller: nameController,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Volumen in ml: "),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"^\d*\.?\d*"))
                          ],
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
                          controller: volumeController,
                          onSubmitted: (value) {
                            setState(() {
                              volumen = double.parse(value);
                              ownSE =
                                  (volumen! * 0.8 * (volumePart! / 1000)) / 2;
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
                      Text("Volumen%: "),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"^\d*\.?\d*"))
                          ],
                          keyboardType: TextInputType.number,
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
                          controller: volumePartController,
                          onSubmitted: (value) {
                            setState(() {
                              volumePart = double.parse(value);
                              ownSE =
                                  (volumen! * 0.8 * (volumePart! / 1000)) / 2;
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
                      Text("Entspricht in SE: "),
                      Text(ownSE.toStringAsPrecision(2) + " SE"),
                    ],
                  ),
                  Divider(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Theme.of(context).primaryColor,
                        alignment: Alignment.center),
                    child: Text(
                      "Speichern",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: confirmOwnDrink,
                  ),
                ],
              ),
            ),
          ],
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
    final newTime =
        await showTimePicker(context: context, initialTime: initialTime);
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
}
