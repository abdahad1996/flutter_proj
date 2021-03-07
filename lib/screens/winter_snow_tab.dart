import 'package:aspen_weather/models/snow_forecast_weekly.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/cumulative_snow.dart';
import 'package:aspen_weather/screens/snow_calendar.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/Dialogs.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:intl/intl.dart';

class WinterSnowTabScreen extends StatefulWidget {
  static const routeName = '/winter-tab-snow-screen';

  @override
  _WinterSnowTabScreenState createState() => _WinterSnowTabScreenState();
}

class _WinterSnowTabScreenState extends State<WinterSnowTabScreen> {
  String weatherType;
  bool checkedValue = false;
  User user;
  String accessToken = '';

  String bmMon = 'N/A',
      bmTues = 'N/A',
      bmWed = 'N/A',
      bmThurs = 'N/A',
      bmFri = 'N/A',
      bmSat = 'N/A',
      bmSun = 'N/A';
  String ajMon = 'N/A',
      ajTues = 'N/A',
      ajWed = 'N/A',
      ajThurs = 'N/A',
      ajFri = 'N/A',
      ajSat = 'N/A',
      ajSun = 'N/A';
  String snMon = 'N/A',
      snTues = 'N/A',
      snWed = 'N/A',
      snThurs = 'N/A',
      snFri = 'N/A',
      snSat = 'N/A',
      snSun = 'N/A';
  String thMon = 'N/A',
      thTues = 'N/A',
      thWed = 'N/A',
      thThurs = 'N/A',
      thFri = 'N/A',
      thSat = 'N/A',
      thSun = 'N/A';

  String todayDate = "";

