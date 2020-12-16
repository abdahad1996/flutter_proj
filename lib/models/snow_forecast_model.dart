class SnowForecastModel {
  Attributes attributes;

  SnowForecastModel(this.attributes);

  SnowForecastModel.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attributes != null) {
      data['attributes'] = this.attributes.toJson();
    }
    return data;
  }
}

class Attributes {
  Buttermilk buttermilk;
  Highlands highlands;
  Snowmass snowmass;
  Ajax ajax;

  Attributes({this.buttermilk, this.highlands, this.snowmass, this.ajax});

  Attributes.fromJson(Map<String, dynamic> json) {
    buttermilk = json['Buttermilk'] != null
        ? new Buttermilk.fromJson(json['Buttermilk'])
        : null;

    highlands = json['Highlands'] != null
        ? new Highlands.fromJson(json['Highlands'])
        : null;

    snowmass = json['Snowmass'] != null
        ? new Snowmass.fromJson(json['Snowmass'])
        : null;

    ajax = json['Ajax'] != null
        ? new Ajax.fromJson(json['Ajax'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.buttermilk != null) {
      data['Buttermilk'] = this.buttermilk.toJson();
    }

    if (this.highlands != null) {
      data['Highlands'] = this.highlands.toJson();
    }

    if (this.snowmass != null) {
      data['Snowmass'] = this.snowmass.toJson();
    }

    if (this.ajax != null) {
      data['Ajax'] = this.ajax.toJson();
    }
    return data;
  }
}


class Buttermilk {
  String date;
  String attribute;
  int value;
  String description;

  Buttermilk({this.date, this.attribute, this.value, this.description});

  Buttermilk.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    attribute = json['attribute'];
    value = json['value'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['attribute'] = this.attribute;
    data['value'] = this.value;
    data['description'] = this.description;
    return data;
  }
}

class Highlands {
  String date;
  String attribute;
  int value;
  String description;

  Highlands({this.date, this.attribute, this.value, this.description});

  Highlands.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    attribute = json['attribute'];
    value = json['value'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['attribute'] = this.attribute;
    data['value'] = this.value;
    data['description'] = this.description;
    return data;
  }
}

class Snowmass {
  String date;
  String attribute;
  int value;
  String description;

  Snowmass({this.date, this.attribute, this.value, this.description});

  Snowmass.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    attribute = json['attribute'];
    value = json['value'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['attribute'] = this.attribute;
    data['value'] = this.value;
    data['description'] = this.description;
    return data;
  }
}

class Ajax {
  String date;
  String attribute;
  int value;
  String description;

  Ajax({this.date, this.attribute, this.value, this.description});

  Ajax.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    attribute = json['attribute'];
    value = json['value'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['attribute'] = this.attribute;
    data['value'] = this.value;
    data['description'] = this.description;
    return data;
  }
}