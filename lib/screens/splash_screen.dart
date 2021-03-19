import 'package:aspen_weather/models/packages_list_model.dart';
import 'package:aspen_weather/models/themeModel.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/payment_packages.dart';
import 'package:aspen_weather/screens/summer_home_screen.dart';
import 'package:aspen_weather/screens/winter_home_screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/ScreenConfig.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool timesUp = false;
  bool isLoading = false;
  String themeTypeUrl;
  String weatherType;
  String existingPackageId;
  List<PackagesListModel> packagesList = List();
  User user;

  @override
  void initState() {
    super.initState();
//Get the physical device size
    // print(Device.size);
//Quick methods to access the physical device width and height
    print(
        "physical Device Width: ${Device.width}, Device Height: ${Device.height}");

//To get the actual screen size (Which is same as what MediaQuery gives)
    // print(Device.screenSize);
//Quick methods to access the screen width and height
    print(
        "MediaQuery Device Width: ${Device.screenWidth}, Device Height: ${Device.screenHeight}");
    print("IPHONEX ${Device.get().isIphoneX}");
//Check if device is at least an iphone x
// NOTE: This detects up to Iphone 12 pro max
    if (Device.get().isIphoneX) {
      print("IPHONEX");
      //Do some notch business
    }
    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });
    setState(() {
      isLoading = true;
    });
    Prefs.getAccessToken((String accessToken) async {
      print("access token is  $accessToken");
      if (accessToken == null) {
        // BaseModel baseModel =
        //     await getTheme(authToken: accessToken).catchError((error) {
        //   print("error is $error ");
        //   // toast(error);
        // });
        setState(() {
          isLoading = false;
        });
        return;
      }
      //check for validity of package

      //get theme
      BaseModel baseModel =
          await getTheme(authToken: accessToken).catchError((error) {
        print("error is $error ");
        // toast(error);
      });

      print("BASEMODEL THEME IS $baseModel");

      // title = "";
      // content = "";

      if (baseModel != null && baseModel.data != null) {
        ThemeModel dataModel = ThemeModel.fromJson(baseModel.data);
        // title = dataModel.title;
        // content = dataModel.content;
        setState(() {
          isLoading = false;
          print("theme name is ${dataModel.name}");
          // Prefs.getWeatherType((String weather) {
          Prefs.setWeatherType(dataModel.name);
          weatherType = dataModel.name;
          themeTypeUrl = dataModel.coverurl;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // toast('No data available!');
      }
    });
  }

  Future checkForPackageExpiry(String accessToken) async {
    Prefs.getPackageId((String packageId) async {
      existingPackageId = packageId;
      print('existingPackageId ${existingPackageId}');
    });

    print(accessToken);

    //check if current pacakge id Exist then show selected pacakge

    BaseModel baseModel =
        await getPackagesScreen(authToken: accessToken).catchError((error) {
      print(error);
    });

    if (baseModel != null && baseModel.data != null) {
      List list = baseModel.data as List;
      if (list.length == 0) {
        // toast('No records found');
      } else {
        for (var value in list) {
          PackagesListModel model = PackagesListModel.fromJson(value);
          packagesList.add(model);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      body: isLoading
          ? Center(child: CupertinoActivityIndicator())
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: (themeTypeUrl != null)
                          ? NetworkImage(themeTypeUrl)
                          : AssetImage(weatherType == Const.WEATHER_TYPE_SUMMER
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
                              user = userModel;
                              if ((user == null) ||
                                  (user.payment_status == null)) {
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
