class SnowForecastRange {
  String buttermilk;
  String highlands;
  String snowmass;
  String ajax;

  SnowForecastRange(
      {this.buttermilk, this.highlands, this.snowmass, this.ajax});

  SnowForecastRange.fromJson(Map<String, dynamic> json) {
    buttermilk = json['Buttermilk'];
    highlands = json['Highlands'];
    snowmass = json['Snowmass'];
    ajax = json['Ajax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['Buttermilk'] = this.buttermilk;
    data['Highlands'] = this.highlands;
    data['Snowmass'] = this.snowmass;
    data['Ajax'] = this.ajax;

    return data;
  }

}
