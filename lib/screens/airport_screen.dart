import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:intl/intl.dart';

class AirportScreen extends StatefulWidget {
  static const routeName = '/airport-screen';

  @override
  _AirportScreenState createState() => _AirportScreenState();

}

class _AirportScreenState extends State<AirportScreen> {
  String weatherType;
  String currentTime = '';

  @override
  void initState() {
    super.initState();

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    load();
  }

  void load() async {
    currentTime =
    DateFormat.yMd() .format(new DateTime.now());
        // DateFormat.yMMMd().format(new DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*floatingActionButton: FabCircularMenu(
            ringWidth: 0,
            ringColor: Colors.transparent,
            ringDiameter: 180,
            fabCloseIcon:
                Image.asset('assets/images/airport_float_circle_cross.png'),
            fabOpenIcon: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/airport_float_circle.png"),
                ),
              ),
              child: Image.asset(
                'assets/images/airport_float_icon.png',
                width: 30,
                height: 30,
              ),
            ),
            children: <Widget>[
              Image.asset(
                'assets/images/float_one.png',
                width: 45,
                height: 45,
              ),
              Image.asset(
                'assets/images/float_two.png',
                width: 45,
                height: 45,
              ),
              Image.asset(
                'assets/images/float_three.png',
                width: 45,
                height: 45,
              )
            ]),*/
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          /*decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(weatherType == Const.WEATHER_TYPE_SUMMER
                  ? 'assets/images/airport_bg.png'
                  : 'assets/images/airport_bg_winter.png'),
            ),
          ),*/

          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(currentTime,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff31343D),
                              fontSize: 20)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/images/cross_black.png',
                        width: 13,
                        height: 13,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/live_button.png',
                  width: 60,
                  height: 25,
                ),
              ),
              Expanded(
                child: Mjpeg(
                  isLive: true,
                    stream: 'http://96.66.94.26:442/wps-cgi/video.cgi?camera=1&resolution=640x480&format=MPEG%20&username=Web1Web1&password=W3atherGod123',
                ),
              ),
            ],
          ),
        )));
  }
}
