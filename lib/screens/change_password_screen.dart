import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/Notification_Screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/Dialogs.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change-password-screen';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String bannerImageUrl = '';
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _password, _newPassword, _confirmPassword;
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool passwordNotVisible = true;

  String accessToken = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    Prefs.getAdsUrl((String adUrl) async {
      setState(() {
        bannerImageUrl = adUrl;
      });
    });

    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      this.accessToken = accessToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
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
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
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
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text("Change Password",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff042C5C),
                          fontSize: 20)),
                  // Image.asset(
                  //   'assets/images/three_forecast_head.png',
                  //   width: 130,
                  //   height: 50,
                  // ),
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
                      width: 0,
                      height: 0,
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
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter your current password',
                                labelText: 'Current Password'),
                            validator: validatePassword,
                            autofocus: false,
                            obscureText: passwordNotVisible,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocus);
                            },
                            onSaved: (text) {
                              _password = text;
                            },
                            onChanged: (text) {
                              _password = text;
                            },
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter your new password',
                                labelText: 'New password'),
                            validator: validatePassword,
                            autofocus: false,
                            obscureText: passwordNotVisible,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordFocus);
                            },
                            onSaved: (text) {
                              _newPassword = text;
                            },
                            onChanged: (text) {
                              _newPassword = text;
                            },
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Confirm your new password'),
                            validator: validateConfirmPassword,
                            obscureText: passwordNotVisible,
                            autofocus: false,
                            focusNode: _confirmPasswordFocus,
                            textInputAction: TextInputAction.done,
                            onSaved: (text) {
                              _confirmPassword = text;
                            },
                            onChanged: (text) {
                              _confirmPassword = text;
                            },
                          ),
                          SizedBox(
                            height: 40,
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
                                  apiCallForChangePassword();
                                }
                              },
                              color: Color(0xff3D73FF),
                              textColor: Colors.white,
                              child: Text("Change Password",
                                  style: TextStyle(fontSize: 17)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.network(bannerImageUrl,
                height: 100, width: MediaQuery.of(context).size.width),
          ),
        ],
      ),
    )));
  }

  Future<void> apiCallForChangePassword() async {
    Dialogs.showLoadingDialog(context);

    changePassword(
        token: accessToken,
        current_password: _password,
        password: _newPassword,
        password_confirmation: _confirmPassword,
        onSuccess: (BaseModel baseModel) {
          if (baseModel.data != null) {
            toast(baseModel.message);

            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        onError: (String error, BaseModel baseModel) {
          print("passowrd change errror $baseModel");
          Dialogs.hideDialog(context);
          toast(error);
        });
  }
}
