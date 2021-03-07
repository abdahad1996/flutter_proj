import 'dart:async';
import 'dart:convert';

import 'package:aspen_weather/models/daily_weather_model.dart';
import 'package:aspen_weather/models/today_weather_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/screens/payment_packages.dart';
import 'package:aspen_weather/screens/snow_forecast.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/temperatureConverter.dart';
import 'package:aspen_weather/utils/textFontadapter.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SummerHomeTabScreen extends StatefulWidget {
  static const routeName = '/summer-tab-home-screen';

  @override
  _SummerHomeTabScreenState createState() => _SummerHomeTabScreenState();
}

class _SummerHomeTabScreenState extends State<SummerHomeTabScreen> {
  String weatherType;
  bool checkedValue = false;
  User user;
  int _sliderCurrentIndex = 0;
  List<DailyWeatherModel> dailyWeatherModelList = List();

  String centerTempStr = '';
  String subDescStr = '';
  String feelsLikeStr = '';
  String windSpeedStr = '';
  String humidityStr = '';
  String celsiusStr = '';
  String currentTime = '';
  String userName = '';

  int weatherIconCurrent = 1;

  final List<Widget> _weatherChildren = [
    WeatherTodayScreen(),
    WeatherTomorrowScreen()
  ];

  @override
  void initState() {
    super.initState();

    Prefs.getWeatherType((String weather) {
      if (mounted) {
        setState(() {
          weatherType = weather;
        });
      }
    });

    Prefs.getUser((User userModel) async {
      if (mounted) {
        setState(() {
          userName = userModel.name;
        });
      }
    });

    load();
  }

  void load() async {
    print(
        "url:http://dataservice.accuweather.com/currentconditions/v1/332154?apikey=a6yx6CL07vXUENGLUJbAtTX0aryWEvGp&language=en-us&details=true");

    final response = await http.get(
        'http://dataservice.accuweather.com/currentconditions/v1/332154?apikey=a6yx6CL07vXUENGLUJbAtTX0aryWEvGp&language=en-us&details=true');

    if (response.statusCode == 200) {
      setState(() {
        Iterable list = json.decode(response.body);
        dailyWeatherModelList =
            list.map((model) => DailyWeatherModel.fromJson(model)).toList();
        print("Size: ${dailyWeatherModelList.length}");
        print("dailyWeatherModelList: ${dailyWeatherModelList}");

        DailyWeatherModel model = dailyWeatherModelList[0];
        Temperature temperature = model.temperature;

        weatherIconCurrent = model.weatherIcon;

        centerTempStr = '${temperature.imperial.value}' +
            String.fromCharCode(0x00B0) +
            '${temperature.imperial.unit}';
        subDescStr = model.WeatherText;
        feelsLikeStr =
            'Feels like ${model.realFeelTemperature.imperial.value}' +
                String.fromCharCode(0x00B0) +
                '${temperature.imperial.unit}';
        humidityStr = model.relativeHumidity.toString() + " %";
        windSpeedStr = ' ${model.wind.speed.metric.value}' +
            ' ${model.wind.speed.metric.unit}';
        // celsiusStr = '${temperature.metric.value}' +
        //     String.fromCharCode(0x00B0) +
        //     '${temperature.metric.unit}';

        var cuurentTmp =
            TemperatureConverter.celsius_to_fahrenheit(temperature.metric.value)
                .round()
                .toString();
        celsiusStr = cuurentTmp + String.fromCharCode(0x00B0) + 'F';

        currentTime = DateFormat.yMd().format(new DateTime.now());
        // print(DateFormat.yMd().parse("2020-12-28"));
        // print("date is bla");

        // DateFormat.yMMMd().format(new DateTime.now()); // Apr 8, 2020
      });
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/summer_home_bg_new.png'),
        ),
      ),
      child: Container(
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Text("Hi, $userName",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff31343D),
                        fontSize: 28)),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Text(currentTime,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff222222),
                        fontSize: 14)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        weatherIconCurrent < 10
                            ? 'https://developer.accuweather.com/sites/default/files/0$weatherIconCurrent-s.png'
                            : 'https://developer.accuweather.com/sites/default/files/$weatherIconCurrent-s.png',
                        width: 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(centerTempStr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff222222),
                                      fontSize: 30)),
                              Text(subDescStr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff222222),
                                      fontSize: 20)),
                              Text(feelsLikeStr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff222222),
                                      fontSize: 13)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )),
            SizedBox(
              height: 4,
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(windSpeedStr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff222222),
                              fontSize: 18)),
                      Text('Wind',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xff222222),
                              fontSize: 16)),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(humidityStr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff222222),
                              fontSize: 18)),
                      Text('Humidity',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xff222222),
                              fontSize: 16)),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(celsiusStr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff222222),
                              fontSize: 18)),
                      Text('Temperature',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xff222222),
                              fontSize: 16)),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Container(
            //   margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
            //   child: Align(
            //       alignment: Alignment.centerRight,
            //       child: Container(
            //           child: GestureDetector(
            //               onTap: () {
            //                 Navigator.pushNamed(
            //                     context, SnowForecastScreen.routeName);
            //               },
            //               child: Image.asset(
            //                 'assets/images/bg_button_three_days.png',
            //                 height: Device.get().isIphoneX ? 50 : 30,
            //               )))),
            // ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, 5, 10, Device.get().isIphoneX ? 10 : 5),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, SnowForecastScreen.routeName);
                      },
                      child: Image.asset(
                        'assets/images/bg_button_three_days.png',
                        width: 150,
                        height: Device.get().isIphoneX ? 50 : 30,
                      ))),
            ),
            Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/home_slider_bg.png'),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _sliderCurrentIndex = 0;
                                });
                              },
                              child: _sliderCurrentIndex == 0
                                  ? Text.rich(
                                      TextSpan(
                                        text: 'Today',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  : Text('Today',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff77869E))),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _sliderCurrentIndex = 1;
                                });
                              },
                              child: _sliderCurrentIndex == 1
                                  ? Text.rich(
                                      TextSpan(
                                        text: 'Tomorrow',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  : Text('Tomorrow',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff77869E))),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _weatherChildren[_sliderCurrentIndex]
                      ],
                    )))
          ]),
        ),
      ),
    )));
  }

