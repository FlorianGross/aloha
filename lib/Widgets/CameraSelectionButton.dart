import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../BrueckeIcons.dart';
import '../SetupSettings.dart';

class CameraSelectionButton extends StatefulWidget {
  const CameraSelectionButton({Key? key, required this.height, required this.width, required this.value}) : super(key: key);
  final height;
  final width;
  final value;
  @override
  _CameraSelectionButtonState createState() => _CameraSelectionButtonState(width: width, height: height, value: value);
}

class _CameraSelectionButtonState extends State<CameraSelectionButton> {
  _CameraSelectionButtonState({required this.value, required this.height, required this.width});
  final height;
  final width;
  final value;
  bool buttonSelectedBool = false;
  final box = Hive.box('drinks');
  final ownBox = Hive.box("own");
  final settings = Hive.box("settings");
  int selectedButton = 2;
  IconData getraenkIcon = BrueckeIcons.beer_1;
  var buttonCentered = MainAxisAlignment.spaceAround;

  ButtonStyle? buttonStyle,
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
          backgroundColor: Colors.white30);

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      style: buttonStyle,
      onPressed: () {
        setState(() {
          selectedButton = 0;
          buttonSelectedBool = !buttonSelectedBool;
         buttonStyle = buttonSelectedBool? buttonSelected : buttonUnselected;
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
              getTextDisplayed(value),
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
    );
  }

  String getTextDisplayed(double value) {
    if(value == 1.0){
      return "Flasche \n $value L";
    }else if(value == 0.02){
      return "Shot \n $value L";
    }
    return "$value L";
  }

}
