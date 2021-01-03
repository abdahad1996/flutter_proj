import 'package:aspen_weather/models/storm_list_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/bar_chart_graph.dart';
import 'package:aspen_weather/utils/bar_chart_model.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SummerRainTabScreen extends StatefulWidget {
  static const routeName = '/summer-tab-rain-screen';

  @override
  _SummerRainTabScreenState createState() => _SummerRainTabScreenState();
}

class _SummerRainTabScreenState extends State<SummerRainTabScreen> {
  String weatherType;
  User user;
  List<StormListModel> stormList = List();
  final List<BarChartModel> dataGraph = List();

  @override
  void initState() {
    super.initState();

    Prefs.getWeatherType((String weather) {
      if (this.mounted) {
        setState(() {
          weatherType = weather;
        });
      }
    });

    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      BaseModel baseModel =
          await getStormForecast(authToken: accessToken).catchError((error) {
        print(error);
      });
      if (this.mounted) {
        setState(() {
          stormList.clear();

          if (baseModel != null && baseModel.data != null) {
            List list = baseModel.data as List;

            if (list.length == 0) {
              toast('No records found');
            } else {
              for (var value in list) {
                StormListModel model = StormListModel.fromJson(value);
                model.color = charts.ColorUtil.fromDartColor(Color(0xFF47505F));

                String pointValue = model.value;
                double doublePoint = double.parse(pointValue);
                int intPoint = doublePoint.toInt();

                dataGraph.add(BarChartModel(
                    year: model.key.replaceAll("-", "\n-\n"),
                    financial: intPoint,
                    color: charts.ColorUtil.fromDartColor(Color(0xFF628EFF))));

                stormList.add(model);
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:stormList.length == 0
                ? Center(child: Text("No Records Found"))
                : Container(
          child: ListView(
            padding: EdgeInsets.only(left: 5),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Center(
                child: Text("Cory\'s Thunderstorm predictions for today",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff222222),
                        fontSize: 18)),
              ),
              SizedBox(
                height: 50,
              ),
              BarChartGraph(
                data: dataGraph,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
