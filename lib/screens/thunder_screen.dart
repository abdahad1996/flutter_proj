import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/storm_list_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/bar_chart_graph.dart';
import 'package:aspen_weather/utils/bar_chart_model.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ThunderScreen extends StatefulWidget {
  static const routeName = '/thunder-screen';

  @override
  _ThunderScreenState createState() => _ThunderScreenState();
}

class _ThunderScreenState extends State<ThunderScreen> {
  String weatherType;
  bool checkedValue = false;
  User user;
  List<StormListModel> stormList = List();
  final List<BarChartModel> dataGraph = List();
  String bannerImageUrl = '';
  bool isLoading = false;
  AdsModel ad;
  PageController _controller = PageController(
    initialPage: 0,
  );
  List<AdsModel> addsList = List();
  @override
  void initState() {
    super.initState();
    print("thunder screen is $isLoading");
    isLoading = true;

    // Prefs.getaddModel((AdsModel ad) async {
    //   setState(() {
    //     bannerImageUrl = ad.attachment_url;
    //     ad = ad;
    //   });
    // });

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      apiCallForAd(accessToken);
      BaseModel baseModel =
          await getStormForecast(authToken: accessToken).catchError((error) {
        print(error);
        setState(() {
          isLoading = false;
        });
      });

      setState(() {
        stormList.clear();
        isLoading = false;

        if (baseModel != null && baseModel.data != null) {
          List list = baseModel.data as List;

          if (list.length == 0) {
            // toast('No records found');
          } else {
            for (var value in list) {
              StormListModel model = StormListModel.fromJson(value);
              model.color = charts.ColorUtil.fromDartColor(Color(0xFF47505F));

              String pointValue = model.value;
              double doublePoint = double.parse(pointValue);
              int intPoint = doublePoint.toInt();

              dataGraph.add(BarChartModel(
                  year: model.key.replaceAll("-", "\n-\n"),
                  financial: intPoint,
                  color: charts.ColorUtil.fromDartColor(Color(0xFF628EFF))));

              stormList.add(model);
            }
          }
        }
      });
    });
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
            Prefs.setListData(Const.addsFromPref, list);
            print("ads data is $list");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xffF3F3F3),
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
                      width: 30,
                      height: 15,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Thunder Storm",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff042C5C),
                          fontSize: 20)),
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
            child: isLoading
                ? Center(child: CupertinoActivityIndicator())
                : stormList.length == 0
                    ? Center(child: Text("No Records Found"))
                    : ListView(
                        padding: EdgeInsets.only(left: 5),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          Center(
                            child: Text(
                                "Cory\'s Thunderstorm predictions for today",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff222222),
                                    fontSize: 18)),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          BarChartGraph(
                            data: dataGraph,
                          ),
                        ],
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
}
