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
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      primaryColor: primary,
      backgroundColor: Colors.yellowAccent,
      colorScheme: ColorScheme.light(),
      cardTheme: CardTheme(color: Colors.white60),
      inputDecorationTheme: InputDecorationTheme(
          disabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: primary))),
    );
  }

  ThemeData getNightTheme() {
    return ThemeData(
        fontFamily: "Roboto",
        scaffoldBackgroundColor: Colors.grey.shade900,
        colorScheme: ColorScheme.dark(),
        brightness: Brightness.dark,
        primaryColor: Colors.yellow,
        inputDecorationTheme: InputDecorationTheme(
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
        ),
        cardTheme: CardTheme(color: Colors.black12),
        backgroundColor: Colors.yellowAccent,
        accentColor: Colors.yellowAccent);
  }

  Future<void> setScreenSize(BuildContext context) async {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
