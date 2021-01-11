import 'package:aspen_weather/models/packages_list_model.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/payment_pay_screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class PackagesScreen extends StatefulWidget {
  static const routeName = '/packages-screen';

  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  String weatherType;
  List<PackagesListModel> packagesList = List();
  bool loading = false;
  String bannerImageUrl = '';
  String existingPackageId = '';
  @override
  void initState() {
    super.initState();
    print("notchh");
    print(Device.get().hasNotch);
    print("iphone");
    print(Device.get().isIphoneX);
    load();
  }

  void load() async {
    Prefs.getAdsUrl((String adUrl) async {
      setState(() {
        bannerImageUrl = adUrl;
      });
    });

    Prefs.getPackageId((String packageId) async {
      existingPackageId = packageId;
      print('existingPackageId ${existingPackageId}');
    });
    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);

      //check if current pacakge id Exist then show selected pacakge
      loading = true;

      BaseModel baseModel =
          await getPackagesScreen(authToken: accessToken).catchError((error) {
        loading = false;
        print(error);
      });

      setState(() {
        loading = false;

        packagesList.clear();
        if (baseModel != null && baseModel.data != null) {
          List list = baseModel.data as List;
          if (list.length == 0) {
            toast('No records found');
          } else {
            for (var value in list) {
              PackagesListModel model = PackagesListModel.fromJson(value);
              packagesList.add(model);
            }
          }
        }
      });
    });

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
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
                  child: Image.asset(
                    'assets/images/packages_head.png',
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
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: double.infinity,
                child: Column(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Choose the plan that’s right for you.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1E1E1E),
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. See Terms of Use for more details.',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff77869E),
                          fontSize: 13),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: loading
                        ? Center(child: CupertinoActivityIndicator())
                        : (packagesList.length == 0)
                            ? Center(child: Text("No Record Found"))
                            : Container(
                                height: 400,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: packagesList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        width: 350,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 15, 0),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 28.0),
                                                        child: Text(
                                                            packagesList[index]
                                                                .name,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xff31343D),
                                                                fontSize: 20)),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 28.0),
                                                        child: Text(
                                                            "\$ ${packagesList[index].amount.toString()}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xff31343D),
                                                                fontSize: 23)),
                                                      ),
                                                      SizedBox(
                                                        height: Device.get()
                                                                .isIphoneX
                                                            ? 25
                                                            : 10,
                                                      ),
                                                      Text(
                                                          packagesList[index]
                                                              .description,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color(
                                                                  0xff77869E),
                                                              fontSize: 17)),
                                                      SizedBox(
                                                        height: Device.get()
                                                                .isIphoneX
                                                            ? 25
                                                            : 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment: FractionalOffset
                                                      .bottomCenter,
                                                  child:
                                                      (existingPackageId ==
                                                              packagesList[
                                                                      index]
                                                                  .id
                                                                  .toString())
                                                          ? Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10.0),
                                                              child: Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      // Navigator.pushNamed(context,
                                                                      //     PayNowScreen.routeName,
                                                                      //     arguments: {
                                                                      //       'packageId':
                                                                      //           packagesList[index]
                                                                      //               .id
                                                                      //               .toString()
                                                                      //     });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height: Device.get()
                                                                              .isIphoneX
                                                                          ? 60
                                                                          : 40,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              color: Colors.green),
                                                                      child: Center(
                                                                          child: (Text(
                                                                              'Subscribed',
                                                                              style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 20)))),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  /*Text('More details',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.normal,
                                                                color: Color(
                                                                    0xffFF0000),
                                                                fontSize: 17))*/
                                                                ],
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10.0),
                                                              child: Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          PayNowScreen.routeName,
                                                                          arguments: {
                                                                            'packageId':
                                                                                packagesList[index].id.toString()
                                                                          });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height: Device.get()
                                                                              .isIphoneX
                                                                          ? 60
                                                                          : 40,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              image: DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image: AssetImage(
                                                                            'assets/images/blue_button_bg.png'),
                                                                      )),
                                                                      child: Center(
                                                                          child: (Text(
                                                                              'Buy Now',
                                                                              style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 20)))),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  /*Text('More details',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.normal,
                                                                color: Color(
                                                                    0xffFF0000),
                                                                fontSize: 17))*/
                                                                ],
                                                              ),
                                                            ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                  )
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
