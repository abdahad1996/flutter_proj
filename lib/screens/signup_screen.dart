import 'dart:io';

import 'package:aspen_weather/main.dart';
import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/error_data_response.dart';
import 'package:aspen_weather/models/user_auth_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/payment_packages.dart';
import 'package:aspen_weather/screens/summer_home_screen.dart';
import 'package:aspen_weather/screens/winter_home_screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/Dialogs.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String weatherType;
  bool checkedValue = false;
  User user;
  String _name, _email, _password, _confirmPassword, _deviceType, _deviceToken;
  bool passwordNotVisible = true;
  bool confirmPasswordNotVisible = true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });
  }

  void load() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.transparent,
      body: Container(
          child: SafeArea(
              child: Stack(
        children: <Widget>[
          Image.asset(weatherType == Const.WEATHER_TYPE_SUMMER
              ? 'assets/images/login_summer_image.png'
              : 'assets/images/login_winter_image.png'),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Image.asset(
                      "assets/images/ic_back_arrow_black.png",
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/login_bottom_card.png'),
                        fit: BoxFit.fill)),
                height: 450,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter your username',
                                labelText: 'Username'),
                            validator: validateName,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(_emailFocus);
                            },
                            keyboardType: TextInputType.text,
                            onSaved: (text) {
                              _name = text;
                            },
                            onChanged: (text) {
                              _name = text;
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter your email',
                                labelText: 'Email'),
                            validator: validateEmail,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocus);
                            },
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (text) {
                              _email = text;
                            },
                            onChanged: (text) {
                              _email = text;
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter your password',
                                labelText: 'Password'),
                            validator: validatePassword,
                            obscureText: passwordNotVisible,
                            autofocus: false,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.done,
                            onSaved: (text) {
                              _password = text;
                            },
                            onChanged: (text) {
                              _password = text;
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Enter your confirm password'),
                            validator: validateConfirmPassword,
                            textInputAction: TextInputAction.done,
                            focusNode: _confirmPasswordFocus,
                            obscureText: confirmPasswordNotVisible,
                            onFieldSubmitted: (v) {},
                            onSaved: (text) {
                              _confirmPassword = text;
                            },
                            onChanged: (text) {
                              _confirmPassword = text;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  side: BorderSide(color: Color(0xff3D73FF))),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  if (_password != _confirmPassword) {
                                    toast(
                                        'Password and Confirm Password must be same.');
                                  } else {
                                    _formKey.currentState.save();
                                    apiCallForSignUp();
                                  }
                                }
                              },
                              color: Color(0xff3D73FF),
                              textColor: Colors.white,
                              child: Text("Sign up",
                                  style: TextStyle(fontSize: 17)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ))),
    );
  }

  Future<void> apiCallForSignUp() async {
    if (Platform.isIOS) {
      _deviceType = "ios";
    } else if (Platform.isAndroid) {
      _deviceType = "android";
    }
    Dialogs.showLoadingDialog(context);
    _deviceToken = "123";

    register(
        name: _name,
        email: _email,
        password: _password,
        confirmPassword: _password,
        deviceType: _deviceType,
        deviceToken: _deviceToken,
        onSuccess: (BaseModel baseModel) {
          Dialogs.hideDialog(context); //toast(baseModel.message);

          if (baseModel.data != null) {
            UserAuthModel userAuthModel =
                UserAuthModel.fromJson(baseModel.data);
            user = userAuthModel.user;

            Prefs.setAccessToken(user.access_token);
            Prefs.setUser(user);
            


            apiCallForAd(user.access_token);
          }
        },
        onError: (String error, BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(error);
        });
  }

  Future<void> apiCallForAd(String accessToken) async {
    getAd(
        authToken: accessToken,
        onSuccess: (BaseModel baseModel) {
          if (baseModel.data != null) {
            AdsModel adModel = AdsModel.fromJson(baseModel.data);
            Prefs.setAdsUrl(adModel.attachment_url);

            if (!user.payment_status) {
              toast(
                  'You need to buy package first to access application features.');
               Prefs.clearPackageId();
              Navigator.pushNamed(context, PackagesScreen.routeName);
            } else {
              if (weatherType == Const.WEATHER_TYPE_SUMMER) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    SummerHomeScreen.routeName,
                    (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    WinterHomeScreen.routeName,
                    (Route<dynamic> route) => false);
              }
            }
          }
        },
        onError: (String error, BaseModel baseModel) {
          toast(error);
        });
  }
}
