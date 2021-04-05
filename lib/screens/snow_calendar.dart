import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/snow_forecast_model.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/Dialogs.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:intl/intl.dart';

class SnowCalendarScreen extends StatefulWidget {
  static const routeName = '/snow-calendar-screen';

  @override
  _SnowCalendarScreenState createState() => _SnowCalendarScreenState();
}

class _SnowCalendarScreenState extends State<SnowCalendarScreen> {
  String weatherType;
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  CalendarCarousel _calendarCarouselNoHeader;
  String selectedDate;
  String butterMilkDesc = '',
      highlandsDesc = '',
      snowMassDesc = '',
      ajaxDesc = '';
  String accessToken = '';
  String bannerImageUrl = '';
  AdsModel ad;
  PageController _controller = PageController(
    initialPage: 0,
  );
  List<AdsModel> addsList = List();
  @override
  void initState() {
    super.initState();

    selectedDate =
        "${_currentDate.year.toString()}-${_currentDate.month.toString().padLeft(2, '0')}-${_currentDate.day.toString().padLeft(2, '0')}";

    Prefs.getaddModel((AdsModel ad) async {
      setState(() {
        bannerImageUrl = ad.attachment_url;
        ad = ad;
      });
    });

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      this.accessToken = accessToken;
      apiCallForGetForecast(accessToken, selectedDate);
      apiCallForAd(accessToken);
    });
  }

  Widget advertisement(model) {
    return Container(
      color: Colors.grey,
      child: GestureDetector(
        onTap: () {
          launchURL(model?.url ?? "");
        },
        child: Image.network(
          model?.attachment_url ?? "",
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      ),
    );
  }

  Future<void> apiCallForAd(String accessToken) async {
    getAd(
        authToken: accessToken,
        onSuccess: (BaseModel baseModel) {
          if (baseModel.data != null) {
            List<AdsModel> list = List();
            for (var value in baseModel.data) {
              AdsModel model = AdsModel.fromJson(value);
              list.add(model);
            }
            // Prefs.setListData(Const.addsFromPref, list);
            // print("ads data is $list");
            setState(() {
              addsList = list;

              // this.bannerImageUrl = adModel.attachment_url;
              // ad = adModel;
            });
          }
        },
        onError: (String error, BaseModel baseModel) {
          toast(error);
        });
  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        print(date);

        setState(() {
          _currentDate2 = date;
        });

        selectedDate =
            "${_currentDate2.year.toString()}-${_currentDate2.month.toString().padLeft(2, '0')}-${_currentDate2.day.toString().padLeft(2, '0')}";
        apiCallForGetForecast(accessToken, selectedDate);
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: true,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return Scaffold(
        body: SafeArea(
            child: Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xffF5F5FA),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Image.asset(
                      'assets/images/back_arrow.png',
                      width: 20,
                      height: 15,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Snow Calender",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff042C5C),
                          fontSize: 20)),
                ),
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              //     child: Image.asset(
              //       'assets/images/snow_calendar_head.png',
              //       width: 130,
              //       height: 50,
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      '',
                      width: 25,
                      height: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  color: Color(0xffF5F5FA),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                          ),
                          child: new Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                _currentMonth,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              )),
                              FlatButton(
                                child: Text('PREV'),
                                onPressed: () {
                                  setState(() {
                                    _targetDateTime = DateTime(
                                        _targetDateTime.year,
                                        _targetDateTime.month - 1);
                                    _currentMonth = DateFormat.yMMM()
                                        .format(_targetDateTime);
                                  });
                                },
                              ),
                              FlatButton(
                                child: Text('NEXT'),
                                onPressed: () {
                                  setState(() {
                                    _targetDateTime = DateTime(
                                        _targetDateTime.year,
                                        _targetDateTime.month + 1);
                                    _currentMonth = DateFormat.yMMM()
                                        .format(_targetDateTime);
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 310,
                          margin: EdgeInsets.symmetric(horizontal: 3.0),
                          child: _calendarCarouselNoHeader,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                child: Card(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/ic_snow_man.png',
                                        width: 70,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text('Snowmass',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xff222222),
                                                          fontSize: 15)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              (Device.get()
                                                                      .isIphoneX
                                                                  ? 1.5
                                                                  : 1.7),
                                                      // alignment: Alignment.topLeft,
                                                      child: Text(snowMassDesc,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 4,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color(
                                                                  0xff222222),
                                                              fontSize: 14)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 100,
                                child: Card(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/ic_highland.png',
                                        width: 70,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text('Highland',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xff222222),
                                                          fontSize: 15)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              (Device.get()
                                                                      .isIphoneX
                                                                  ? 1.5
                                                                  : 1.6),
                                                      // alignment: Alignment.topLeft,
                                                      child: Text(highlandsDesc,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 4,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color(
                                                                  0xff222222),
                                                              fontSize: 14)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 100,
                                child: Card(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/ic_buttermilk.png',
                                        width: 70,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  child: Text('Buttermilk',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xff222222),
                                                          fontSize: 15)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              (Device.get()
                                                                      .isIphoneX
                                                                  ? 1.5
                                                                  : 1.7),
                                                      // alignment: Alignment.topLeft,
                                                      child: Text(
                                                          butterMilkDesc,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 4,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color(
                                                                  0xff222222),
                                                              fontSize: 14)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 100,
                                child: Card(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        'assets/images/ic_snow_man.png',
                                        width: 70,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text('Ajax',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xff222222),
                                                          fontSize: 15)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              (Device.get()
                                                                      .isIphoneX
                                                                  ? 1.5
                                                                  : 1.7),
                                                      // alignment: Alignment.topLeft,
                                                      child: Text(ajaxDesc,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 4,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color(
                                                                  0xff222222),
                                                              fontSize: 14)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Image.network(
          //     bannerImageUrl,
          //     height: 80,
          //     width: double.infinity,
          //   ),
          // ),
          // InkWell(
          //   onTap: () {
          //     launchURL(ad?.url ?? "");
          //   },
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Image.network(
          //       bannerImageUrl,
          //       height: 80,
          //       width: double.infinity,
          //     ),
          //   ),
          // ),
          addsList.isEmpty
              ? Container()
              : Container(
                  height: 75,
                  child: PageView(
                    controller: _controller,
                    children: addsList
                        .map(
                          (model) => advertisement(model),
                        )
                        .toList(),
                  ),
                ),
        ],
      ),
    )));
  }

  Future<void> apiCallForGetForecast(String accessToken, String date) async {
    Dialogs.showLoadingDialog(context);

    print('api call date: $date');

    getSnowForecastDate(
        authToken: accessToken,
        date: date,
        onSuccess: (BaseModel baseModel) {
          Dialogs.hideDialog(context);

          if (baseModel.data != null) {
            SnowForecastModel forecastModel =
                SnowForecastModel.fromJson(baseModel.data);

            setState(() {
              if (forecastModel.attributes != null) {
                if (forecastModel.attributes.buttermilk != null)
                  butterMilkDesc =
                      forecastModel.attributes.buttermilk.description;

                if (forecastModel.attributes.highlands != null)
                  highlandsDesc =
                      forecastModel.attributes.highlands.description;

                if (forecastModel.attributes.snowmass != null)
                  snowMassDesc = forecastModel.attributes.snowmass.description;

                if (forecastModel.attributes.ajax != null)
                  ajaxDesc = forecastModel.attributes.ajax.description;
              } else {
                // toast('No records found');

                butterMilkDesc = '';
                highlandsDesc = '';
                snowMassDesc = '';
                ajaxDesc = '';
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
