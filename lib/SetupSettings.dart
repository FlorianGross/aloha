import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SetupSettings {
  Color backgroundColor = Colors.black26;
  Color textSelected = Colors.black;
  Color textUnselected = Colors.white;
  Color primary = Colors.lightBlue;
  Color primaryAccent = Colors.lightBlueAccent;
  Color backCard = Colors.black26;
  Color card = Colors.black12;

  ThemeData getMaterialDayTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(),
      primaryColor: primary,
      fontFamily: "Roboto",
      backgroundColor: primaryAccent,
      cardTheme: CardTheme(color: Colors.white60),
      scaffoldBackgroundColor: Colors.white,
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: primary, selectionHandleColor: primary),
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
    );
  }

  ThemeData getMaterialNightTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(),
      primaryColor: primary,
      fontFamily: "Roboto",
      backgroundColor: primaryAccent,
      indicatorColor: primary,
      cardTheme: CardTheme(color: Colors.black12),
      scaffoldBackgroundColor: Colors.grey.shade900,
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: primary, selectionHandleColor: primary),
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
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  var box = Hive.box("settings");
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  bool getDarkMode() {
    if (box.get("darkmode")) {
      return true;
    } else {
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
