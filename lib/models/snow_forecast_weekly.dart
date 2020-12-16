class SnowForecastWeeklyModel {
  Mon monday;
  Tue tues;
  Wed wed;
  Thu thurs;
  Fri fri;
  Sat sat;
  Sun sun;

  SnowForecastWeeklyModel(this.monday, this.tues, this.wed, this.thurs, this.fri, this.sat, this.sun);

  SnowForecastWeeklyModel.fromJson(Map<String, dynamic> json) {
    
    monday = json['Mon'] != null
        ? new Mon.fromJson(json['Mon'])
        : null;

    tues = json['Tue'] != null
        ? new Tue.fromJson(json['Tue'])
        : null;

    wed = json['Wed'] != null
        ? new Wed.fromJson(json['Wed'])
        : null;

    thurs = json['Thu'] != null
        ? new Thu.fromJson(json['Thu'])
        : null;

    fri = json['Fri'] != null
        ? new Fri.fromJson(json['Fri'])
        : null;

    sat = json['Sat'] != null
        ? new Sat.fromJson(json['Sat'])
        : null;

    sun = json['Sun'] != null
        ? new Sun.fromJson(json['Sun'])
        : null;
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.monday != null) {
      data['Mon'] = this.monday.toJson();
    }

    if (this.tues != null) {
      data['Tue'] = this.tues.toJson();
    }

    if (this.wed != null) {
      data['Wed'] = this.wed.toJson();
    }

    if (this.thurs != null) {
      data['Thu'] = this.thurs.toJson();
    }

    if (this.fri != null) {
      data['Fri'] = this.fri.toJson();
    }

    if (this.sat != null) {
      data['Sat'] = this.sat.toJson();
    }

    if (this.sun != null) {
      data['Sun'] = this.sun.toJson();
    }

    return data;
  }
}

class Mon {
  Buttermilk buttermilk;
  Highlands highlands;
  Snowmass snowmass;
  Ajax ajax;

  Mon({this.buttermilk, this.highlands, this.snowmass, this.ajax});

  Mon.fromJson(Map<String, dynamic> json) {
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

class Tue {
  Buttermilk buttermilk;
  Highlands highlands;
  Snowmass snowmass;
  Ajax ajax;

  Tue({this.buttermilk, this.highlands, this.snowmass, this.ajax});

  Tue.fromJson(Map<String, dynamic> json) {
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

class Wed {
  Buttermilk buttermilk;
  Highlands highlands;
  Snowmass snowmass;
  Ajax ajax;

  Wed({this.buttermilk, this.highlands, this.snowmass, this.ajax});

  Wed.fromJson(Map<String, dynamic> json) {
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

class Thu {
  Buttermilk buttermilk;
  Highlands highlands;
  Snowmass snowmass;
  Ajax ajax;

  Thu({this.buttermilk, this.highlands, this.snowmass, this.ajax});

  Thu.fromJson(Map<String, dynamic> json) {
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

class Fri {
  Buttermilk buttermilk;
  Highlands highlands;
  Snowmass snowmass;
  Ajax ajax;

  Fri({this.buttermilk, this.highlands, this.snowmass, this.ajax});

  Fri.fromJson(Map<String, dynamic> json) {
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

class Sat {
  Buttermilk buttermilk;
  Highlands highlands;
  Snowmass snowmass;
  Ajax ajax;

  Sat({this.buttermilk, this.highlands, this.snowmass, this.ajax});

  Sat.fromJson(Map<String, dynamic> json) {
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

class Sun {
  Buttermilk buttermilk;
  Highlands highlands;
  Snowmass snowmass;
  Ajax ajax;

  Sun({this.buttermilk, this.highlands, this.snowmass, this.ajax});

  Sun.fromJson(Map<String, dynamic> json) {
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