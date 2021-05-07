import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationsSettings;

  BehaviorSubject<RecieveNotification> get didRecieveLocalNotificationSubject =>
      BehaviorSubject<RecieveNotification>();

  LocalNotifyManager.init() {
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  void requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(alert: true, sound: true, badge: true);
  }

  void initializePlatform() {
    var androidInitilize = new AndroidInitializationSettings('alcoly_logo');
    var iOSinitilize = new IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          RecieveNotification notification = RecieveNotification(
              id: id, title: title!, body: body!, payload: payload!);
          didRecieveLocalNotificationSubject.add(notification);
        });
    initializationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  setOnNotificationRecieve(Function onNotificationRecieve) {
    didRecieveLocalNotificationSubject.listen((notification) {
      onNotificationRecieve(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onSelectNotification: (payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    var androidChannel = AndroidNotificationDetails(
        "CHANNEL_ID", "CHANNEL_NAME", "CHANNEL_DESCRIPTION",
        importance: Importance.max,
        priority: Priority.high,
        icon: 'alcoly_logo');
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(
        0, "TestTitle", "TestBody", platformChannel,
        payload: "New Payload");
  }

  Future<void> scheduleNotificationNew(int day, int hour, int minute) async {
    DateTime plannedDay = DateTime.now();
    while (DateTime.now().weekday < day) {
      plannedDay.add(Duration(days: 1));
    }
    tz.initializeTimeZones();
    tz.TZDateTime dateTime = tz.TZDateTime(tz.local, plannedDay.year,
        plannedDay.month, plannedDay.day, hour, minute);
    var androidChannel = AndroidNotificationDetails(
      "CHANNEL_ID",
      "CHANNEL_NAME",
      "CHANNEL_DESCRIPTION",
      importance: Importance.max,
      priority: Priority.high,
      icon: 'alcoly_logo',
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      day,
      "Getränke Scannen",
      "Hast du heute vor etwas zu trinken? - Scannen nicht vergessen!",
      dateTime,
      platformChannel,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: "New Payload",
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

class RecieveNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  RecieveNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}
