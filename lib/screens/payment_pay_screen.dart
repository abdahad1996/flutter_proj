import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/summer_home_screen.dart';
import 'package:aspen_weather/screens/winter_home_screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/Dialogs.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PayNowScreen extends StatefulWidget {
  static const routeName = '/pay-now-screen';
  final String packageId;

  PayNowScreen(this.packageId);

  @override
  _PayNowScreenState createState() => _PayNowScreenState();
}

class _PayNowScreenState extends State<PayNowScreen> {
  String weatherType;
  String accessToken;
  bool loading = false;
  String cardName, cardNumber, cardExpiry, cardCVC;
  final FocusNode cardNumberFocus = FocusNode();
  final FocusNode cardExpiryFocus = FocusNode();
  final FocusNode cardCVCFocus = FocusNode();
  String bannerImageUrl = '';

  @override
  void initState() {
    super.initState();

    Prefs.getAdsUrl((String adUrl) async {
      setState(() {
        bannerImageUrl = adUrl;
      });
    });

    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      this.accessToken = accessToken;
    });

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
        resizeToAvoidBottomPadding: false,
        bottomNavigationBar: Container(
          child: Image.network(
            bannerImageUrl,
            height: 80,
            width: double.infinity,
          ),
        ),
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
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
                        'assets/images/pay_now_head.png',
                        width: 80,
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
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Payment Method',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff222222),
                            fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/logo_master.png',
                          width: 60,
                          height: 50,
                        ),
                        Image.asset(
                          'assets/images/logo_visa.png',
                          width: 60,
                          height: 50,
                        ),
                        Image.asset(
                          'assets/images/logo_paypal.png',
                          width: 60,
                          height: 50,
                        ),
                        Image.asset(
                          'assets/images/logo_amex.png',
                          width: 60,
                          height: 50,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Robert Anitie',
                              labelText: 'Card holder'),
                          validator: validateField,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(cardNumberFocus);
                          },
                          keyboardType: TextInputType.text,
                          onSaved: (text) {
                            cardName = text;
                          },
                          onChanged: (text) {
                            cardName = text;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            new LengthLimitingTextInputFormatter(16),
                            new CardNumberInputFormatter()
                          ],
                          focusNode: cardNumberFocus,
                          decoration: InputDecoration(
                              labelText: 'Card Number',
                              hintText: '4513 1246 45564 3255'),
                          // validator: validateField,
                          validator: validateCardNum,

                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context)
                                .requestFocus(cardExpiryFocus);
                          },
                          // keyboardType: TextInputType.text,
                          onSaved: (text) {
                            print('onSaved = $text');
                            // print('Num controller has = ${numberController.text}');
                            cardNumber = getCleanedNumber(text);
                            // cardNumber = text;
                          },
                          onChanged: (text) {
                            cardNumber = text;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Container(
                                  child: TextFormField(
                                    focusNode: cardExpiryFocus,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      new LengthLimitingTextInputFormatter(4),
                                      new CardMonthInputFormatter()
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Expiry Date',
                                      hintText: 'MM/YY',
                                    ),
                                    validator: validateDate,
                                    autofocus: false,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(cardCVCFocus);
                                    },
                                    keyboardType: TextInputType.number,
                                    onSaved: (text) {
                                      List<int> expiryDate =
                                          getExpiryDate(text);

                                      cardExpiry = '${expiryDate[0]}' +
                                          '-' +
                                          '${expiryDate[1]}';
                                    },
                                    onChanged: (text) {
                                      List<int> expiryDate =
                                          getExpiryDate(text);
                                      cardExpiry = '20' + '${expiryDate[0]}' +
                                          '/' +
                                          '${expiryDate[1]}';
                                    },
                                  ),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  child: TextFormField(
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      new LengthLimitingTextInputFormatter(4),
                                    ],
                                    decoration: InputDecoration(
                                        labelText: 'CVC', hintText: '****'),
                                    validator: validateField,
                                    autofocus: false,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.datetime,
                                    onSaved: (text) {
                                      cardCVC = text;
                                    },
                                    onChanged: (text) {
                                      cardCVC = text;
                                    },
                                  ),
                                )),
                          ],
                        ),
                        /* SizedBox(height: 15),
                        Row(
                        children: [
                        Switch(
                          value: false,
                          onChanged: null,
                        ),
                        Expanded(child: Text('Set as default'))
                        ],
                      ),*/
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        apiCallForCharge(widget.packageId, cardName, cardNumber,
                            cardExpiry, cardCVC);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/blue_button_bg.png'),
                        )),
                        child: Center(
                          child: Text('Pay Now',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 20)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  Future<void> apiCallForCharge(String packageId, String cardName,
      String cardNumber, String cardExpiry, String cvcNumber) async {
    Dialogs.showLoadingDialog(context);

    cardName = 'John well';
    cardNumber = '4111111111111111';
    cardExpiry = '2023-03';
    cvcNumber = '737';

    chargePayment(
        accessToken: accessToken,
        packageId: packageId,
        cardName: cardName,
        cardNumber: cardNumber,
        expiryDate: cardExpiry,
        cvcNumber: cvcNumber,
        onSuccess: (BaseModel baseModel) {
          print("basemodel $baseModel");
          //Dialogs.hideDialog(context);

          ///SAVE PACKAGE ID HERE

          if (baseModel.message == "Transaction failed") {
             toast(baseModel.message);
            Dialogs.hideDialog(context);

            return;
          }

          /// clear existing pacakge id
          Prefs.clearPackageId();
          Prefs.savePackageId(packageId.toString());

          if (baseModel.data != null) {
            apiCallForProfile(baseModel.message);

            /*if (weatherType == Const.WEATHER_TYPE_SUMMER) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  SummerHomeScreen.routeName, (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  WinterHomeScreen.routeName, (Route<dynamic> route) => false);
            }*/

          }
        },
        onError: (String error, BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(error);
        });
  }

  Future<void> apiCallForProfile(String message) async {
    Dialogs.showLoadingDialog(context);
    getUser(
        authToken: accessToken,
        onSuccess: (BaseModel baseModel) {
          Dialogs.hideDialog(context);

          if (baseModel.data != null) {
            try {
              User user = User.fromJson(baseModel.data);
              Prefs.setUser(user);
            } catch (e) {
              toast(e);
            }

            toast(message);

            if (weatherType == Const.WEATHER_TYPE_SUMMER) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  SummerHomeScreen.routeName, (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  WinterHomeScreen.routeName, (Route<dynamic> route) => false);
            }
          }
        },
        onError: (String error, BaseModel baseModel) {
          Dialogs.hideDialog(context);
          toast(error);
        });
  }
}
