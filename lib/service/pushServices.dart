import 'dart:convert';
import 'dart:io' show Platform;

import 'package:aspen_weather/utils/prefs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  var flutterLocalNotificationsPlugin;
  PushNotificationService(this._fcm);

  Future<dynamic> onSelectNotification(String payload) async {
    /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
    // showDialog(
    //   context: context,
    //   builder: (_) => AlertDialog(
    //     title: Text(payload),
    //     content: Text("Payload: $payload"),
    //   ),
    // );
    print(payload);
  }

  Future<void> _showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
    String channelId = '1234',
    String channelTitle = 'Android Channel',
    String channelDescription = 'Default Android Channel for notifications',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: false,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future initialise() async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions();
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
    Prefs.setFCMToken(token);
    //save to preference;

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // String jsonResponse = jsonEncode(message['notification']);
        // _showNotification(
        //     1234,
        //     "GET title FROM message OBJECT",
        //     "GET description FROM message OBJECT",
        //     "GET PAYLOAD FROM message OBJECT");

        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}
