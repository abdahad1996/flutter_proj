import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/login_screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/Dialogs.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = '/reset-password-screen';
  final String email;
  final String verifyCode;

  const ResetPasswordScreen(this.email, this.verifyCode);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String bannerImageUrl = '';
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _newPassword, _confirmPassword;
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
    Prefs.getaddModel((AdsModel ad) async {
      setState(() {
        bannerImageUrl = ad.attachment_url;
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                  side: BorderSide(color: Color(0xff3D73FF))),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  apiCallForResetPassword();
                }
              },
              color: Color(0xff3D73FF),
              textColor: Colors.white,
              child: Text("Reset Password", style: TextStyle(fontSize: 17)),
            ),
          ),
        ),
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          color: Color(0xffF8F9FF),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
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
                    child: Text('Reset Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        )),
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
                          width: 25,
                          height: 20,
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
                              SizedBox(height: 30),
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
                              SizedBox(height: 20),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }

  Future<void> apiCallForResetPassword() async {
    Dialogs.showLoadingDialog(context);

    resetPassword(
        email: widget.email,
        verificationCode: widget.verifyCode,
        password: _newPassword,
        confirmPassword: _confirmPassword,
        onSuccess: (BaseModel baseModel) {
          if (baseModel.data != null) {
            //toast(baseModel.message);
            toast('Password reset successfully');
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }
        },
        onError: (String error, BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(error);
        });
  }
}
