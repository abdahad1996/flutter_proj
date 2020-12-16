class DailyIndicatorModel {
  String low = '';
  String medium = '';
  String high = '';
  String selected = '';
  String day_name = '';

  DailyIndicatorModel(
      {this.low, this.medium, this.high, this.selected, this.day_name});

  DailyIndicatorModel.fromJson(Map<String, dynamic> json) {
    low = json['low'];
    medium = json['medium'];
    high = json['high'];
    selected = json['selected'];
    day_name = json['day_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['low'] = this.low;
    data['medium'] = this.medium;
    data['high'] = this.high;
    data['selected'] = this.selected;
    data['day_name'] = this.day_name;
    return data;
  }
}
