class TodayWeatherModel {
  String dateTime = '';
  int epochDateTime;
  int weatherIcon = 1;
  String iconPhrase;
  bool hasPrecipitation;
  TodayTemperature temperature;
  RealFeelTemperature realFeelTemperature;

  TodayWeatherModel(
      {this.dateTime,
      this.epochDateTime,
      this.weatherIcon,
      this.iconPhrase,
      this.hasPrecipitation,
      this.temperature,
      this.realFeelTemperature});

  TodayWeatherModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['DateTime'];
    epochDateTime = json['EpochDateTime'];
    weatherIcon = json['WeatherIcon'];
    iconPhrase = json['IconPhrase'];
    hasPrecipitation = json['HasPrecipitation'];
    temperature = json['Temperature'] != null
        ? new TodayTemperature.fromJson(json['Temperature'])
        : null;
    realFeelTemperature = json['RealFeelTemperature'] != null
        ? new RealFeelTemperature.fromJson(json['RealFeelTemperature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DateTime'] = this.dateTime;
    data['EpochDateTime'] = this.epochDateTime;
    data['WeatherIcon'] = this.weatherIcon;
    data['IconPhrase'] = this.iconPhrase;
    data['HasPrecipitation'] = this.hasPrecipitation;
    if (this.temperature != null) {
      data['Temperature'] = this.temperature.toJson();
    }
    if (this.realFeelTemperature != null) {
      data['RealFeelTemperature'] = this.realFeelTemperature.toJson();
    }
    return data;
  }
}

class TodayTemperature {
  double value;
  String unit;
  int unitType;

  TodayTemperature({this.value, this.unit, this.unitType});

  TodayTemperature.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    unit = json['Unit'];
    unitType = json['UnitType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Unit'] = this.unit;
    data['UnitType'] = this.unitType;
    return data;
  }
}

class RealFeelTemperature {
  double value;
  String unit;
  int unitType;

  RealFeelTemperature({this.value, this.unit, this.unitType});

  RealFeelTemperature.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    unit = json['Unit'];
    unitType = json['UnitType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Unit'] = this.unit;
    data['UnitType'] = this.unitType;
    return data;
  }
}
