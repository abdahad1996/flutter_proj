import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/three_days_forecast_list_model.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
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
  bool isLoading = false;
  AdsModel ads;
  PageController _controller = PageController(
    initialPage: 0,
  );
  List<AdsModel> addsList = List();
  @override
  void initState() {
    super.initState();
    isLoading = true;
    load();
  }

  void load() async {
    // Prefs.getaddModel((AdsModel ad) async {
    //   setState(() {
    //     bannerImageUrl = ad.attachment_url;
    //     ads = ad;
    //   });
    // });

    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      apiCallForAd(accessToken);
      BaseModel baseModel = await getThreeDaysForecast(authToken: accessToken)
          .catchError((error) {
        print(error);
      });

      setState(() {
        isLoading = false;
        packagesList.clear();

        if (baseModel != null && baseModel.data != null) {
          List list = baseModel.data as List;

          if (list.length == 0) {
            // toast('No records found');
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
            child: isLoading
                ? Center(child: CupertinoActivityIndicator())
                :
                // packagesList.isEmpty
                //     ? Center(
                //         child: Container(
                //           child: Text("No record found"),
                //         ),
                //       )
                //     :
                Container(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Image.asset(
                                    'assets/images/back_arrow.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ),
                            ),
                            // Align(
                            //   alignment: Alignment.center,
                            //   child: Container(
                            //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            //       child: Text("Aspen Snowmass 6 day snowfall",
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.bold,
                            //               color: Color(0xff222222),
                            //               fontSize: 20))
                            //       // Image.asset(
                            //       //   'assets/images/three_forecast_head.png',
                            //       //   width: 130,
                            //       //   height: 50,
                            //       // ),
                            //       ),
                            // ),
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
                                    '',
                                    width: 40,
                                    height: 40,
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
                          child: packagesList.length == 0
                              ? Center(child: Text("No Records Found"))
                              : Container(
                                  width: double.infinity,
                                  color: Color(0xffF5F5FA),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: 500, minHeight: 100),
                                        child: packagesList.length == 0
                                            ? Center(
                                                child: Text("No Records Found"))
                                            : Card(
                                                color: Colors.white,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Image.network(
                                                      packagesList[index]
                                                          .icon_url,
                                                      width: 70,
                                                      height: 70,
                                                    ),
                                                    // SizedBox(
                                                    //   width: 5,
                                                    // ),
                                                    Expanded(
                                                      // child: Row(
                                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                                      //   crossAxisAlignment:
                                                      //       CrossAxisAlignment.start,
                                                      //   children: [
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .fromLTRB(
                                                            10, 0, 15, 0),
                                                        child: SingleChildScrollView(
                                                            child: Column(
                                                                //   mainAxisAlignment:
                                                                //       MainAxisAlignment.start,
                                                                //   crossAxisAlignment:
                                                                //       CrossAxisAlignment
                                                                //           .start,
                                                                children: [
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              // Text(
                                                              //     packagesList[
                                                              //             index]
                                                              //         .date_formatted,
                                                              //     maxLines: null,
                                                              //     style: TextStyle(
                                                              //         fontWeight:
                                                              //             FontWeight
                                                              //                 .bold,
                                                              //         color: Color(
                                                              //             0xff222222),
                                                              //         fontSize:
                                                              //             15)),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                  packagesList[
                                                                              index]
                                                                          .exerpt ??
                                                                      "",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          0xff222222),
                                                                      fontSize:
                                                                          20)),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                  packagesList[
                                                                              index]
                                                                          .description ??
                                                                      "",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color: Color(
                                                                          0xff222222),
                                                                      fontSize:
                                                                          14)),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                            ])
                                                            // SizedBox(
                                                            //   height: 10,
                                                            // ),
                                                            //     Expanded(
                                                            //       // alignment: Alignment.topLeft,
                                                            //       child: Text(
                                                            //           packagesList[index]
                                                            //               .description,
                                                            //           style: TextStyle(
                                                            //               fontWeight:
                                                            //                   FontWeight
                                                            //                       .normal,
                                                            //               color: Color(
                                                            //                   0xff222222),
                                                            //               fontSize: 12)),
                                                            //     ),
                                                            //   ],
                                                            // ),
                                                            ),
                                                      ),
                                                      //   ],
                                                      // ),
                                                    ),
                                                    // SizedBox(
                                                    //   width: 10,
                                                    // ),
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
                        // Align(
                        //   alignment: Alignment.bottomCenter,
                        //   child: Image.network(bannerImageUrl,
                        //       height: 100,
                        //       width: MediaQuery.of(context).size.width),
                        // ),
                        // InkWell(
                        //   onTap: () {
                        //     launchURL(ads?.url ?? "");
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