  @override
  void initState() {
    super.initState();
    var date = DateTime.now();
    todayDate = DateFormat('EEEE').format(date);
    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      this.accessToken = accessToken;
      apiCallForGetForecastWeekly(accessToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      color: Color(0xffE1E1E6),
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
          child: Column(
            children: [
              SizedBox(
                height: 65,
              ),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: Device.get().isIphoneX ? 450 : 450,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 55,
                                color: Colors.transparent),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              color: Color(0xff3D73FF),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Transform.rotate(
                                    angle: -math.pi / 4,
                                    child: Text('Buttermilk',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              color: Color(0xff3D73FF),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Transform.rotate(
                                    angle: -math.pi / 4,
                                    child: Text('Highlands',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              color: Color(0xff3D73FF),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Transform.rotate(
                                    angle: -math.pi / 4,
                                    child: Text('Snowmass',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              color: Color(0xff3D73FF),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Transform.rotate(
                                    angle: -math.pi / 4,
                                    child: Text('Ajax',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Monday',
                                      style: TextStyle(
                                        color: (todayDate == "Monday"
                                            ? Colors.red
                                            : Colors.black),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                      ))),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    bmMon,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    thMon,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snMon,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    ajMon,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Tuesday',
                                      style: TextStyle(
                                        color: (todayDate == "Tuesday"
                                            ? Colors.red
                                            : Colors.black),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                      ))),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    bmTues,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    thTues,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snTues,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    ajTues,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Wednesday',
                                    style: TextStyle(
                                      color: (todayDate == "Wednesday"
                                          ? Colors.red
                                          : Colors.black),
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  bmWed,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 9),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    thWed,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snWed,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    ajWed,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Thursday',
                                      style: TextStyle(
                                        color: (todayDate == "Thursday"
                                            ? Colors.red
                                            : Colors.black),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    bmThurs,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    thThurs,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snThurs,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    ajThurs,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Friday',
                                      style: TextStyle(
                                        color: (todayDate == "Friday"
                                            ? Colors.red
                                            : Colors.black),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    bmFri,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    thFri,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snFri,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    ajFri,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      // Container(color: Colors.red,width: 100,height: 100,)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Saturday',
                                      style: TextStyle(
                                        color: (todayDate == "Saturday"
                                            ? Colors.red
                                            : Colors.black),
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    bmSat,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    thSat,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snSat,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    ajSat,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Sunday',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    bmSun,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    thSun,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snSun,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 55,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    ajSun,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 9),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, SnowCalendarScreen.routeName);
                    },
                    child: Image.asset(
                      'assets/images/snowfall_calendar_btn.png',
                      width: 155,
                      height: 80,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, CumulativeSnowScreen.routeName);
                    },
                    child: Image.asset(
                      'assets/images/cummulative_snowfall_btn.png',
                      width: 155,
                      height: 80,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )));
  }

  Future<void> apiCallForGetForecastWeekly(String accessToken) async {
    Dialogs.showLoadingDialog(context);

    getSnowForecastWeekly(
        authToken: accessToken,
        onSuccess: (BaseModel baseModel) {
          Dialogs.hideDialog(context);

          if (baseModel.data != null) {
            SnowForecastWeeklyModel forecastModel =
                SnowForecastWeeklyModel.fromJson(baseModel.data);

            setState(() {
              if (forecastModel.monday != null) {
                if (forecastModel.monday.buttermilk != null)
                  bmMon = forecastModel.monday.buttermilk.description;

                if (forecastModel.monday.highlands != null)
                  thMon = forecastModel.monday.highlands.description;

                if (forecastModel.monday.snowmass != null)
                  snMon = forecastModel.monday.snowmass.description;

                if (forecastModel.monday.ajax != null)
                  ajMon = forecastModel.monday.ajax.description;
              }

              if (forecastModel.tues != null) {
                if (forecastModel.tues.buttermilk != null)
                  bmTues = forecastModel.tues.buttermilk.description;

                if (forecastModel.tues.highlands != null)
                  thTues = forecastModel.tues.highlands.description;

                if (forecastModel.tues.snowmass != null)
                  snTues = forecastModel.tues.snowmass.description;

                if (forecastModel.tues.ajax != null)
                  ajTues = forecastModel.tues.ajax.description;
              }

              if (forecastModel.wed != null) {
                if (forecastModel.wed.buttermilk != null)
                  bmWed = forecastModel.wed.buttermilk.description;

                if (forecastModel.wed.highlands != null)
                  thWed = forecastModel.wed.highlands.description;

                if (forecastModel.wed.snowmass != null)
                  snWed = forecastModel.wed.snowmass.description;

                if (forecastModel.wed.ajax != null)
                  ajWed = forecastModel.wed.ajax.description;
              }
              if (forecastModel.thurs != null) {
                if (forecastModel.thurs.buttermilk != null)
                  bmThurs = forecastModel.thurs.buttermilk.description;

                if (forecastModel.thurs.highlands != null)
                  bmThurs = forecastModel.thurs.highlands.description;

                if (forecastModel.thurs.snowmass != null)
                  bmThurs = forecastModel.thurs.snowmass.description;

                if (forecastModel.thurs.ajax != null)
                  bmThurs = forecastModel.thurs.ajax.description;
              }
              if (forecastModel.fri != null) {
                if (forecastModel.fri.buttermilk != null)
                  bmFri = forecastModel.fri.buttermilk.description;

                if (forecastModel.fri.highlands != null)
                  thFri = forecastModel.fri.highlands.description;

                if (forecastModel.fri.snowmass != null)
                  snFri = forecastModel.fri.snowmass.description;

                if (forecastModel.fri.ajax != null)
                  ajFri = forecastModel.fri.ajax.description;
              }
              if (forecastModel.sat != null) {
                if (forecastModel.sat.buttermilk != null)
                  bmSat = forecastModel.sat.buttermilk.description;

                if (forecastModel.sat.highlands != null)
                  thSat = forecastModel.sat.highlands.description;

                if (forecastModel.sat.snowmass != null)
                  snSat = forecastModel.sat.snowmass.description;

                if (forecastModel.sat.ajax != null)
                  ajSat = forecastModel.sat.ajax.description;
              }
              if (forecastModel.sun != null) {
                if (forecastModel.sun.buttermilk != null)
                  bmSun = forecastModel.sun.buttermilk.description;

                if (forecastModel.sun.highlands != null)
                  thSun = forecastModel.sun.highlands.description;

                if (forecastModel.sun.snowmass != null)
                  snSun = forecastModel.sun.snowmass.description;

                if (forecastModel.sun.ajax != null)
                  ajSun = forecastModel.sun.ajax.description;
              }
            });
          }
        },
        onError: (String error, BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(error);
        });
  }
}
