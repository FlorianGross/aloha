import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetupSettings {
  BuildContext? context;
  double screenWidth = 100;
  double screenHeight = 100;
  Color backgroundColor = Colors.black26;
  Color textSelected = Colors.black;
  Color textUnselected = Colors.white;
  Color primary = Colors.yellow;
  Color primaryAccent = Colors.yellowAccent;


  ThemeData getDayTheme() {
    return ThemeData(
        fontFamily: "Roboto",
        brightness: Brightness.light,
        primaryColor: Colors.yellow,
        backgroundColor: Colors.yellowAccent,
        accentColor: Colors.yellowAccent);
  }

  ThemeData getNightTheme() {
    return ThemeData(
        fontFamily: "Roboto",
        brightness: Brightness.dark,
        primaryColor: Colors.yellow,
        backgroundColor: Colors.yellowAccent,
        accentColor: Colors.yellowAccent);
  }

  SetupSettings.init() {
    this.context!;
    setScreenSize(context!);
  }

  Future<void> setScreenSize(BuildContext context) async {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  Future<void> setDarkmode() async {
    backgroundColor = Colors.black26;
    textSelected = Colors.black;
    textUnselected = Colors.white;
  }

  Future<void> setDarkmodeDisabled() async {
    backgroundColor = Colors.white;
    textSelected = Colors.white;
    textUnselected = Colors.black;
  }


}
