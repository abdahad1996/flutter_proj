import 'package:aspen_weather/main.dart';
import 'package:aspen_weather/models/indicator_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SummerIndicatorTabScreen extends StatefulWidget {
  static const routeName = '/summer-tab-indicator-screen';

  @override
  _SummerIndicatorTabScreenState createState() =>
      _SummerIndicatorTabScreenState();
}

class _SummerIndicatorTabScreenState extends State<SummerIndicatorTabScreen>
    with SingleTickerProviderStateMixin {
  String weatherType;
  String adUrl = '';
  TabController _tabController;
  bool isLoading = false;
  final List<DailyIndicatorModel> indicators = List();

  @override
  void load() async {
    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });
    setState(() {
      isLoading = true;
    });
    Prefs.getAccessToken((String accessToken) async {
      BaseModel baseModel =
          await getIndicator(authToken: accessToken).catchError((error) {
        print("error is $error ");
        // toast(error);
      });

      print("BASEMODEL THEME IS $baseModel");

      // title = "";
      // content = "";

      if (baseModel != null && baseModel.data != null) {
        setState(() {
          isLoading = false;
          List list = baseModel.data as List;
          indicators.clear();
          if (list.length == 0) {
            toast('No records found');
          } else {
            for (var value in list) {
              print("value is $value");
              DailyIndicatorModel model = DailyIndicatorModel.fromJson(value);
              indicators.add(model);
              print("indicators is $indicators");
            }
          }
          _tabController =
              TabController(length: indicators.length, vsync: this);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        toast('No data available!');
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Prefs.getAdsUrl((String adUrl) async {
      if (mounted) {
        setState(() {
          this.adUrl = adUrl;
        });
      }
    });

    Prefs.getWeatherType((String weather) {
      if (mounted) {
        setState(() {
          weatherType = weather;
        });
      }
    });
    load();
  }

  // void load() async {}

  // @override
  // Widget build(BuildContext context) {
  //   final ThemeData somTheme = new ThemeData(
  //       primaryColor: Colors.blue,
  //       accentColor: Colors.black,
  //       backgroundColor: Colors.grey);
  //   return Scaffold(
  //       body: SafeArea(
  //           child: Container(
  //               child: Center(
  //                   child: SpeedOMeter(
  //     start: 0,
  //     end: 0,
  //     highlightStart: 2,
  //     highlightEnd: 5,
  //     themeData: somTheme,
  //   )))));
  // }
  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];

    return isLoading
        ? Center(child: CupertinoActivityIndicator())
        : (indicators.length == 0)
            ? Center(
                child: Text("no records found"),
              )
            : Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(
                        (weatherType == Const.WEATHER_TYPE_SUMMER)
                            ? 50
                            : 100), // here the desired height
                    child: AppBar(
                      // title: Text("Tab Bar Example - FlutterCorner"),
                      backgroundColor: Color.fromRGBO(250, 250, 255, 1),
                      bottom: TabBar(
                        unselectedLabelColor: Color(0xff77869E),
                        labelColor: Colors.black,
                        tabs: indicators
                            .map((model) => Tab(child: Text(model.day_name)))
                            .toList(),

                        // [
                        // Tab(
                        //   child: Text("Today"),
                        // ),
                        // // Tab(
                        // //   //   child: Text.rich(
                        // //   // TextSpan(
                        // //   //   text: 'Tomorrow',
                        // //   //   style: TextStyle(
                        // //   //       fontSize: 15,
                        // //   //       fontWeight: FontWeight.bold,
                        // //   //       color: Colors.black,
                        // //   //       decoration: TextDecoration.underline),
                        // //   // ),
                        // // )),
                        // Tab(
                        //   child: Text(DateFormat('EEEE')
                        //       .format(DateTime.now().add(Duration(days: 1)))),
                        // ),
                        // Tab(
                        //   child: Text(DateFormat('EEEE')
                        //       .format(DateTime.now().add(Duration(days: 2)))),
                        // )
                        // ],,
                        controller: _tabController,
                        indicatorColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                      bottomOpacity: 1,
                    )),
                body: TabBarView(
                  children: indicators.map((model) {
                    
                      return ui(model);
                    
                  }).toList(),

                  // children: [
                  //   ui(Color.fromRGBO(164, 255, 179, 1), "LOW", 0.5),
                  //   ui(Color.fromRGBO(254, 245, 84, 1), "MEDIUM", 0.7),
                  //   ui(Color.fromRGBO(255, 55, 66, 1), "HIGH", 0.9),
                  // ],
                  controller: _tabController,
                ),
              );
  }

  Widget ui(DailyIndicatorModel model) {
    return Container(
        // color: Colors.red,

        color: Color.fromRGBO(250, 250, 255, 1),
        padding: EdgeInsets.all(15.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircularPercentIndicator(
                radius: 150.0,
                lineWidth: 20.0,
                // backgroundWidth: 20,
                percent: (model.selected == "high")
                    ? 0.9
                    : (model.selected == "low")
                        ? 0.5
                        : 0.7,
                startAngle: 270,
                center: Text(
                  model.selected,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.underline),
                ),
                // fillColor: Colors.white,
                // arcType: ArcType.HALF,
                backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                progressColor: (model.selected == "high")
                    ? Color.fromRGBO(255, 55, 66, 1)
                    : (model.selected == "low")
                        ? Color.fromRGBO(164, 255, 179, 1)
                        : Color.fromRGBO(254, 245, 84, 1),
                circularStrokeCap: CircularStrokeCap.round,
              ),
              Expanded(child: list(model))
            ]));
  }

  Widget list(model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    // color: Colors.red,
                    decoration: (model.selected == "low") ? BoxDecoration(
                        color: Color.fromRGBO(164, 255, 179, 1),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0)))
                            :
                           (model.selected == "medium") ? BoxDecoration(
                          color: Color.fromRGBO(254, 245, 84, 1),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0)))
                              :
                              BoxDecoration(
                          color: Color.fromRGBO(255, 55, 66, 1),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0))),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    model.selected,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text((model.selected == "low ") ? model.low : (model.selected == "medium") ? model.medium : model.high)
            ],
          ),
          SizedBox(
            height: 20,
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Row(
          //       children: [
          //         Container(
          //             height: 30,
          //             width: 30,
          //             decoration: BoxDecoration(
          //                 color: Color.fromRGBO(254, 245, 84, 1),
          //                 shape: BoxShape.rectangle,
          //                 borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(8.0),
          //                     topRight: Radius.circular(8.0),
          //                     bottomRight: Radius.circular(8.0),
          //                     bottomLeft: Radius.circular(8.0)))),
          //         SizedBox(
          //           width: 20,
          //         ),
          //         Text(
          //           "Medium",
          //           style: TextStyle(
          //             fontSize: 25,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.black,
          //           ),
          //         )
          //       ],
          //     ),
          //     SizedBox(
          //       height: 20,
          //     ),
          //     Text(model.medium)
          //   ],
          // ),
          SizedBox(
            height: 20,
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Row(
          //       children: [
          //         Container(
          //             height: 30,
          //             width: 30,
          //             decoration: BoxDecoration(
          //                 color: Color.fromRGBO(255, 55, 66, 1),
          //                 shape: BoxShape.rectangle,
          //                 borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(8.0),
          //                     topRight: Radius.circular(8.0),
          //                     bottomRight: Radius.circular(8.0),
          //                     bottomLeft: Radius.circular(8.0)))),
          //         SizedBox(
          //           width: 20,
          //         ),
          //         Text(
          //           "High",
          //           style: TextStyle(
          //             fontSize: 25,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.black,
          //           ),
          //         )
          //       ],
          //     ),
          //     SizedBox(
          //       height: 20,
          //     ),
          //     Text(model.high),
          //     SizedBox(
          //       height: 20,
          //     ),
          //     // Text("Chats Tab Bar View"),
          //   ],
          // ),
        ],
      ),
    );
  }
}
