import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SetupSettings {
  Color backgroundColor = Colors.black26;
  Color textSelected = Colors.black;
  Color textUnselected = Colors.white;
  Color primary = Colors.yellow;
  Color primaryAccent = Colors.yellowAccent;
  Color backCard = Colors.black26;
  Color card = Colors.black12;

  ThemeData getMaterialDayTheme() {
    return ThemeData(
      indicatorColor: primary,
      accentColor: Colors.yellowAccent,
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: primary, selectionHandleColor: primary),
      fontFamily: "Roboto",
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      primaryColor: primary,
      buttonColor: primary,
      timePickerTheme: TimePickerThemeData(
          dialBackgroundColor: primary,
          hourMinuteColor: primary,
          inputDecorationTheme: InputDecorationTheme(
            focusColor: primary,
          ),
          dayPeriodTextColor: Colors.black,
          dialHandColor: Colors.white,
          dialTextColor: Colors.black,
          hourMinuteTextColor: Colors.black,
          backgroundColor: Colors.white),
      backgroundColor: Colors.yellowAccent,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(),
      colorScheme: ColorScheme.light(),
      cardTheme: CardTheme(color: Colors.white60),
      inputDecorationTheme: InputDecorationTheme(
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
      ),
    );
  }

  ThemeData getMaterialNightTheme() {
    return ThemeData(
        fontFamily: "Roboto",
        scaffoldBackgroundColor: Colors.grey.shade900,
        colorScheme: ColorScheme.dark(),
        brightness: Brightness.dark,
        primaryColor: Colors.yellow,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(),
        inputDecorationTheme: InputDecorationTheme(
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
        ),
        cardTheme: CardTheme(color: Colors.black12),
        backgroundColor: Colors.yellowAccent,
        accentColor: Colors.yellowAccent);
  }

  CupertinoThemeData getCupertinoDayTheme() {
    return CupertinoThemeData(
        primaryColor: Colors.yellow,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white);
  }

  CupertinoThemeData getCupertinoNightTheme() {
    return CupertinoThemeData(
        primaryColor: Colors.yellow,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black26);
  }
}

class ThemeProvider extends ChangeNotifier {
  var box = Hive.box("settings");
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool getDarkMode(){
    if(box.get("darkmode")){
      return true;
    }else{
      return false;
    }
  }
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    box.put("darkmode", isOn);
    print("Theme toggled to: " + themeMode.toString());
    notifyListeners();
  }
}
