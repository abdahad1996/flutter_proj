import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class StormListModel {
  int id = -1;
  String value = "0";
  String key = "";
  String started_at = "";
  String ended_at = "";
  charts.Color color;

  StormListModel(this.id, this.value, this.key,
      this.started_at, this.ended_at, this.color,);

  StormListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    key = json['key'];
    started_at = json['started_at'];
    ended_at = json['ended_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['key'] = this.key;
    data['started_at'] = this.started_at;
    data['ended_at'] = this.ended_at;
    return data;
  }
}
