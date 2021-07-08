import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetupSettings {
  double screenWidth = 100;
  double screenHeight = 100;
  Color backgroundColor = Colors.black26;
  Color textSelected = Colors.black;
  Color textUnselected = Colors.white;
  Color primary = Colors.yellow;
  Color primaryAccent = Colors.yellowAccent;

  ThemeData getMaterialDayTheme() {
    return ThemeData(
      fontFamily: "Roboto",
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      primaryColor: primary,
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

  CupertinoThemeData getCupertinoDayTheme(){

    return CupertinoThemeData(primaryColor: primary, brightness: Brightness.light, scaffoldBackgroundColor: Colors.white);
  }

  CupertinoThemeData getCupertinoNightTheme(){

    return CupertinoThemeData(primaryColor: primary, brightness: Brightness.dark, scaffoldBackgroundColor: Colors.black26);
  }

}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    print("Theme toggled to: " + themeMode.toString());
    notifyListeners();
  }
}
