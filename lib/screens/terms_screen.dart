import 'package:aspen_weather/models/content_model.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatefulWidget {
  static const routeName = '/terms-screen';

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  String weatherType;
  String title = '';
  String content = '';
  String bannerImageUrl = '';

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

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    Prefs.getAccessToken((String accessToken) async {
      BaseModel baseModel =
          await getContentPages(authToken: accessToken, pageId: '1')
              .catchError((error) {
        print(error);
      });

      setState(() {
        title = "";
        content = "";

        if (baseModel != null && baseModel.data != null) {
          ContentModel dataModel = ContentModel.fromJson(baseModel.data);
          title = dataModel.title;
          content = dataModel.content;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xffFAFAFF),
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
                  child: Text("Terms & Conditions",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff222222),
                          fontSize: 16)),
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
            height: 30,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.topLeft,
                child: Column(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff222222),
                            fontSize: 16)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(content,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff222222),
                          fontSize: 14))
                ]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.network(
              bannerImageUrl,
              height: 80,
              width: double.infinity,
            ),
          ),
        ],
      ),
    )));
  }
}
