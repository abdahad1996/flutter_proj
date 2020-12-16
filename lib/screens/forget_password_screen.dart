import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/verify_reset_code_screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/Dialogs.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/forget-password-screen';

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  String weatherType;
  User user;
  String _email;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 350,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Enter your email', labelText: 'Email'),
                          validator: validateEmail,
                          autofocus: false,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (v) {},
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (text) {
                            _email = text;
                          },
                          onChanged: (text) {
                            _email = text;
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
                                _formKey.currentState.save();
                                apiCallForForgetPassword();
                              }
                            },
                            color: Color(0xff3D73FF),
                            textColor: Colors.white,
                            child: Text("Forget Password",
                                style: TextStyle(fontSize: 17)),
                          ),
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

  Future<void> apiCallForForgetPassword() async {
    Dialogs.showLoadingDialog(context);

    forgetPassword(
        email: _email,
        onSuccess: (BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(baseModel.message);
          Navigator.pushNamed(context, VerifyResetCodeScreen.routeName,
              arguments: {'email': _email});
        },
        onError: (String error, BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(error);
        });
  }
}