/*showPaymentAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Exit"),
      onPressed: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Proceed"),
      onPressed: () {
        Navigator.pushNamed(context, PackagesScreen.routeName);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content:
          Text("You need to buy package first to access application features."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }*/
}

class WeatherTodayScreen extends StatefulWidget {
  @override
  _WeatherTodayScreenState createState() => _WeatherTodayScreenState();
}

class _WeatherTodayScreenState extends State<WeatherTodayScreen> {
  List<TodayWeatherModel> todayWeatherModelList = List();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    setState(() {
      isLoading = true;
    });
    final todayResponse = await http.get(
        'http://dataservice.accuweather.com/forecasts/v1/hourly/12hour/332154?apikey=a6yx6CL07vXUENGLUJbAtTX0aryWEvGp&weather_api.%27&language=en-us&details=true&metric=true');

    if (todayResponse.statusCode == 200) {
      setState(() {
        Iterable list = json.decode(todayResponse.body);
        todayWeatherModelList =
            list.map((model) => TodayWeatherModel.fromJson(model)).toList();
        // print("Today forecast size: ${todayWeatherModelList.length}");
        print("Today forecast  : ${todayWeatherModelList}");

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      toast('Failed to load current weather');

      // throw Exception('Failed to load current weather');
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return (isLoading)
  //       ? Container(
  //           padding: const EdgeInsets.all(8),
  //           child: Center(child: CupertinoActivityIndicator()))
  //       : Container(
  //           height: MediaQuery.of(context).size.height * 0.2,
  //           child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               padding: const EdgeInsets.all(8),
  //               itemCount: todayWeatherModelList.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return Container(
  //                   width: MediaQuery.of(context).size.width * 0.3,
  //                   height: MediaQuery.of(context).size.height * 0.15,
  //                   child: Expanded(
  //                     child: Container(
  //                         child: Card(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Align(
  //                             alignment: Alignment.center,
  //                             child: Padding(
  //                               padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                               child: Image.network(
  //                                 todayWeatherModelList[index].weatherIcon < 10
  //                                     ? 'https://developer.accuweather.com/sites/default/files/0${todayWeatherModelList[index].weatherIcon}-s.png'
  //                                     : 'https://developer.accuweather.com/sites/default/files/${todayWeatherModelList[index].weatherIcon}-s.png',
  //                                 width: 80,
  //                                 height: 50,
  //                               ),
  //                             ),
  //                           ),
  //                           Text(
  //                               // todayWeatherModelList[index]
  //                               //         .temperature
  //                               //         .value
  //                               //         .toString() +
  //                               //     String.fromCharCode(0x00B0) +
  //                               //     todayWeatherModelList[index].temperature.unit,
  //                               TemperatureConverter.celsius_to_fahrenheit(
  //                                           todayWeatherModelList[index]
  //                                               .temperature
  //                                               .value)
  //                                       .round()
  //                                       .toString() + // 1.51 +
  //                                   String.fromCharCode(0x00B0) +
  //                                   "F",
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Color(0xff31343D),
  //                                   fontSize: 18)),
  //                           SizedBox(
  //                             height: 5,
  //                           ),
  //                           // Text(
  //                           //     todayWeatherModelList[index]
  //                           //             .dateTime
  //                           //             .contains('T')
  //                           //         ? todayWeatherModelList[index]
  //                           //             .dateTime
  //                           //             .substring(
  //                           //                 0,
  //                           //                 todayWeatherModelList[index]
  //                           //                     .dateTime
  //                           //                     .indexOf('T'))
  //                           //         : '',
  //                           //     style: TextStyle(
  //                           //         fontWeight: FontWeight.normal,
  //                           //         color: Color(0xff222222),
  //                           //         fontSize: 11)),
  //                           SizedBox(
  //                             height: 2,
  //                           ),
  //                           Text(format(todayWeatherModelList[index]),
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                   fontWeight: FontWeight.normal,
  //                                   color: Color(0xff222222),
  //                                   fontSize: 14)),
  //                           // Text(
  //                           //     todayWeatherModelList[index].dateTime.contains(
  //                           //             'T')
  //                           //         ? todayWeatherModelList[index]
  //                           //             .dateTime
  //                           //             .substring(
  //                           //                 todayWeatherModelList[index]
  //                           //                         .dateTime
  //                           //                         .indexOf('T') +
  //                           //                     1,
  //                           //                 todayWeatherModelList[index]
  //                           //                     .dateTime
  //                           //                     .length)
  //                           //         : '',
  //                           //     style: TextStyle(
  //                           //         fontWeight: FontWeight.normal,
  //                           //         color: Color(0xff222222),
  //                           //         fontSize: 11)),
  //                         ],
  //                       ),
  //                     )),
  //                   ),
  //                 );
  //               }),
  //         );
  // }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            padding: const EdgeInsets.all(8),
            child: Center(child: CupertinoActivityIndicator()))
        : Container(
            height: Device.get().isIphoneX ? 150 : 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                itemCount: todayWeatherModelList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: Device.get().isIphoneX
                        ? MediaQuery.of(context).size.width * 0.35
                        : MediaQuery.of(context).size.width * 0.3,
                    height: Device.get().isIphoneX ? 150 : 150,
                    child: Container(
                        child: Card(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Image.network(
                                todayWeatherModelList[index].weatherIcon < 10
                                    ? 'https://developer.accuweather.com/sites/default/files/0${todayWeatherModelList[index].weatherIcon}-s.png'
                                    : 'https://developer.accuweather.com/sites/default/files/${todayWeatherModelList[index].weatherIcon}-s.png',
                                width: 80,
                                height: 50,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Container(
                              child: Text(

                                  // todayWeatherModelList[index]
                                  //         .temperature
                                  //         .value
                                  //         .toString() +
                                  //     String.fromCharCode(0x00B0) +
                                  //     todayWeatherModelList[index].temperature.unit,
                                  TemperatureConverter.celsius_to_fahrenheit(
                                              todayWeatherModelList[index]
                                                  .temperature
                                                  .value)
                                          .round()
                                          .toString() + // 1.51 +
                                      String.fromCharCode(0x00B0) +
                                      "F",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff31343D),
                                      fontSize: 18)),
                            ),
                          ),

                          // SizedBox(
                          //   height: 5,
                          // // ),
                          // Text(
                          //     todayWeatherModelList[index]
                          //             .dateTime
                          //             .contains('T')
                          //         ? todayWeatherModelList[index]
                          //             .dateTime
                          //             .substring(
                          //                 0,
                          //                 todayWeatherModelList[index]
                          //                     .dateTime
                          //                     .indexOf('T'))
                          //         : '',
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal,
                          //         color: Color(0xff222222),
                          //         fontSize: 18)),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // FittedBox(
                          //   fit: BoxFit.contain,
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),

                              // color: Colors.red,

                              //   fit: BoxFit.contain,

                              child: AdaptableText(
                                  format(todayWeatherModelList[index]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff222222),
                                      fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                    )),
                  );
                }),
          );
  }
}

