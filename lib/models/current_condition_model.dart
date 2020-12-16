class CurrentConditionModel {
  String localObservationDateTime;
  int epochTime;
  String weatherText;
  int weatherIcon;
  Temperature temperature;
  Temperature realFeelTemperature;
  int relativeHumidity;
  int indoorRelativeHumidity;
  Wind wind;

  CurrentConditionModel(
      {this.localObservationDateTime,
        this.epochTime,
        this.weatherText,
        this.weatherIcon,
        this.temperature,
        this.realFeelTemperature,
        this.relativeHumidity,
        this.indoorRelativeHumidity,
        this.wind});

  CurrentConditionModel.fromJson(Map<String, dynamic> json) {
    localObservationDateTime = json['LocalObservationDateTime'];
    epochTime = json['EpochTime'];
    weatherText = json['WeatherText'];
    weatherIcon = json['WeatherIcon'];
    temperature = json['Temperature'] != null
        ? new Temperature.fromJson(json['Temperature'])
        : null;
    realFeelTemperature = json['RealFeelTemperature'] != null
        ? new Temperature.fromJson(json['RealFeelTemperature'])
        : null;
    relativeHumidity = json['RelativeHumidity'];
    indoorRelativeHumidity = json['IndoorRelativeHumidity'];
    wind = json['Wind'] != null ? new Wind.fromJson(json['Wind']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocalObservationDateTime'] = this.localObservationDateTime;
    data['EpochTime'] = this.epochTime;
    data['WeatherText'] = this.weatherText;
    data['WeatherIcon'] = this.weatherIcon;
    if (this.temperature != null) {
      data['Temperature'] = this.temperature.toJson();
    }
    if (this.realFeelTemperature != null) {
      data['RealFeelTemperature'] = this.realFeelTemperature.toJson();
    }
    data['RelativeHumidity'] = this.relativeHumidity;
    data['IndoorRelativeHumidity'] = this.indoorRelativeHumidity;
    if (this.wind != null) {
      data['Wind'] = this.wind.toJson();
    }
    return data;
  }
}

class Temperature {
  Imperial metric;
  Imperial imperial;

  Temperature({this.metric, this.imperial});

  Temperature.fromJson(Map<String, dynamic> json) {
    metric =
    json['Metric'] != null ? new Imperial.fromJson(json['Metric']) : null;
    imperial = json['Imperial'] != null
        ? new Imperial.fromJson(json['Imperial'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metric != null) {
      data['Metric'] = this.metric.toJson();
    }
    if (this.imperial != null) {
      data['Imperial'] = this.imperial.toJson();
    }
    return data;
  }
}

class Metric {
  double value;
  String unit;
  int unitType;

  Metric({this.value, this.unit, this.unitType});

  Metric.fromJson(Map<String, dynamic> json) {
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

class Imperial {
  int value;
  String unit;
  int unitType;

  Imperial({this.value, this.unit, this.unitType});

  Imperial.fromJson(Map<String, dynamic> json) {
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

class Wind {
  Direction direction;
  Temperature speed;

  Wind({this.direction, this.speed});

  Wind.fromJson(Map<String, dynamic> json) {
    direction = json['Direction'] != null
        ? new Direction.fromJson(json['Direction'])
        : null;
    speed =
    json['Speed'] != null ? new Temperature.fromJson(json['Speed']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.direction != null) {
      data['Direction'] = this.direction.toJson();
    }
    if (this.speed != null) {
      data['Speed'] = this.speed.toJson();
    }
    return data;
  }
}

class Direction {
  int degrees;
  String localized;
  String english;

  Direction({this.degrees, this.localized, this.english});

  Direction.fromJson(Map<String, dynamic> json) {
    degrees = json['Degrees'];
    localized = json['Localized'];
    english = json['English'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Degrees'] = this.degrees;
    data['Localized'] = this.localized;
    data['English'] = this.english;
    return data;
  }
}
