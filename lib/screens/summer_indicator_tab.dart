import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SummerIndicatorTabScreen extends StatefulWidget {
  static const routeName = '/summer-tab-indicator-screen';

  @override
  _SummerIndicatorTabScreenState createState() =>
      _SummerIndicatorTabScreenState();

}

class _SummerIndicatorTabScreenState extends State<SummerIndicatorTabScreen> {
  String weatherType;
  String adUrl = '';

  @override
  void initState() {
    super.initState();

    Prefs.getAdsUrl((String adUrl) async {
      setState(() {
        this.adUrl = adUrl;
      });
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
        body: SafeArea(
            child: Container()));
  }
}
