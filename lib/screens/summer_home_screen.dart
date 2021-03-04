import 'package:aspen_weather/models/active_ad_model.dart';
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

import 'about_screen.dart';
import 'login_screen.dart';

class SummerHomeScreen extends StatefulWidget {
  static const routeName = '/summer-home-screen';

  @override
  _SummerHomeScreenState createState() => _SummerHomeScreenState();
}

class _SummerHomeScreenState extends State<SummerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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

  Future<void> apiCallForAd(String accessToken) async {
    getAd(
        authToken: accessToken,
        onSuccess: (BaseModel baseModel) {
          if (baseModel.data != null) {
            AdsModel adModel = AdsModel.fromJson(baseModel.data);
            Prefs.setAdsUrl(adModel.attachment_url);

            setState(() {
              this.bannerImageUrl = adModel.attachment_url;
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  padding: const EdgeInsets.fromLTRB(8, 40, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, PackagesScreen.routeName);
                    },
                    child: Image.asset(
                      "assets/images/side_menu_package.png",
                      width: 150,
                      height: 25,
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
                padding: const EdgeInsets.fromLTRB(8, 70, 0, 0),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    "assets/images/side_menu_rate.png",
                    width: 195,
                    height: 25,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    logOut(context);

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginScreen.routeName, (Route<dynamic> route) => false);
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
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ProfileScreen.routeName);
                            },
                            child: Cached_Image(
                              height: 40,
                              width: 40,
                              imageURL: user?.details?.image_url ?? "",
                              shape: BoxShape.circle,
                              retry: (status) {
                                print("RETRYINGGG");
                                print("RETRYINGGG");
                                Prefs.getUser((User userModel) async {
                                  setState(() {
                                    user = userModel;
                                    // print("user is ${user.details.image_url}");
                                  });
                                });
                              },
                            ),
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
                          Container(
                            child: GestureDetector(
                              onTap: () {},
                              child: Image.network(
                                bannerImageUrl,
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                                                0, 10, 0, 0),
                                            child: isHomeActive
                                                ? Image.asset(
                                                    'assets/images/menu_home_inactive.png',
                                                    width: 40,
                                                    height: 40,
                                                    color: Color(0xFF3D73FF),
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
                                                0, 10, 0, 0),
                                            child: isRainSnowActive
                                                ? Image.asset(
                                                    'assets/images/menu_thunder.png',
                                                    width: 40,
                                                    height: 40,
                                                    color: Color(0xFF3D73FF),
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
                                                0, 10, 0, 0),
                                            child: isIndicatorActive
                                                ? Image.asset(
                                                    'assets/images/menu_indicator.png',
                                                    width: 40,
                                                    height: 40,
                                                    color: Color(0xFF3D73FF),
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
                                                0, 10, 0, 0),
                                            child: isDiscussionActive
                                                ? Image.asset(
                                                    'assets/images/menu_discussion.png',
                                                    width: 40,
                                                    height: 40,
                                                    color: Color(0xFF3D73FF),
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
        ));
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