class WeatherTomorrowScreen extends StatefulWidget {
  @override
  _WeatherTomorrowScreenState createState() => _WeatherTomorrowScreenState();
}

class _WeatherTomorrowScreenState extends State<WeatherTomorrowScreen> {
  List<TodayWeatherModel> tomorrowWeatherModelList = List();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("tommorw date format is ");
    // DateFormat dateFormat = DateFormat();

    load();
  }

  void load() async {
    setState(() {
      isLoading = true;
    });
    final todayResponse = await http.get(
        'http://dataservice.accuweather.com/forecasts/v1/hourly/12hour/332154?apikey=a6yx6CL07vXUENGLUJbAtTX0aryWEvGp&weather_api.%27&language=en-us&details=true&metric=true');

    if (todayResponse.statusCode == 200) {
      setState(() {
        Iterable list = json.decode(todayResponse.body);
        tomorrowWeatherModelList =
            list.map((model) => TodayWeatherModel.fromJson(model)).toList();
        print("Today forecast size: ${tomorrowWeatherModelList.length}");
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      toast('Failed to load current weather');
      // throw Exception('Failed to load current weather');
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return (isLoading)
  //       ? Container(
  //           padding: const EdgeInsets.all(8),
  //           child: Center(child: CupertinoActivityIndicator()))
  //       : Container(
  //           height: MediaQuery.of(context).size.height * 0.2,
  //           child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               padding: const EdgeInsets.all(8),
  //               itemCount: tomorrowWeatherModelList.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return Container(
  //                   width: MediaQuery.of(context).size.width * 0.3,
  //                   height: MediaQuery.of(context).size.height * 0.15,
  //                   child: Container(
  //                       child: Card(
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.center,
  //                           child: Padding(
  //                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                             child: Image.network(
  //                               tomorrowWeatherModelList[index].weatherIcon < 10
  //                                   ? 'https://developer.accuweather.com/sites/default/files/0${tomorrowWeatherModelList[index].weatherIcon}-s.png'
  //                                   : 'https://developer.accuweather.com/sites/default/files/${tomorrowWeatherModelList[index].weatherIcon}-s.png',
  //                               width: 80,
  //                               height: 50,
  //                             ),
  //                           ),
  //                         ),
  //                         Text(
  //                             // tomorrowWeatherModelList[index]
  //                             //         .temperature
  //                             //         .value
  //                             //         .toString() +
  //                             //     String.fromCharCode(0x00B0) +
  //                             //     tomorrowWeatherModelList[index].temperature.unit,
  //                             TemperatureConverter.celsius_to_fahrenheit(
  //                                         tomorrowWeatherModelList[index]
  //                                             .temperature
  //                                             .value)
  //                                     .round()
  //                                     .toString() + // 1.51 +
  //                                 String.fromCharCode(0x00B0) +
  //                                 "F",
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Color(0xff31343D),
  //                                 fontSize: 18)),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         // Text(
  //                         //     tomorrowWeatherModelList[index]
  //                         //             .dateTime
  //                         //             .contains('T')
  //                         //         ? DateFormat.yMd().parse(
  //                         //             tomorrowWeatherModelList[index]
  //                         //                 .dateTime
  //                         //                 .substring(
  //                         //                     0,
  //                         //                     tomorrowWeatherModelList[index]
  //                         //                         .dateTime
  //                         //                         .indexOf('T')))
  //                         //         : '',
  //                         //     style: TextStyle(
  //                         //         fontWeight: FontWeight.normal,
  //                         //         color: Color(0xff222222),
  //                         //         fontSize: 11)),
  //                         SizedBox(
  //                           height: 2,
  //                         ),
  //                         Text(format(tomorrowWeatherModelList[index]),
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                                 fontWeight: FontWeight.normal,
  //                                 color: Color(0xff222222),
  //                                 fontSize: 14)),
  //                         // Text(
  //                         //     // tomorrowWeatherModelList[index]
  //                         //     //         .dateTime
  //                         //     //         .contains('T')
  //                         //     //     ? tomorrowWeatherModelList[index]
  //                         //     //         .dateTime
  //                         //     //         .substring(
  //                         //     //             tomorrowWeatherModelList[index]
  //                         //     //                     .dateTime
  //                         //     //                     .indexOf('T') +
  //                         //     //                 1,
  //                         //     //             tomorrowWeatherModelList[index]
  //                         //     //                 .dateTime
  //                         //     //                 .length)
  //                         //     //     : '',
  //                         //     style: TextStyle(
  //                         //         fontWeight: FontWeight.normal,
  //                         //         color: Color(0xff222222),
  //                         //         fontSize: 11)),
  //                       ],
  //                     ),
  //                   )),
  //                 );
  //               }),
  //         );
  // }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            padding: const EdgeInsets.all(8),
            child: Center(child: CupertinoActivityIndicator()))
        : Container(
            height: Device.get().isIphoneX ? 150 : 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                itemCount: tomorrowWeatherModelList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: Device.get().isIphoneX
                        ? MediaQuery.of(context).size.width * 0.35
                        : MediaQuery.of(context).size.width * 0.3,
                    height: Device.get().isIphoneX ? 150 : 150,
                    child: Container(
                        child: Card(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Image.network(
                                tomorrowWeatherModelList[index].weatherIcon < 10
                                    ? 'https://developer.accuweather.com/sites/default/files/0${tomorrowWeatherModelList[index].weatherIcon}-s.png'
                                    : 'https://developer.accuweather.com/sites/default/files/${tomorrowWeatherModelList[index].weatherIcon}-s.png',
                                width: 80,
                                height: 50,
                              ),
                            ),
                          ),

                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text(

                                  // todayWeatherModelList[index]
                                  //         .temperature
                                  //         .value
                                  //         .toString() +
                                  //     String.fromCharCode(0x00B0) +
                                  //     todayWeatherModelList[index].temperature.unit,
                                  TemperatureConverter.celsius_to_fahrenheit(
                                              tomorrowWeatherModelList[index]
                                                  .temperature
                                                  .value)
                                          .round()
                                          .toString() + // 1.51 +
                                      String.fromCharCode(0x00B0) +
                                      "F",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff31343D),
                                      fontSize: 19)),
                            ),
                          ),

                          // // SizedBox(
                          // //   height: 5,
                          // // ),
                          // Text(
                          //     tomorrowWeatherModelList[index]
                          //             .dateTime
                          //             .contains('T')
                          //         ? tomorrowWeatherModelList[index]
                          //             .dateTime
                          //             .substring(
                          //                 0,
                          //                 tomorrowWeatherModelList[index]
                          //                     .dateTime
                          //                     .indexOf('T'))
                          //         : '',
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal,
                          //         color: Color(0xff222222),
                          //         fontSize: 18)),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // FittedBox(
                          //   fit: BoxFit.contain,
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),

                              // color: Colors.red,

                              //   fit: BoxFit.contain,

                              child: AdaptableText(
                                  format(tomorrowWeatherModelList[index]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff222222),
                                      fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                    )),
                  );
                }),
          );
  }
}
