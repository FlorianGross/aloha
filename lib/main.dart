import 'package:aloha/Pages/CameraPage.dart';
import 'package:aloha/Pages/SettingsPage.dart';
import 'package:aloha/SetupSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'Modelle/Drinks.dart';
import 'Notifications.dart';
import 'Modelle/Week.dart';
import 'MyApp.dart';
import 'Pages/FirstStartPage.dart';
import 'Pages/HomePage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  LocalNotifyManager.init();
  tz.initializeTimeZones();
  await setupTimeZone();
  await Hive.initFlutter();
  Hive.registerAdapter(DrinksAdapter());
  Hive.registerAdapter(WeekAdapter());
  await Hive.openBox("drinks");
  await Hive.openBox("settings");
  await Hive.openBox("Week");
  await Hive.openBox("own");
  print("Hive initialized");
  var box = Hive.box("settings");
  if (box.isEmpty) {
    print("Box empty");
    box.put("darkmode", true);
    box.put("audio", true);
    box.put("firstStart", true);
    box.put("notifications", true);
    DateTime now = DateTime.now();
    box.put("firstStartDate",
        DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0));
    print("Standard settings loaded: " + box.toMap().toString());
  }
  var home;
  if (box.get("firstStart")) {
    home = FirstStartPage();
  } else {
    home = MyApp();
  }
  runApp(ExecApp(home));
}

Future<void> setupTimeZone() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
}

class ExecApp extends StatelessWidget {
  ExecApp(this.home);

  final home;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return PlatformApp(
            home: home,
            material: (context, platform) {
              return MaterialAppData(
                themeMode: themeProvider.themeMode,
                theme: SetupSettings().getMaterialDayTheme(),
                darkTheme: SetupSettings().getMaterialNightTheme(),
              );
            },
            cupertino: (context, platform) {
              return CupertinoAppData(
                  theme: CupertinoThemeData(
                      primaryColor: Colors.yellow,
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor: Colors.black26));
            },
            routes: <String, WidgetBuilder>{
              '/homePage': (BuildContext context) => new HomePage(),
              '/camera': (BuildContext context) => new Camera(),
              '/settings': (BuildContext context) => new Settings(),
              '/firstStart': (BuildContext context) => new FirstStartPage(),
            },
          );
        },
      );
}
