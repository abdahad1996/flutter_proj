class DailyWeatherModel {
  String dateTime;
  String WeatherText;
  int epochDateTime;
  int weatherIcon = 1;
  String iconPhrase;
  bool hasPrecipitation;
  bool isDaylight;
  Temperature temperature;
  RealFeelTemperature realFeelTemperature;
  int relativeHumidity;
  Wind wind;

  DailyWeatherModel(
      {this.dateTime,
        this.WeatherText,
        this.epochDateTime,
        this.weatherIcon,
        this.iconPhrase,
        this.hasPrecipitation,
        this.isDaylight,
        this.temperature,
        this.realFeelTemperature,
      this.relativeHumidity,
      this.wind});

  DailyWeatherModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['DateTime'];
    WeatherText = json['WeatherText'];
    epochDateTime = json['EpochDateTime'];
    weatherIcon = json['WeatherIcon'];
    iconPhrase = json['IconPhrase'];
    hasPrecipitation = json['HasPrecipitation'];
    isDaylight = json['IsDaylight'];
    relativeHumidity = json['RelativeHumidity'];
    temperature = json['Temperature'] != null
        ? new Temperature.fromJson(json['Temperature'])
        : null;
    realFeelTemperature = json['RealFeelTemperature'] != null
        ? new RealFeelTemperature.fromJson(json['RealFeelTemperature'])
        : null;
    wind = json['Wind'] != null
        ? new Wind.fromJson(json['Wind'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DateTime'] = this.dateTime;
    data['WeatherText'] = this.WeatherText;
    data['EpochDateTime'] = this.epochDateTime;
    data['WeatherIcon'] = this.weatherIcon;
    data['IconPhrase'] = this.iconPhrase;
    data['HasPrecipitation'] = this.hasPrecipitation;
    data['IsDaylight'] = this.isDaylight;
    data['RelativeHumidity'] = this.relativeHumidity;
    if (this.temperature != null) {
      data['Temperature'] = this.temperature.toJson();
    }
    if (this.realFeelTemperature != null) {
        data['RealFeelTemperature'] = this.realFeelTemperature.toJson();
    }

    if (this.wind != null) {
      data['Wind'] = this.wind.toJson();
    }
    return data;
  }
}

class Temperature {
  Metric metric;
  Imperial imperial;

  Temperature({this.metric, this.imperial});

  Temperature.fromJson(Map<String, dynamic> json) {
    metric = json['Metric'] != null
        ? new Metric.fromJson(json['Metric'])
        : null;

    imperial = json['Imperial'] != null
        ? new Imperial.fromJson(json['Imperial'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imperial != null) {
      data['Imperial'] = this.imperial.toJson();
    }

    if (this.metric != null) {
      data['Metric'] = this.metric.toJson();
    }

    return data;
  }
}

class RealFeelTemperature {
  Imperial imperial;

  RealFeelTemperature({this.imperial});

  RealFeelTemperature.fromJson(Map<String, dynamic> json) {
    imperial = json['Imperial'] != null
        ? new Imperial.fromJson(json['Imperial'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imperial != null) {
      data['Imperial'] = this.imperial.toJson();
    }
    return data;
  }
}

class Imperial {
  double value;
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

class Wind {
  Speed speed;

  Wind({this.speed});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['Speed'] != null
        ? new Speed.fromJson(json['Speed'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.speed != null) {
      data['Speed'] = this.speed.toJson();
    }
    return data;
  }
}

class Speed {
  Metric metric;
  Imperial imperial;

  Speed({this.metric, this.imperial});

  Speed.fromJson(Map<String, dynamic> json) {
    metric = json['Metric'] != null
        ? new Metric.fromJson(json['Metric'])
        : null;

    imperial = json['Imperial'] != null
        ? new Imperial.fromJson(json['Imperial'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imperial != null) {
      data['Imperial'] = this.imperial.toJson();
    }

    if (this.metric != null) {
      data['Metric'] = this.metric.toJson();
    }

    return data;
  }
}