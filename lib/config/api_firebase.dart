
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../main.dart';

/*
Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}


class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage message) {
    navigatorKey.currentState?.pushReplacementNamed('/', arguments: message);
    //navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CustomNavBar()));
  }

  Future initPushNotification() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
*/

Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}


class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notification',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message){
    if (message==null) return;

    navigatorKey.currentState?.pushReplacementNamed('/', arguments: message);
    //  NotificationScreen.route,
    //  arguments: message,
    //  );
  }
  Future initLocalNotifications() async{
    //  const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('drawable/enye');
    const settings =  InitializationSettings(android: android);

    await _localNotifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (payload){
          final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
          handleMessage(message);
        }
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotification() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if(notification==null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/enye',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }


  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    await SessionManager().set("token", fCMToken);
    print('Token: $fCMToken');
    initPushNotification();
    initLocalNotifications();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}