class ThreeDaysForeCastModel {
  String date_formatted;
  String exerpt;
  String description;
  String icon_url;
  int temprature_c;
  int temprature_f;

  ThreeDaysForeCastModel(this.date_formatted, this.exerpt, this.description,
      this.icon_url, this.temprature_c, this.temprature_f);

  ThreeDaysForeCastModel.fromJson(Map<String, dynamic> json) {
    date_formatted = json['description'];
    exerpt = json['exerpt'];
    description = json['description'];
    icon_url = json['icon_url'];
    temprature_c = json['temprature_c'];
    temprature_f = json['temprature_f'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_formatted'] = this.date_formatted;
    data['exerpt'] = this.exerpt;
    data['icon_url'] = this.icon_url;
    data['description'] = this.description;
    data['temprature_c'] = this.temprature_c;
    data['temprature_f'] = this.temprature_f;
    return data;
  }
}
