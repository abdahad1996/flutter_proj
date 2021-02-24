import 'package:aspen_weather/models/notificationmodel.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String horseUrl = 'https://i.stack.imgur.com/Dw6f7.png';
String cowUrl = 'https://i.stack.imgur.com/XPOr3.png';
String camelUrl = 'https://i.stack.imgur.com/YN0m7.png';
String sheepUrl = 'https://i.stack.imgur.com/wKzo8.png';
String goatUrl = 'https://i.stack.imgur.com/Qt4JP.png';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notifications/get-user-notification';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const routeName = '/notifications/get-user-notification';
  bool isLoading = false;
  final List<NotificationModel> notifications = List();

  @override
  void initState() {
    super.initState();

    // Prefs.getWeatherType((String weather) {
    //   setState(() {
    //     weatherType = weather;
    //   });
    // });
    setState(() {
      isLoading = true;
    });
    Prefs.getAccessToken((String accessToken) async {
      BaseModel baseModel =
          await getNotification(authToken: accessToken).catchError((error) {
        print("error is $error ");
        // toast(error);
      });

      print("BASEMODEL THEME IS $baseModel");

      // title = "";
      // content = "";

      if (baseModel != null && baseModel.data != null) {
        // title = dataModel.title;
        // content = dataModel.content;
        setState(() {
          isLoading = false;
          List list = baseModel.data as List;
          notifications.clear();
          if (list.length == 0) {
            toast('No records found');
          } else {
            for (var value in list) {
              print("value is $value");
              NotificationModel model = NotificationModel.fromJson(value);
              notifications.add(model);
              print("notifications is $notifications");
            }
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        toast('No data available!');
      }
    });
  }

  Widget list(NotificationModel notifications) {
    return ListTile(
      // leading: CircleAvatar(
      //   // backgroundImage: NetworkImage(horseUrl),
      // ),
      title: Text(notifications.title),
      subtitle: Text(notifications.message),
      // trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        print('horse');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            child:
                Icon(Icons.keyboard_arrow_left, size: 30, color: Colors.black),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Notification",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff042C5C),
                  fontSize: 20)),
        ),
        body: isLoading
            ? Center(child: CupertinoActivityIndicator())
            : (notifications.length == 0 || notifications == null)
                ? Center(
                    child: Text("No records found"),
                  )
                : SafeArea(
                    child: ListView(
                        semanticChildCount: notifications.length,
                        children:
                            notifications.map((model) => list(model)).toList()
                        // children: <Widget>[
                        //   ListTile(
                        //     leading: CircleAvatar(
                        //       backgroundImage: NetworkImage(horseUrl),
                        //     ),
                        //     title: Text('text'),
                        //     subtitle: Text('text'),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                        //     onTap: () {
                        //       print('horse');
                        //     },
                        //   ),
                        //   ListTile(
                        //     leading: CircleAvatar(
                        //       backgroundImage: NetworkImage(cowUrl),
                        //     ),
                        //     title: Text('text'),
                        //     subtitle: Text('text'),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                        //     onTap: () {
                        //       print('cow');
                        //     },
                        //   ),
                        //   ListTile(
                        //     leading: CircleAvatar(
                        //       backgroundImage: NetworkImage(camelUrl),
                        //     ),
                        //     title: Text('text'),
                        //     subtitle: Text('text'),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                        //     onTap: () {
                        //       print('camel');
                        //     },
                        //   ),
                        //   ListTile(
                        //     leading: CircleAvatar(
                        //       backgroundImage: NetworkImage(sheepUrl),
                        //     ),
                        //     title: Text('text'),
                        //     subtitle: Text('text'),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                        //     onTap: () {
                        //       print('sheep');
                        //     },
                        //   ),
                        //   ListTile(
                        //     leading: CircleAvatar(
                        //       backgroundImage: NetworkImage(goatUrl),
                        //     ),
                        //     title: Text('text'),
                        //     subtitle: Text('text'),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                        //     onTap: () {
                        //       print('goat');
                        //     },
                        //   ),
                        // ],
                        )));
  }
}
