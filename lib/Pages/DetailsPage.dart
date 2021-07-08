import 'package:aloha/Modelle/Drinks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../Modelle/Drinks.dart';
import '../MyApp.dart';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    _image = current!.getImage(height * 0.3, width * 0.3, width * 0.3);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Getränk: " + current!.name.toString(),
                  style: TextStyle(fontSize: width * 0.05),
                ),
                ElevatedButton(
                  child: Icon(
                    Icons.arrow_back,
                    size: width * 0.08,
                  ),
                  onPressed: pop,
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          Card(
            child: Padding(padding: const EdgeInsets.all(8.0), child: _image),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(width * 0.03),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name:           ",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                          Visibility(
                            child: SizedBox(
                              width: width * 0.4,
                              child: Text(
                                current!.name!,
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: width * 0.04),
                              ),
                            ),
                            visible: !edit,
                          ),
                          Visibility(
                            child: SizedBox(
                              width: width * 0.4,
                              height: height * 0.08,
                              child: TextField(
                                maxLength: 10,
                                style: TextStyle(fontSize: width * 0.03),
                                controller: nameController,
                              ),
                            ),
                            visible: edit,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height*0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Volumen:        ",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                          Visibility(
                            child: SizedBox(
                              width: width * 0.4,
                              child: Text(
                                current!.volume!.toInt().toString() + " ml",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: width * 0.04),
                              ),
                            ),
                            visible: !edit,
                          ),
                          Visibility(
                            visible: edit,
                            child: SizedBox(
                              width: width * 0.4,
                              height: height * 0.08,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                maxLength: 5,
                                style: TextStyle(fontSize: width * 0.03),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"^\d*"))
                                ],
                                controller: volumeController,
                                onSubmitted: (value) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Volumenprozent: ",
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                          Visibility(
                            child: SizedBox(
                              width: width * 0.4,
                              child: Text(
                                current!.volumepart.toString() + " \u2030",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: width * 0.04),
                              ),
                            ),
                            visible: !edit,
                          ),
                          Visibility(
                            child: SizedBox(
                              width: width * 0.4,
                              height: height * 0.08,
                              child: TextField(
                                decoration: InputDecoration(),
                                maxLength: 5,
                                style: TextStyle(fontSize: width * 0.03),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"^\d*\.?\d*"))
                                ],
                                keyboardType: TextInputType.number,
                                controller: volumePartController,
                                onSubmitted: (value) {},
                              ),
                            ),
                            visible: edit,
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Theme.of(context).primaryColor,
                          alignment: Alignment.center),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                            color: Colors.black, fontSize: width * 0.03),
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
            style: TextStyle(fontSize: width * 0.03),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: width * 0.12,
        height: height * 0.12,
        child: FloatingActionButton(
          child: Icon(
            Icons.delete,
            size: width * 0.07,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            box.deleteAt(id);
            print("Item deleted: " + current.toString());
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
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

  Future<void> pop() async {
    Navigator.pop(context);
  }
}
