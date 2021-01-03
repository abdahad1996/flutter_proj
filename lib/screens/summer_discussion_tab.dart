import 'package:aspen_weather/models/content_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummerDiscussTabScreen extends StatefulWidget {
  static const routeName = '/summer-tab-discuss-screen';

  @override
  _SummerDiscussTabScreenState createState() => _SummerDiscussTabScreenState();
}

class _SummerDiscussTabScreenState extends State<SummerDiscussTabScreen> {
  String weatherType;
  bool checkedValue = false;
  User user;
  DateTime selectedDate = DateTime.now();
  var isDatePicked = false;
  String title = '';
  String content = '';
  String contentFull = '';
  String dateStr = "";
  List<ContentModel> packagesList = List();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    loadByDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                weatherType == Const.WEATHER_TYPE_SUMMER
                    ? SizedBox(
                        height: 20,
                      )
                    : SizedBox(
                        height: 90,
                      ),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Image.asset(
                    "assets/images/archive_calendar.png",
                    width: 140,
                    height: 40,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                /*Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1E1E1E),
                        fontSize: 22)),
                SizedBox(
                  height: 8,
                ),*/
                Text(contentFull,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Color(0xff55586D),
                        fontSize: 15)),
              ]),
        ),
      ),
    )));
  }

  _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);

      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2021),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
        print(dateStr);
        loadByDate();
      });
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    isDatePicked = true;
                    selectedDate = picked;
                    dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
                    print(dateStr);
                    loadByDate();
                  });
              },
              initialDateTime: isDatePicked ? selectedDate : DateTime.now(),
              minimumYear: 2000,
              maximumYear: 2021,
            ),
          );
        });
  }

  void loadByDate() {
    Prefs.getAccessToken((String accessToken) async {
      BaseModel baseModel =
          await getDiscussions(authToken: accessToken, currentDate: dateStr)
              .catchError((error) {
        print(error);
      });

      setState(() {
        title = "";
        content = "";
        contentFull = "";

        packagesList.clear();

        if (baseModel != null && baseModel.data != null) {
          List list = baseModel.data as List;

          if (list.length == 0) {
            toast('No records found');
          } else {
            for (var value in list) {
              ContentModel model = ContentModel.fromJson(value);
              packagesList.add(model);
            }
            if (packagesList.isNotEmpty) {
              for (var model in packagesList) {
                contentFull += model.title + "\n" + model.content + "\n\n";
              }

              title = packagesList[0].title;
              content = packagesList[0].content;
            } else {
              title = "";
              content = "";
              contentFull = "";
            }
          }
        }
      });
    });
  }
}
