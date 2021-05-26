import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../Drinks.dart';
import '../MyApp.dart';
import '../main.dart';

class DetailsTab extends StatefulWidget {
  final int id;

  DetailsTab(this.id);

  @override
  _DetailsTabState createState() => _DetailsTabState(id);
}

class _DetailsTabState extends State<DetailsTab> {
  final int id;
  final box = Hive.box("drinks");
  Drinks? current;
  SizedBox? _image;
  DateTime? date;
  String buttonText = "Ändern";
  bool edit = false;
  String? name;
  double? volume, volumePart;
  TextEditingController nameController = TextEditingController(text: "Name");
  TextEditingController volumeController =
      TextEditingController(text: "1000.0");
  TextEditingController volumePartController = TextEditingController(text: "5");

  @override
  void initState() {
    current = box.getAt(id);
    _image = current!.getImage(255.0, 286.0);
    date = DateTime.fromMillisecondsSinceEpoch(current!.date!);
    nameController = TextEditingController(text: current!.name);
    volumeController = TextEditingController(text: current!.volume.toString());
    volumePartController =
        TextEditingController(text: current!.volumepart.toString());

    super.initState();
    print("Details initialized");
  }

  _DetailsTabState(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _image == null
                  ? Icon(
                      Icons.autorenew_sharp,
                      size: 255,
                    )
                  : _image,
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("Name: "),
                        Visibility(
                          child: Text(current!.name!),
                          visible: !edit,
                        ),
                        Visibility(
                          child: SizedBox(
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
                          visible: edit,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Volumen: ",
                        ),
                        Visibility(
                          child: Text(current!.volume.toString() + " ml"),
                          visible: !edit,
                        ),
                        Visibility(
                            visible: edit,
                            child: SizedBox(
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
                                          color:
                                              Theme.of(context).primaryColor)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                                controller: volumeController,
                                onSubmitted: (value) {},
                              ),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("Volumenprozent: "),
                        Visibility(
                          child:
                              Text(current!.volumepart.toString() + " \u2030"),
                          visible: !edit,
                        ),
                        Visibility(
                          child: SizedBox(
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
                              onSubmitted: (value) {},
                            ),
                          ),
                          visible: edit,
                        ),
                      ],
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Theme.of(context).primaryColor,
                          alignment: Alignment.center),
                      child: Text(
                        buttonText,
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        setState(() {
                          edit = !edit;
                          if (edit) {
                            buttonText = "Speichern";
                          } else {
                            buttonText = "Ändern";
                            current!.volume =
                                double.parse(volumeController.text);
                            current!.volumepart =
                                double.parse(volumePartController.text);
                            current!.name = nameController.text;
                            current!.save();
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            date.toString(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          box.deleteAt(id);
          print("Item deleted: " + current.toString());
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        },
      ),
    );
  }
  @override
  void dispose() {
    nameController.dispose();
    volumeController.dispose();
    volumePartController.dispose();
    super.dispose();
  }
}
