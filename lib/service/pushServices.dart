import 'dart:convert';
import 'dart:io' show Platform;
// import 'dart:js';

import 'package:aspen_weather/utils/prefs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotificationMessage {
  final String title;
  final String body;
  PushNotificationMessage({
    @required this.title,
    @required this.body,
  });
}

class PushNotificationService {
  final FirebaseMessaging _fcm;
  var flutterLocalNotificationsPlugin;
  PushNotificationService(this._fcm);

  // Future<dynamic> onSelectNotification(String payload) async {
  //   /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
  //   // showDialog(
  //   //   context: context,
  //   //   builder: (_) => AlertDialog(
  //   //     title: Text(payload),
  //   //     content: Text("Payload: $payload"),
  //   //   ),
  //   // );
  //   print(payload);
  // }

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

  Future onSelectNotification(String payload) async {
    // showDialog(
    //   context: context,
    //   builder: (_) {
    //     return new AlertDialog(
    //       title: Text("PayLoad"),
    //       content: Text("Payload : $payload"),
    //     );
    //   },
    // );
    print(payload);
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        // sound: 'sound',
        sound: RawResourceAndroidNotificationSound('sound'),
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  Future initialise() async {
    // var initializationSettingsAndroid =
    //     new AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = new IOSInitializationSettings();
    // var initializationSettings = new InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);
    // var initializationSettingsAndroid =
    //     new AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsIOS = new IOSInitializationSettings();
    // var initializationSettings = new InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    //   // onSelectNotification: onSelectNotification
    // );
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
        // showNotification(
        //     message['notification']['title'], message['notification']['body']);
        if (Platform.isAndroid) {
          final notification = PushNotificationMessage(
            title: message['notification']['title'],
            body: message['notification']['body'],
          );
          showSimpleNotification(
            ListTile(
              title: Text(notification.title),
              subtitle: Text(notification.body),
            ),
            // Container(child: Text(notification.body)),
            background: Colors.white,
            position: NotificationPosition.top,
          );
        }
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
