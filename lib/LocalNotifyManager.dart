import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  setOnNotificationRecieve(Function onNotificationRecieve){
    didRecieveLocalNotificationSubject.listen((notification) {
      onNotificationRecieve(notification);
    });
  }
  setOnNotificationClick(Function onNotificationClick) async{
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onSelectNotification: (payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification()async{
    var androidChannel = AndroidNotificationDetails("CHANNEL_ID", "CHANNEL_NAME", "CHANNEL_DESCRIPTION", importance: Importance.max, priority: Priority.high);
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.show(0, "TestTitle", "TestBody", platformChannel, payload: "New Payload");
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
