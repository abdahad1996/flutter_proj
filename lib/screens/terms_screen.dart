import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/content_model.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatefulWidget {
  static const routeName = '/terms-screen';

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _controller = PageController(
    initialPage: 0,
  );
  List<AdsModel> addsList = List();
  String weatherType;
  String title = '';
  String content = '';
  String bannerImageUrl = '';
  bool isLoading = false;
  double height;
  AdsModel ad;
  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    isLoading = true;
    // Prefs.getaddModel((AdsModel ad) async {
    //   setState(() {
    //     bannerImageUrl = ad.attachment_url;
    //     ad = ad;
    //   });
    // });

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    Prefs.getAccessToken((String accessToken) async {
      apiCallForAd(accessToken);
      BaseModel baseModel =
          await getContentPages(authToken: accessToken, pageId: '1')
              .catchError((error) {
        print(error);
        setState(() {
          isLoading = false;
        });
      });

      setState(() {
        isLoading = false;

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
            Prefs.setListData(Const.addsFromPref, list);
            print("ads data is $list");
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
                  child: Text("Terms & Conditions",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff042C5C),
                          fontSize: 20)),
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
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.topLeft,
                      child: Column(children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(title.isEmpty ? "No record found" : title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff222222),
                                  fontSize: 16)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(content.isEmpty ? "No record found" : content,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Color(0xff222222),
                                fontSize: 14))
                      ]),
                    ),
                  ),
          ),
          isLoading
              ? Container()
              // : InkWell(
              //     onTap: () {
              //       launchURL(ad?.url ?? "");
              //     },
              //     child: Align(
              //       alignment: Alignment.bottomCenter,
              //       child: Image.network(
              //         bannerImageUrl,
              //         height: 80,
              //         width: double.infinity,
              //       ),
              //     ),
              //   ),
              : addsList.isEmpty
                  ? Container()
                  : Container(
                      height: 75,
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
    )));
  }
}
