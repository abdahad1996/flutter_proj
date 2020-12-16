import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/Winter_home_tab.dart';
import 'package:aspen_weather/screens/about_screen.dart';
import 'package:aspen_weather/screens/airport_screen.dart';
import 'package:aspen_weather/screens/login_screen.dart';
import 'package:aspen_weather/screens/payment_packages.dart';
import 'package:aspen_weather/screens/profile_screen.dart';
import 'package:aspen_weather/screens/summer_discussion_tab.dart';
import 'package:aspen_weather/screens/summer_indicator_tab.dart';
import 'package:aspen_weather/screens/terms_screen.dart';
import 'package:aspen_weather/screens/thunder_screen.dart';
import 'package:aspen_weather/screens/why_join_screen.dart';
import 'package:aspen_weather/screens/winter_snow_tab.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WinterHomeScreen extends StatefulWidget {
  static const routeName = '/Winter-home-screen';

  @override
  _WinterHomeScreenState createState() => _WinterHomeScreenState();
}

class _WinterHomeScreenState extends State<WinterHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String weatherType;
  bool checkedValue = false;
  User user;

  bool isHomeActive = true;
  bool isRainSnowActive = false;
  bool isIndicatorActive = false;
  bool isDiscussionActive = false;

  int _currentIndex = 0;

  final List<Widget> _children = [
    WinterHomeTabScreen(),
    WinterSnowTabScreen(),
    SummerIndicatorTabScreen(),
    SummerDiscussTabScreen()
  ];

  String accessToken = '';
  String bannerImageUrl = '';

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
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: new FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            focusColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, AirportScreen.routeName);
            },
            child: Image.asset('assets/images/airport_webcam.png'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        drawer: Drawer(
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
        )),
        body: SafeArea(
          child: Stack(
            children: [
              _children[_currentIndex],
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
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
                                  style: TextStyle(fontWeight: FontWeight.bold,
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
                              child: Image.asset(
                                "assets/images/ic_profile.png",
                                fit: BoxFit.contain,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.white,
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
                                                'assets/images/menu_snow_inactive.png',
                                                width: 40,
                                                height: 40,
                                                color: Color(0xFF3D73FF),
                                              )
                                                  : Image.asset(
                                                'assets/images/menu_snow_inactive.png',
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
              ),

            ],
          ),
        ));
  }

  Color _getColorForTab(int index) {
    if (index == 0) {
      return Color(0xfffff);
    } else if (index == 1) {
      return Color(0xffE1E1E6);
    } else if (index == 2) {
      return Color(0xffFAFAFF);
    } else {
      return Colors.white;
    }
  }

  String getTitleForTabs(int index) {
    if (index == 0) {
      return '';
    } else if (index == 1) {
      return 'Snow Forecast';
    } else if (index == 2) {
      return 'Delay Indicator';
    } else {
      return 'Discussion';
    }
  }
}
