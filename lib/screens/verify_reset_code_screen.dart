import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/reset_password_screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/Dialogs.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyResetCodeScreen extends StatefulWidget {
  static const routeName = '/verify-reset-code-screen';
  final String email;

  const VerifyResetCodeScreen(this.email);

  @override
  _VerifyResetCodeScreenState createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends State<VerifyResetCodeScreen> {
  String weatherType;
  User user;
  String _code;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });
  }

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                  apiCallForVerifyResetCode();
                },
                color: Color(0xff3D73FF),
                textColor: Colors.white,
                child: Text("Verify Code", style: TextStyle(fontSize: 17)),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text('Verify Code',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              )),
                        ),
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
                              'assets/images/ic_info.png',
                              width: 25,
                              height: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("PIN Code",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              )),
                          SizedBox(height: 30.0),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: PinCodeTextField(
                              length: 4,
                              obsecureText: false,
                              animationType: AnimationType.fade,
                              shape: PinCodeFieldShape.box,
                              activeColor: Color(0xff3D73FF),
                              activeFillColor: Color(0xff3D73FF),
                              selectedColor: Color(0xff3D73FF),
                              inactiveColor: Color(0xff3D73FF),
                              animationDuration: Duration(milliseconds: 300),
                              borderRadius: BorderRadius.circular(5),
                              textInputType: TextInputType.number,
                              borderWidth: 1.5,
                              fieldHeight: 50,
                              fieldWidth: 50,
                              onChanged: (value) {
                                setState(() {
                                  _code = value;
                                });
                              },
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 25.0),
                              InkWell(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Forgot PIN Code?',
                                      style: TextStyle(
                                        color: Color(0xff3D73FF),
                                        fontSize: 15,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  apiCallForForgetPassword();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> apiCallForVerifyResetCode() async {
    Dialogs.showLoadingDialog(context);

    verifyResetCode(
        verificationCode: _code,
        onSuccess: (BaseModel baseModel) {
          Dialogs.hideDialog(context);
          //toast(baseModel.message);

          Navigator.pushNamed(context, ResetPasswordScreen.routeName,
              arguments: {
            'email': widget.email,
            'code': _code
          });

        },
        onError: (String error, BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(error);
        });
  }

  Future<void> apiCallForForgetPassword() async {
    Dialogs.showLoadingDialog(context);

    forgetPassword(
        email: widget.email,
        onSuccess: (BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(baseModel.message);
          Navigator.pushNamed(context, VerifyResetCodeScreen.routeName,
              arguments: {'email': widget.email});
        },
        onError: (String error, BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(error);
        });
  }
}
