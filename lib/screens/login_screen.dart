import 'dart:convert';
import 'dart:io';

import 'package:aspen_weather/main.dart';
import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/user_auth_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/forget_password_screen.dart';
import 'package:aspen_weather/screens/payment_packages.dart';
import 'package:aspen_weather/screens/signup_screen.dart';
import 'package:aspen_weather/screens/summer_home_screen.dart';
import 'package:aspen_weather/screens/winter_home_screen.dart';
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
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:intl/intl.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String weatherType;
  bool checkedValue = false;
  User user;
  String _email, _password, _deviceType, _deviceToken;
  final FocusNode _passwordFocus = FocusNode();
  bool passwordNotVisible = true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _isFacebookLoggedIn = false;
  bool _isGoogleLoggedIn = false;

  /*String _appleEmail = "";
  String _appleName = "";*/
  Map userFacebookProfile;
  final facebookLogin = FacebookLogin();
  GoogleSignInAccount _currentUser;
  String paramSocialId, paramSocialName, paramSocialEmail, paramSocialPlatform;

  @override
  void initState() {
    super.initState();

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    //   setState(() {
    //     _currentUser = account;
    //     _isGoogleLoggedIn = true;
    //   });

    //   if (_currentUser != null) {
    //     _showMessage('Google Logged in!');

    //     _showMessage(_currentUser.id);
    //     _showMessage(_currentUser.displayName);
    //     _showMessage(_currentUser.email);
    //     _showMessage(_currentUser.photoUrl);

    //     if (_currentUser.id != null) {
    //       apiCallForFbGoogleSignIn(
    //           _currentUser.id,
    //           _currentUser.displayName,
    //           _currentUser.email,
    //           'google',
    //           _currentUser.photoUrl,
    //           _currentUser.id,
    //           '',
    //           '');
    //     }
    //   }
    // });
  }

  void load() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.transparent,
      body: Container(
          child: SafeArea(
              child: Stack(
        children: <Widget>[
          Image.asset(weatherType == Const.WEATHER_TYPE_SUMMER
              ? 'assets/images/login_summer_image.png'
              : 'assets/images/login_winter_image.png'),
          /*    Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                child: Container(
                  child: Image.asset(
                    "assets/images/ic_back_arrow_black.png",
                    fit: BoxFit.contain,
                    width: 20,
                    height: 20,
                  ),
                ),
              )),*/
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/login_bottom_card.png'),
                        fit: BoxFit.fill)),
                height: MediaQuery.of(context).size.height * 0.6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Enter your email', labelText: 'Email'),
                          validator: validateEmail,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (text) {
                            _email = text;
                          },
                          onChanged: (text) {
                            _email = text;
                          },
                        ),
                        SizedBox(height: 5),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password'),
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
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircularCheckBox(
                                activeColor: primaryColor,
                                value: checkedValue,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                onChanged: (bool x) {
                                  setState(() {
                                    checkedValue = x;
                                  });
                                }),
                            Expanded(
                              flex: 3,
                              child: Text("Remember me",
                                  style: TextStyle(
                                      color: Color(0xff1E1E1E), fontSize: 16)),
                            ),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        ForgetPasswordScreen.routeName);
                                  },
                                  child: Text("Forgot Password?",
                                      style: TextStyle(
                                          color: Color(0xffCC0000),
                                          fontSize: 13)),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
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
                                _formKey.currentState.save();
                                apiCallForLogin();
                              }
                            },
                            color: Color(0xff3D73FF),
                            textColor: Colors.white,
                            child:
                                Text("Login", style: TextStyle(fontSize: 17)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, SignupScreen.routeName);
                              },
                              child: Text("Don't have account? Sign up",
                                  style: TextStyle(
                                      color: Color(0xffCC0000), fontSize: 13)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!_isGoogleLoggedIn)
                                  _handleGoogleSignIn();
                                else
                                  _handleGoogleSignOut();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 3.0, color: Color(0xffE5E5E5)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0) //         <--- border radius here
                                      ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 10, 18, 10),
                                  child: Image.asset(
                                    'assets/images/google_icon.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                if (_isFacebookLoggedIn)
                                  _facebookLogOut();
                                else
                                  _facebookLogIn();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 3.0, color: Color(0xffE5E5E5)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          5.0) //         <--- border radius here
                                      ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 10, 18, 10),
                                  child: Image.asset(
                                    'assets/images/fb_icon.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
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

  Future<void> apiCallForLogin() async {
    if (Platform.isIOS) {
      _deviceType = "ios";
    } else if (Platform.isAndroid) {
      _deviceType = "android";
    }

    Dialogs.showLoadingDialog(context);

    /*_email = "test1@abc.com";
    _password = "123456";
    _deviceType = "android";
    _deviceToken = "123";*/
    // _deviceToken = "123";
    // Prefs.getFCMToken((pushtoken) {
    //   if (pushtoken == null) {
    //     _deviceToken = "123";
    //   } else {
    //     _deviceToken = pushtoken;
    //   }
    // });
    _deviceToken = await Prefs.getFCMTokenAwait();
    if (_deviceToken == null) {
      _deviceToken = "123";
    } else {
      _deviceToken = _deviceToken;
    }
    print("device token");

    login(
        email: _email,
        password: _password,
        deviceType: _deviceType,
        deviceToken: _deviceToken,
        onSuccess: (BaseModel baseModel) {
          if (baseModel.data != null) {
            try {
              UserAuthModel userAuthModel =
                  UserAuthModel.fromJson(baseModel.data);

              user = userAuthModel.user;
              print("user is $user");
              print("useraccess_token is ${user.access_token}");
              print("user payment status is ${user.payment_status.amount}");

              Prefs.setAccessToken(user.access_token);
              if (user.payment_status != null) {
                Prefs.setUser(user);
              }

              apiCallForAd(user.access_token);
            } catch (e) {
              print("parsing error");
              print(e);
            }

            // print("user image  is ${user.details}");

          }
        },
        onError: (String error, BaseModel baseModel) {
          print("login error is $error");
          print("login baseModel is $baseModel");
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
            if (user.payment_status != null) {
              Prefs.savePackageId(user.payment_status.package.id.toString());
            }
            Dialogs.hideDialog(context);

            if ((user == null)) {
              toast(
                  'You need to buy package first to access application features.');
              Prefs.clearPackageId();
              Navigator.pushNamed(context, PackagesScreen.routeName);
            } else if ((user.payment_status == null)) {
              toast(
                  'You need to buy package first to access application features.');
              Prefs.clearPackageId();
              Navigator.pushNamed(context, PackagesScreen.routeName);
            } else {
              if (!user.payment_status.package.status) {
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
          }
        },
        onError: (String error, BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(error);
        });
  }

  Future<void> apiCallForFbGoogleSignIn(
      String socialID,
      String userName,
      String email,
      String platform,
      String imageUrl,
      String clientId,
      String socialToken,
      String expiresAt) async {
    paramSocialId = socialID;
    paramSocialName = userName;
    paramSocialEmail = email;
    paramSocialPlatform = platform;
    Dialogs.showLoadingDialog(context);

    if (Platform.isIOS) {
      _deviceType = "ios";
    } else if (Platform.isAndroid) {
      _deviceType = "android";
    }
    // Prefs.getFCMToken((pushtoken) {
    //   if (pushtoken == null) {
    //     _deviceToken = "123";
    //   } else {
    //     _deviceToken = pushtoken;
    //   }
    // });
    _deviceToken = await Prefs.getFCMTokenAwait();
    if (_deviceToken == null) {
      _deviceToken = "123";
    } else {
      _deviceToken = _deviceToken;
    }
    dynamic pngFile = await urlToPngFile(imageUrl);

    uploadFile(
      platform,
      clientId,
      socialToken,
      userName,
      email,
      pngFile,
      _deviceToken,
      _deviceType,
      expiresAt,
    );

    // uploadFile( platform: platform,
    // client_id:clientId,
    // token:socialToken,
    // client_id: clientId,
    // token: socialToken,
    // username: userName,
    // email: email,
    // image: pngFile,
    // device_token: "12345",
    // device_type: _deviceType,
    // expires_at: expiresAt
    // );
    //     onSuccess: (BaseModel baseModel
    // pngFile.toString()
    // Image.file(pngFile).
    // Dialogs.showLoadingDialog(context);

// socialLogin(
    //     platform: platform,
    //     client_id: clientId,
    //     token: socialToken,
    //     username: userName,
    //     email: email,
    //     image: img,
    //     device_token: "12345",
    //     device_type: _deviceType,
    //     expires_at: expiresAt,
    //     onSuccess: (BaseModel baseModel)

    // socialLogin(
    //     platform: platform,
    //     client_id: clientId,
    //     token: socialToken,
    //     username: userName,
    //     email: email,
    //     image: img,
    //     device_token: "12345",
    //     device_type: _deviceType,
    //     expires_at: expiresAt,
    //     onSuccess: (BaseModel baseModel) {
    //       Dialogs.hideDialog(context);

    //       if (baseModel.data != null) {
    //         print("sucesss");
    //         toast(baseModel.message);
    //       }
    //     },
    //     onError: (String error, BaseModel baseModel) {
    //       print("errprrrrrrr");
    //       Dialogs.hideDialog(context);
    //       toast(error);
    //     });
  }

  uploadFile(
      String platform,
      String client_id,
      String token,
      String username,
      String email,
      File image,
      String device_token,
      String device_type,
      String expires_at) async {
    // request.files.add(new http.MultipartFile.fromBytes('file',  image, contentType: new MediaType('image', 'jpeg')))
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "platform": platform,
      "client_id": client_id,
      "token": token,
      "username": username,
      "email": email,
      "image": await MultipartFile.fromFile(image.path,
          filename: fileName), //important),
      "device_token": device_token,
      "device_type": device_type,
      "expires_at": expires_at,
    });
    try {
      dynamic response = await Dio().post(
          "https://kanztainer.com/aspen-weather/api/v1/social_login",
          data: formData);
      Dialogs.hideDialog(context);
      //
      // request.send().then((response) {
      print(" response:, ${response}");
      int statusCode = response.statusCode;
      dynamic responsebody = response.data;
      print(" responsebody:, ${responsebody}");
      final baseModel = BaseModel.fromJson(responsebody);

      // String jsonBody = json.decode(response);

      if (response.statusCode == 200) {
        print("sucesss");
        if (baseModel.data != null) {
          toast(baseModel.message);
          UserAuthModel userAuthModel = UserAuthModel.fromJson(baseModel.data);

          user = userAuthModel.user;
          Prefs.setAccessToken(user.access_token);
          if (user.payment_status != null) {
            Prefs.setUser(user);
          }
          apiCallForAd(user.access_token);
        }
      } else {
        print("error response:, ${response}");
        toast(baseModel.message);
        // throw Exception(response);
      }
    } catch (error) {
      print("error is $error");
    }
  }

  Future<Null> _facebookLogIn() async {
    final FacebookLoginResult result =
        await facebookLogin.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _showMessage('''
         Facebook Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         ''');

        final token = accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=$token');
        final profile = JSON.jsonDecode(graphResponse.body);
        var now = new DateTime.now();
        now = now.add(new Duration(days: 7));
        String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(now);
        setState(() {
          userFacebookProfile = profile;
          _isFacebookLoggedIn = true;

          _showMessage(accessToken.userId);
          _showMessage(userFacebookProfile["name"]);
          _showMessage(userFacebookProfile["first_name"]);
          _showMessage(userFacebookProfile["last_name"]);
          _showMessage(userFacebookProfile["email"]);
          _showMessage(userFacebookProfile["picture"]["data"]["url"]);

          if (accessToken.token != null) {
            apiCallForFbGoogleSignIn(
                accessToken.userId,
                userFacebookProfile["name"],
                userFacebookProfile["email"],
                'facebook',
                userFacebookProfile["picture"]["data"]["url"],
                accessToken.userId,
                accessToken.userId,
                date);
          }
        });

        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isFacebookLoggedIn = false);
        _showMessage('Login cancelled by the user.');
        break;

      case FacebookLoginStatus.error:
        setState(() => _isFacebookLoggedIn = false);

        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');

        break;
    }
  }

  Future<Null> _facebookLogOut() async {
    await facebookLogin.logOut();
    setState(() {
      _isFacebookLoggedIn = false;
    });

    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      print(message);
    });
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', "https://www.googleapis.com/auth/userinfo.profile"]);

  Map<String, dynamic> parseJwt(String token) {
    // validate token
    if (token == null) return null;
    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    // retrieve token payload
    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    // convert to Map
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      // dynamic  email =  googleSignInAccount.currentUser.email,
      // dynamic name = googleSignInAccount.currentUser.displayName,
      // dynamic profilePicURL = googleSignInAccount.currentUser.photoUrl,
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final idToken = googleSignInAuthentication.idToken;
      parseJwt(idToken);
      Map<String, dynamic> idMap = parseJwt(idToken);
      print("ismapt $idMap ");
      final String name = idMap["name"];
      final String email = idMap["email"];
      final String picture = idMap["picture"];
      var now = new DateTime.now();
      now = now.add(new Duration(days: 7));
      String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(now);

      setState(() {
        _isGoogleLoggedIn = true;
        if (googleSignInAuthentication.accessToken != null) {
          apiCallForFbGoogleSignIn(
              googleSignInAuthentication.accessToken,
              name,
              email,
              'google',
              picture,
              googleSignInAuthentication.accessToken,
              googleSignInAuthentication.accessToken,
              date);
        }
      });
    } catch (error) {
      setState(() {
        _isGoogleLoggedIn = false;
      });
      print(error);
    }
  }

  Future<void> _handleGoogleSignOut() => _googleSignIn.disconnect();
}
