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
                Text(name, style: TextStyle(fontSize: 0.07*width),),
                Text("$volumePart vol%", style: TextStyle(fontSize: 0.07*width),),
                Text("$volume ml", style: TextStyle(fontSize: 0.07*width),),
                Text("$se SE", style: TextStyle(fontSize: 0.07*width, color: Colors.red),)
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
        return 0;
      case 1:
        return 1;
      default:
        return 0;
    }
  }

  String getNameId(int id){
    switch(id){
      case 0: return "Bier";
      case 1: return "Shot";
      default: return "Name";
    }
  }

  double getVolumeId(int id){
    switch(id){
      case 0: return 500;
      case 1: return 40;
      default: return 0.0;
    }
  }

  double getVolumePartId(int id){
    switch(id){
      case 0: return 5.0;
      case 1: return 40.0;
      default: return 0.0;
    }
  }

  getIcon() {
    switch(getIconId(id)){
      case 0: return Icon(BrueckeIcons.beer);
      case 1: return Icon(BrueckeIcons.glass);
    }
  }

}
