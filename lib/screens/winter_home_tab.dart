import 'dart:async';
import 'dart:convert';
import 'package:aspen_weather/utils/textFontadapter.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/daily_weather_model.dart';
import 'package:aspen_weather/models/today_weather_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/payment_packages.dart';
import 'package:aspen_weather/screens/snow_forecast.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/temperatureConverter.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class WinterHomeTabScreen extends StatefulWidget {
  static const routeName = '/winter-tab-home-screen';

  @override
  _WinterHomeTabScreenState createState() => _WinterHomeTabScreenState();
}

class _WinterHomeTabScreenState extends State<WinterHomeTabScreen> {
  String weatherType;
  bool checkedValue = false;
  User user;
  int _sliderCurrentIndex = 0;
  bool isLoading = false;
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

    //Get the physical device size
    // print(Device.size);
//Quick methods to access the physical device width and height
    print("Device Width: ${Device.width}, Device Height: ${Device.height}");

//To get the actual screen size (Which is same as what MediaQuery gives)
    // print(Device.screenSize);
//Quick methods to access the screen width and height
    print(
        "Device Width: ${Device.screenWidth}, Device Height: ${Device.screenHeight}");
    print("IPHONEX ${Device.get().isIphoneX}");
//Check if device is at least an iphone x
// NOTE: This detects up to Iphone 12 pro max
    if (!Device.get().isIphoneX) {
      print("IPHONEX");
      //Do some notch business
    }
    isLoading = true;
    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    Prefs.getUser((User userModel) async {
      setState(() {
        userName = userModel.name;
      });
    });

    load();
  }

  void load() async {
    final response = await http.get(
        'http://dataservice.accuweather.com/currentconditions/v1/332154?apikey=a6yx6CL07vXUENGLUJbAtTX0aryWEvGp&language=en-us&details=true');
    isLoading = false;
    if (response.statusCode == 200) {
      setState(() {
        Iterable list = json.decode(response.body);
        dailyWeatherModelList =
            list.map((model) => DailyWeatherModel.fromJson(model)).toList();
        print("Size: ${dailyWeatherModelList.length}");

        DailyWeatherModel model = dailyWeatherModelList[0];
        Temperature temperature = model.temperature;

        var temp = TemperatureConverter.celsius_to_fahrenheit(
                temperature.imperial.value)
            .round()
            .toString();

        centerTempStr = '${temperature.imperial.value}' +
            String.fromCharCode(0x00B0) +
            '${temperature.imperial.unit}';
        // centerTempStr = '${temp}' + String.fromCharCode(0x00B0) + 'F';
        // centerTempStr = '${temperature.imperial.value}' +
        //     String.fromCharCode(0x00B0) +
        //     '${temperature.imperial.unit}';
        subDescStr = model.WeatherText;
        feelsLikeStr =
            'Feels like ${model.realFeelTemperature.imperial.value}' +
                String.fromCharCode(0x00B0) +
                '${temperature.imperial.unit}';
        humidityStr = model.relativeHumidity.toString() + " %";
        windSpeedStr = ' ${model.wind.speed.metric.value}' +
            ' ${model.wind.speed.metric.unit}';

        var cuurentTmp =
            TemperatureConverter.celsius_to_fahrenheit(temperature.metric.value)
                .round()
                .toString();
        celsiusStr = cuurentTmp + String.fromCharCode(0x00B0) + 'F';

        currentTime = DateFormat.yMd().format(new DateTime.now());

        weatherIconCurrent = model.weatherIcon;
        // new DateFormat.yMMMd().format(new DateTime.now()); // Apr 8, 2020
      });
    } else {
      isLoading = false;
      throw Exception('Failed to load current weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: isLoading
                ? Center(child: CupertinoActivityIndicator())
                : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/winter_snow_bg.png'),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(children: [
                        SizedBox(
                          height: Device.get().isIphoneX ? 40 : 40,
                        ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.network(
                                    weatherIconCurrent < 10
                                        ? 'https://developer.accuweather.com/sites/default/files/0$weatherIconCurrent-s.png'
                                        : 'https://developer.accuweather.com/sites/default/files/$weatherIconCurrent-s.png',
                                    width: 70,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                          height: Device.get().isIphoneX ? 20 : 0,
                        ),
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
                                    fit: BoxFit.fitHeight,
                                    image: AssetImage(
                                        'assets/images/home_slider_bg.png'),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: Device.get().isIphoneX ? 10 : 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                )
                                              : Text('Today',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          Color(0xff77869E))),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                )
                                              : Text('Tomorrow',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          Color(0xff77869E))),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _weatherChildren[_sliderCurrentIndex]
                                  ],
                                )))
                      ]),
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
    // print(DateFormat("yyyy-MM-dd hh:mm:ss").parse("2012-12-30"));
    // DateTime dt = DateTime.parse('2020-01-02');
    // final d = dt.format(DateTimeFormats.commonLogFormat);
    // print(d);
    // var newDateTimeObj =
    //     new DateFormat().add_yMd().add_Hms().parse("2020-12-30 10:07:23");
    // var dt = new DateFormat("dd/MM/yyyy HH:mm:ss").parse("2012-02-27 10:07:23");

    // print(newDateTimeObj);
    // print(dt);

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
        print("Today forecast size: ${todayWeatherModelList.length}");
        format(todayWeatherModelList.first);
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
                              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                                      fontSize: 19)),
                            ),
                          ),

                          // SizedBox(
                          //   height: 5,
                          // ),
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
                                      fontSize: 18)),
                            ),
                          ),

                          // SizedBox(
                          //   height: 5,
                          // ),
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
  // @override
  // Widget build(BuildContext context) {
  //   return isLoading
  //       ? Container(
  //           padding: const EdgeInsets.all(8),
  //           child: Center(child: CupertinoActivityIndicator()))
  //       : Container(
  //           height: MediaQuery.of(context).size.height * 0.3,
  //           child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               padding: const EdgeInsets.all(8),
  //               itemCount: tomorrowWeatherModelList.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return Container(
  //                   width: MediaQuery.of(context).size.width * 0.25,
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
  //                             TemperatureConverter.celsius_to_fahrenheit(
  //                                         tomorrowWeatherModelList[index]
  //                                             .temperature
  //                                             .value)
  //                                     .round()
  //                                     .toString() + // 1.51 +
  //                                 String.fromCharCode(0x00B0) +
  //                                 "F",
  //                             // tomorrowWeatherModelList[index]
  //                             // .temperature
  //                             // .unit,
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
  //                         //         ? tomorrowWeatherModelList[index]
  //                         //             .dateTime
  //                         //             .substring(
  //                         //                 0,
  //                         //                 tomorrowWeatherModelList[index]
  //                         //                     .dateTime
  //                         //                     .indexOf('T'))
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
  //                         // tomorrowWeatherModelList[index]
  //                         //         .dateTime
  //                         //         .contains('T')
  //                         //     ? tomorrowWeatherModelList[index]
  //                         //         .dateTime
  //                         //         .substring(
  //                         //             tomorrowWeatherModelList[index]
  //                         //                     .dateTime
  //                         //                     .indexOf('T') +
  //                         //                 1,
  //                         //             tomorrowWeatherModelList[index]
  //                         //                 .dateTime
  //                         //                 .length)
  //                         //     : '',
  //                         // style: TextStyle(
  //                         //     fontWeight: FontWeight.normal,
  //                         //     color: Color(0xff222222),
  //                         //     fontSize: 11)),
  //                       ],
  //                     ),
  //                   )),
  //                 );
  //               }),
  //         );
  // }
}
