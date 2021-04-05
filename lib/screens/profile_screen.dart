import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/Notification_Screen.dart';
import 'package:aspen_weather/screens/change_password_screen.dart';
import 'package:aspen_weather/screens/splash_screen.dart';
import 'package:aspen_weather/screens/updateProfile_Screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/CachedImage.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String weatherType;
  String bannerImageUrl = '';
  User user;
  AdsModel ad;
  PageController _controller = PageController(
    initialPage: 0,
  );
  List<AdsModel> addsList = List();
  @override
  void initState() {
    super.initState();

    // Prefs.getaddModel((AdsModel ad) async {
    //   setState(() {
    //     bannerImageUrl = ad.attachment_url;
    //     ad = ad;
    //   });
    // });
    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      apiCallForAd(accessToken);
      // this.accessToken = accessToken;
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

  void load() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xffE5E5E5),
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
                    'assets/images/profile_head.png',
                    width: 50,
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
                      // Navigator.pop(context);
                      Navigator.pushNamed(
                          context, NotificationScreen.routeName);
                    },
                    child: Image.asset(
                      'assets/images/ic_notification.png',
                      width: 25,
                      height: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: [
                // Cached_Image(
                //   height: 80,
                //   width: 80,
                //   imageURL: user?.details?.image_url ?? "",
                //   shape: BoxShape.circle,
                //   retry: (status) {
                //     print("RETRYINGGG");
                //   },
                // ),
                Container(
                  // color: Colors.grey,

                  child: GestureDetector(
                    onTap: () {
                      // launchURL(model?.url ?? "");
                    },
                    child: ClipOval(
                      child: Image.network(
                        user?.details?.image_url ?? "",
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                  // decoration:
                  //     BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                ),
                // (user.details.image_url == null)
                //     ? Image.asset(
                //         'assets/images/test_profile_pic.png',
                //         width: 80,
                //         height: 80,
                //       )
                //     : Container(
                //         decoration: BoxDecoration(
                //             image: DecorationImage(
                //                 image: NetworkImage(user.details.image_url),
                //                 fit: BoxFit.fill))),
                SizedBox(
                  height: 3,
                ),
                Text(
                  user?.name ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff042C5C),
                      fontSize: 20),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  user?.email ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xff77869E),
                      fontSize: 15),
                ),
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, UpdateProfileScreen.routeName);
                  },
                  child: Image.asset('assets/images/cell_profile.png'),
                ),
                SizedBox(height: 6),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ChangePasswordScreen.routeName);
                    },
                    child: Image.asset('assets/images/cell_privacy.png')),
                SizedBox(height: 6),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, NotificationScreen.routeName);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 80,
                          color: Colors.white70,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    "Notifications",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff042C5C),
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Transform.rotate(
                                    angle: -math.pi,
                                    child: Image.asset(
                                      'assets/images/back_arrow.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    )),
                // Image.asset('assets/images/cell_notification.png')),
                SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    // showAlertDialog(context);
                  },
                  child: Image.asset(weatherType == Const.WEATHER_TYPE_SUMMER
                      ? 'assets/images/cell_theme_summer.png'
                      : 'assets/images/cell_winter.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Image.network(
                //     bannerImageUrl,
                //     height: 80,
                //     width: double.infinity,
                //   ),
                // ),
                // Expanded(child: Container()),
                addsList.isEmpty
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            height: 75,
                            alignment: Alignment.bottomCenter,
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
              ],
            ),
          ),
        ],
      ),
    )));
  }

  showAlertDialog(BuildContext context) {
    String value =
        weatherType == Const.WEATHER_TYPE_SUMMER ? 'winter' : 'summer';

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Prefs.setWeatherType(weatherType == Const.WEATHER_TYPE_SUMMER
            ? Const.WEATHER_TYPE_WINTER
            : Const.WEATHER_TYPE_SUMMER);

        Navigator.of(context).pushNamedAndRemoveUntil(
            SplashScreen.routeName, (Route<dynamic> route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Would you like to change theme to $value?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
