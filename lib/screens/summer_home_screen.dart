import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/packages_list_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/airport_screen.dart';
import 'package:aspen_weather/screens/payment_packages.dart';
import 'package:aspen_weather/screens/profile_screen.dart';
import 'package:aspen_weather/screens/summer_discussion_tab.dart';
import 'package:aspen_weather/screens/summer_home_tab.dart';
import 'package:aspen_weather/screens/summer_indicator_tab.dart';
import 'package:aspen_weather/screens/summer_rain_tab.dart';
import 'package:aspen_weather/screens/terms_screen.dart';
import 'package:aspen_weather/screens/thunder_screen.dart';
import 'package:aspen_weather/screens/why_join_screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/CachedImage.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/textFontadapter.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'about_screen.dart';
import 'login_screen.dart';

class SummerHomeScreen extends StatefulWidget {
  static const routeName = '/summer-home-screen';

  @override
  _SummerHomeScreenState createState() => _SummerHomeScreenState();
}

class _SummerHomeScreenState extends State<SummerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _controller = PageController(
    initialPage: 0,
  );
  List<AdsModel> addsList = List();

  String weatherType;
  bool checkedValue = false;

  bool isHomeActive = true;
  bool isRainSnowActive = false;
  bool isIndicatorActive = false;
  bool isDiscussionActive = false;

  User user;
  int _currentIndex = 0;
  String accessToken = '';
  String bannerImageUrl = '';
  AdsModel ad;
  String existingPackageId;
  List<PackagesListModel> packagesList = List();

  final List<Widget> _children = [
    SummerHomeTabScreen(),
    SummerRainTabScreen(),
    SummerIndicatorTabScreen(),
    SummerDiscussTabScreen()
  ];

  @override
  void initState() {
    super.initState();

    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      this.accessToken = accessToken;
      apiCallForAd(accessToken);
      // checkForPackageExpiry(accessToken);
    });

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    Prefs.getUser((User userModel) async {
      setState(() {
        user = userModel;
        // print("user is ${user.details.image_url}");
      });
    });
  }

  // Future<void> apiCallForAd(String accessToken) async {
  //   getAd(
  //       authToken: accessToken,
  //       onSuccess: (BaseModel baseModel) {
  //         if (baseModel.data != null) {
  //           AdsModel adModel = AdsModel.fromJson(baseModel.data);
  //           Prefs.setAdsUrl(adModel);

  //           setState(() {
  //             this.bannerImageUrl = adModel.attachment_url;
  //             ad = adModel;
  //           });
  //         }
  //       },
  //       onError: (String error, BaseModel baseModel) {
  //         toast(error);
  //       });
  // }

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

  // Future checkForPackageExpiry(String accessToken) async {
  //   Prefs.getPackageId((String packageId) async {
  //     existingPackageId = packageId;
  //     print('existingPackageId ${existingPackageId}');
  //   });

  //   print(accessToken);

  //   //check if current pacakge id Exist then show selected pacakge

  //   BaseModel baseModel =
  //       await getPackagesScreen(authToken: accessToken).catchError((error) {
  //     print(error);
  //   });

  //   if (baseModel != null && baseModel.data != null) {
  //     List list = baseModel.data as List;
  //     if (list.length == 0) {
  //       // toast('No records found');
  //       //logout
  //       Prefs.setAccessToken(null);
  //       Prefs.removeUser();
  //       Navigator.of(context).pushNamedAndRemoveUntil(
  //           LoginScreen.routeName, (Route<dynamic> route) => false);
  //     } else {
  //       for (var value in list) {
  //         PackagesListModel model = PackagesListModel.fromJson(value);
  //         packagesList.add(model);
  //         if (model.id == existingPackageId) {
  //           if (model.status != 1) {
  //             //logout
  //             Prefs.setAccessToken(null);
  //             Prefs.removeUser();
  //             Navigator.of(context).pushNamedAndRemoveUntil(
  //                 LoginScreen.routeName, (Route<dynamic> route) => false);
  //           }
  //         }
  //         print("package is ${model.id}");
  //         print("package is ${model.name}");
  //         print("package is ${model.no_of_days_validity}");
  //         print("package is ${model.amount}");
  //         print("package is ${model.status}");
  //       }
  //     }
  //   } else {
  //     //logout
  //     Prefs.setAccessToken(null);
  //     Prefs.removeUser();
  //     Navigator.of(context).pushNamedAndRemoveUntil(
  //         LoginScreen.routeName, (Route<dynamic> route) => false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            key: _scaffoldKey,
            floatingActionButton: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child:
                  // new FloatingActionButton(
                  //   backgroundColor: Colors.white,
                  //   foregroundColor: Colors.white,
                  //   focusColor: Colors.white,
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, AirportScreen.routeName);
                  //   },
                  //   child: Image.asset('assets/images/airport_webcam.png'),
                  // ),
                  new FloatingActionButton(
                backgroundColor: Color.fromRGBO(65, 119, 251, 1),
                foregroundColor: Colors.white,
                focusColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, AirportScreen.routeName);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/images/airport_float_icon.png',
                    //   fit: BoxFit.cover,
                    //   width: 20,
                    //   height: 20,
                    // ),
                    //           Align(
                    // alignment: Alignment.center,
                    // child: Container(
                    //   // color: Colors.red,
                    //   child: Text(
                    //     "Should be left",
                    //     style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //              color: Colors.white,
                    //             fontSize: 8),
                    //   ),
                    // ),
                    //           )
                    AdaptableText(
                      "aspen airport cam",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            drawer: Drawer(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/images/ic_cross_black.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      // clipBehavior: Clip,
                      borderRadius: BorderRadius.circular(50),

                      // decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        (weatherType != null)
                            ? (weatherType == Const.WEATHER_TYPE_SUMMER)
                                ? 'assets/images/summer.png'
                                : 'assets/images/winter.png'
                            : 'assets/images/summer.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 40, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, PackagesScreen.routeName);
                        },
                        child: Image.asset(
                          "assets/images/side_menu_package.png",
                          width: 150,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 40, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, ThunderScreen.routeName);
                        },
                        child: Image.asset(
                          "assets/images/side_menu_thunder.png",
                          width: 200,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 40, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, TermsScreen.routeName);
                      },
                      child: Image.asset(
                        "assets/images/side_menu_terms.png",
                        width: 240,
                        height: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 40, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, WhyJoin.routeName);
                      },
                      child: Image.asset(
                        "assets/images/side_menu_join.png",
                        width: 200,
                        height: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AboutScreen.routeName);
                      },
                      child: Image.asset(
                        "assets/images/side_menu_about.png",
                        width: 188,
                        height: 25,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                  //   child: GestureDetector(
                  //     onTap: () {},
                  //     child: Image.asset(
                  //       "assets/images/side_menu_rate.png",
                  //       width: 195,
                  //       height: 25,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 35, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        logOut(context);

                        Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginScreen.routeName,
                            (Route<dynamic> route) => false);
                      },
                      child: Image.asset(
                        "assets/images/side_menu_sign_out.png",
                        width: 140,
                        height: 25,
                      ),
                    ),
                  )
                ],
              ),
            )),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    color: _getColorForTab(_currentIndex),
                    child: Align(
                      alignment: FractionalOffset.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _scaffoldKey.currentState.openDrawer();
                                },
                                child: Image.asset(
                                  "assets/images/ic_side_menu.png",
                                  fit: BoxFit.contain,
                                  width: 30,
                                  height: 40,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: _currentIndex == 0
                                      ? Container()
                                      : Text(
                                          getTitleForTabs(_currentIndex),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff222222),
                                              fontSize: 20),
                                        ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.pushNamed(
                              //         context, ProfileScreen.routeName);
                              //   },
                              //   child: Cached_Image(
                              //     height: 40,
                              //     width: 40,
                              //     imageURL: user?.details?.image_url ?? "",
                              //     shape: BoxShape.circle,
                              //     retry: (status) {
                              //       print("RETRYINGGG");
                              //       print("RETRYINGGG");
                              //       Prefs.getUser((User userModel) async {
                              //         setState(() {
                              //           user = userModel;
                              //           // print("user is ${user.details.image_url}");
                              //         });
                              //       });
                              //     },
                              //   ),
                              // ),
                              Container(
                                // color: Colors.grey,

                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ProfileScreen.routeName);
                                    // launchURL(model?.url ?? "");
                                  },
                                  child: ClipOval(
                                    child: Image.network(
                                      user?.details?.image_url ?? "",
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                ),
                                // decoration:
                                //     BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Expanded(child: _children[_currentIndex]),
                  Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
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
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              "assets/images/menu_bottom_bg.png"),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _currentIndex = 0;
                                                  isHomeActive = true;
                                                  isRainSnowActive = false;
                                                  isIndicatorActive = false;
                                                  isDiscussionActive = false;
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 15, 0, 0),
                                                child: isHomeActive
                                                    ? Image.asset(
                                                        'assets/images/menu_home_inactive.png',
                                                        width: 40,
                                                        height: 40,
                                                        color:
                                                            Color(0xFF3D73FF),
                                                      )
                                                    : Image.asset(
                                                        'assets/images/menu_home_inactive.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _currentIndex = 1;
                                                  isHomeActive = false;
                                                  isRainSnowActive = true;
                                                  isIndicatorActive = false;
                                                  isDiscussionActive = false;
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 15, 0, 0),
                                                child: isRainSnowActive
                                                    ? Image.asset(
                                                        'assets/images/menu_thunder.png',
                                                        width: 40,
                                                        height: 40,
                                                        color:
                                                            Color(0xFF3D73FF),
                                                      )
                                                    : Image.asset(
                                                        'assets/images/menu_thunder.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Container(),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _currentIndex = 2;
                                                  isHomeActive = false;
                                                  isRainSnowActive = false;
                                                  isIndicatorActive = true;
                                                  isDiscussionActive = false;
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 15, 0, 0),
                                                child: isIndicatorActive
                                                    ? Image.asset(
                                                        'assets/images/menu_indicator.png',
                                                        width: 40,
                                                        height: 40,
                                                        color:
                                                            Color(0xFF3D73FF),
                                                      )
                                                    : Image.asset(
                                                        'assets/images/menu_indicator.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _currentIndex = 3;
                                                  isHomeActive = false;
                                                  isRainSnowActive = false;
                                                  isIndicatorActive = false;
                                                  isDiscussionActive = true;
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 15, 0, 0),
                                                child: isDiscussionActive
                                                    ? Image.asset(
                                                        'assets/images/menu_discussion.png',
                                                        width: 40,
                                                        height: 40,
                                                        color:
                                                            Color(0xFF3D73FF),
                                                      )
                                                    : Image.asset(
                                                        'assets/images/menu_discussion.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
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

  Future<bool> _onWillPop() async {
    bool isExit = false;

    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text("Exit Application"),
        content: new Text("Are you sure you want to exit the Application?"),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              isExit = false;
            },
            child: new Text("NO"),
          ),
          new FlatButton(
            onPressed: () {
              // Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 1000), () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              });
              isExit = false;
            },
            child: new Text("YES"),
          ),
        ],
      ),
    );

    // }
    return isExit;
  }

  Color _getColorForTab(int index) {
    return index == 2 ? Color(0xffFAFAFF) : Colors.white;
  }

  String getTitleForTabs(int index) {
    if (index == 0) {
      return '';
    } else if (index == 1) {
      return 'Thunderstorm';
    } else if (index == 2) {
      return 'Daily Indicator';
    } else {
      return 'Discussion';
    }
  }
}
