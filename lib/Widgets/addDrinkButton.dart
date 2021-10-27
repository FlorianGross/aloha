import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../BrueckeIcons.dart';

class AddDrinkButton extends StatefulWidget {
  const AddDrinkButton({Key? key, required this.width, required this.height, required this.id, required this.onTap}) : super(key: key);
  final double height, width;
  final int id;
  final onTap;
  @override
  _AddDrinkButtonState createState() => _AddDrinkButtonState(height: height, width: width, id: id, onTap: onTap);
}

class _AddDrinkButtonState extends State<AddDrinkButton> {
  _AddDrinkButtonState({required this.height, required this.width, required this.id, required this.onTap});
  final double height;
  final int id;
  final double width;
  final onTap;
  final ownBox = Hive.box("own");
  String name = "name";
  double volumePart = 5.0;
  double volume = 500.0;
  String se = "1.0";

  @override
  void initState() {
    name = getNameId(id);
    volume = getVolumeId(id);
    volumePart = getVolumePartId(id);
    se = calculateSE(volume, volumePart).toStringAsPrecision(3);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
        child: SizedBox(
          height: height,
          width: width,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getIcon(),
                Text(name),
                Text("$volumePart vol%",),
                Text("$volume ml"),
                Text("$se SE")
              ],
            ),
          ),
        ),
    );
  }


  double calculateSE(double volumen, double volumePart){
    return (volumen * 0.8 * (volumePart / 1000)) / 2;
  }

  int getIconId(int id) {
    switch (id) {
      case 0:
        return ownBox.get("icon");
      case 1:
        return ownBox.get("icon-1");
      case 2:
        return ownBox.get("icon-2");
      case 3:
        return ownBox.get("icon-3");
      default:
        return 0;
    }
  }

  String getNameId(int id){
    switch(id){
      case 0: return ownBox.get("name");
      case 1: return ownBox.get("name-1");
      case 2: return ownBox.get("name-2");
      case 3: return ownBox.get("name-3");
      default: return "Name";
    }
  }

  double getVolumeId(int id){
    switch(id){
      case 0: return ownBox.get("volumen") + 0.0;
      case 1: return ownBox.get("volumen-1") + 0.0;
      case 2: return ownBox.get("volumen-2") + 0.0;
      case 3: return ownBox.get("volumen-3") + 0.0;
      default: return 0.0;
    }
  }

  double getVolumePartId(int id){
    switch(id){
      case 0: return ownBox.get("volumenpart") + 0.0;
      case 1: return ownBox.get("volumenpart-1") + 0.0;
      case 2: return ownBox.get("volumenpart-2") + 0.0;
      case 3: return ownBox.get("volumenpart-3") + 0.0;
      default: return 0.0;
    }
  }

  getIcon() {
    switch(getIconId(id)){
      case 0: return Icon(BrueckeIcons.glass);
      case 1: return Icon(BrueckeIcons.wine_glass);
      case 2: return Icon(BrueckeIcons.wine_bottle);
      case 3: return Icon(BrueckeIcons.glass);
    }
  }

}
