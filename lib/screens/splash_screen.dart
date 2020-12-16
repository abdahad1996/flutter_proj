import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/screens/payment_packages.dart';
import 'package:aspen_weather/screens/summer_home_screen.dart';
import 'package:aspen_weather/screens/winter_home_screen.dart';
import 'package:aspen_weather/utils/ScreenConfig.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool timesUp = false;
  bool isLoadingComplete = false;
  String weatherType;
  User user;

  @override
  void initState() {
    super.initState();

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(weatherType == Const.WEATHER_TYPE_SUMMER
                      ? 'assets/images/splash_summer_bg.png'
                      : 'assets/images/splash_winter_bg.png'),
                  fit: BoxFit.fill)),
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text("Welcome to\nASPEN WEATHER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff31343D),
                        fontSize: 32)),
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff222222),
                        fontSize: 18)),
                IconButton(
                  icon: Image.asset('assets/images/ic_blue_next.png'),
                  iconSize: 70,
                  onPressed: () {
                    Prefs.getAccessToken((String accessToken) {
                      if (accessToken == null) {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      } else {
                        Prefs.getUser((User userModel) async {
                          if (!userModel.payment_status) {
                            Prefs.clearPackageId();
                            Navigator.pushNamed(
                                context, PackagesScreen.routeName);
                          } else {
                            if (weatherType == Const.WEATHER_TYPE_SUMMER) {
                              Navigator.pushReplacementNamed(
                                  context, SummerHomeScreen.routeName,
                                  arguments: {
                                    'user': user,
                                  });
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, WinterHomeScreen.routeName,
                                  arguments: {
                                    'user': user,
                                  });
                            }
                          }
                        });
                      }
                    });
                  },
                )
              ],
            ),
          ))),
    );
  }
}
