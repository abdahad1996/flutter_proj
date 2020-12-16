import 'package:aspen_weather/models/three_days_forecast_list_model.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnowForecastScreen extends StatefulWidget {
  static const routeName = '/snow-forecast-screen';

  @override
  _SnowForecastScreenState createState() => _SnowForecastScreenState();
}

class _SnowForecastScreenState extends State<SnowForecastScreen> {
  String weatherType;
  List<ThreeDaysForeCastModel> packagesList = List();
  String bannerImageUrl = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    Prefs.getAdsUrl((String adUrl) async {
      setState(() {
        bannerImageUrl = adUrl;
      });
    });

    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);

      BaseModel baseModel = await getThreeDaysForecast(authToken: accessToken)
          .catchError((error) {
        print(error);
      });

      setState(() {
        packagesList.clear();

        if (baseModel != null && baseModel.data != null) {
          List list = baseModel.data as List;

          if (list.length == 0) {
            toast('No records found');
          } else {
            for (var value in list) {
              ThreeDaysForeCastModel model =
                  ThreeDaysForeCastModel.fromJson(value);
              packagesList.add(model);
            }
          }
        }
      });
    });

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xffF8F9FF),
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
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Image.asset(
                    'assets/images/three_forecast_head.png',
                    width: 130,
                    height: 50,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/images/ic_info.png',
                      width: 25,
                      height: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Color(0xffF5F5FA),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 100,
                    child: packagesList.length == 0
                        ? Center(child: Text("No Records Found"))
                        : Card(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Image.network(
                                  packagesList[index].icon_url,
                                  width: 70,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            child: Text(
                                                packagesList[index]
                                                    .date_formatted,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff222222),
                                                    fontSize: 15)),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                packagesList[index].exerpt,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color(0xff222222),
                                                    fontSize: 14)),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                packagesList[index].description,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color(0xff222222),
                                                    fontSize: 9)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                  );
                },
                itemCount: packagesList.length,
                shrinkWrap: true,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.network(bannerImageUrl,
                height: 100, width: MediaQuery.of(context).size.width),
          ),
        ],
      ),
    )));
  }
}
