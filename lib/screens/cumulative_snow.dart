import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/snow_forecast_model.dart';
import 'package:aspen_weather/models/snow_forecast_range.dart';
import 'package:aspen_weather/models/snow_forecast_weekly.dart';
import 'package:aspen_weather/models/storm_list_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/Dialogs.dart';
import 'package:aspen_weather/utils/bar_chart_graph.dart';
import 'package:aspen_weather/utils/bar_chart_model.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class CumulativeSnowScreen extends StatefulWidget {
  static const routeName = '/cumulative-snow-screen';

  @override
  _CumulativeSnowScreenState createState() => _CumulativeSnowScreenState();
}

class _CumulativeSnowScreenState extends State<CumulativeSnowScreen> {
  String weatherType;
  String bannerImageUrl = '';
  User user;
  List<StormListModel> stormList = List();
  final List<BarChartModel> dataGraph = List();
  String startDate = '2020-12-04', endDate = '2021-01-04';

  String accessToken = '';
  AdsModel ad;

  int butterMilkValue = 0, highLandValue = 0, snowMassValue = 0, ajaxValue = 0;
  PageController _controller = PageController(
    initialPage: 0,
  );
  List<AdsModel> addsList = List();
  @override
  void initState() {
    super.initState();
    endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    print("Date format is ");
    print(DateFormat.yMMMMd().format(DateTime.now()));
    // Prefs.getaddModel((AdsModel adds) async {
    //   setState(() {
    //     bannerImageUrl = adds.attachment_url;
    //     ad = adds;
    //   });
    // });

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      this.accessToken = accessToken;
      apiCallForAd(accessToken);
      apiCallForGetForecastDateRange(accessToken);
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
                    'assets/images/cumulative_head.png',
                    width: 150,
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
                      '',
                      width: 25,
                      height: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 10),
              color: Color(0xffF8F9FF),
              child: Column(children: [
                Text(
                    " April 12, 2020 until ${DateFormat.yMMMMd().format(DateTime.now())}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff31343D),
                        fontSize: 20)),
                SizedBox(
                  height: 50,
                ),
                BarChartGraph(
                  data: dataGraph,
                ),
              ]),
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     launchURL(ad?.url ?? "");
          //   },
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Image.network(bannerImageUrl,
          //         height: 100, width: MediaQuery.of(context).size.width),
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

  Future<void> apiCallForGetForecastDateRange(String accessToken) async {
    Dialogs.showLoadingDialog(context);

    getSnowForecastCumulative(
        authToken: accessToken,
        startDate: startDate,
        endDate: endDate,
        onSuccess: (BaseModel baseModel) {
          Dialogs.hideDialog(context);

          if (baseModel.data != null) {
            SnowForecastRange forecastModel =
                SnowForecastRange.fromJson(baseModel.data);

            setState(() {
              butterMilkValue = int.parse(forecastModel.buttermilk);
              highLandValue = int.parse(forecastModel.highlands);
              snowMassValue = int.parse(forecastModel.snowmass);
              ajaxValue = int.parse(forecastModel.ajax);

              var butterMilkModel = BarChartModel(
                  year: "Buttermilk",
                  financial: butterMilkValue,
                  color: charts.ColorUtil.fromDartColor(Color(0xFF628EFF)));

              var highLandModel = BarChartModel(
                  year: "Highlands",
                  financial: highLandValue,
                  color: charts.ColorUtil.fromDartColor(Color(0xFF3D73FF)));

              var snowMassModel = BarChartModel(
                  year: "Snowmass",
                  financial: snowMassValue,
                  color: charts.ColorUtil.fromDartColor(Color(0xFF85A7FF)));

              var ajaxModel = BarChartModel(
                  year: "Ajax",
                  financial: ajaxValue,
                  color: charts.ColorUtil.fromDartColor(Color(0xFFAAC2FF)));

              dataGraph.add(highLandModel);
              dataGraph.add(snowMassModel);
              dataGraph.add(ajaxModel);
              dataGraph.add(butterMilkModel);
            });
          }
        },
        onError: (String error, BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(error);
        });
  }
}
