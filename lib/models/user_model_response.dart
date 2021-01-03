class User {
  int id;
  String name;
  String weatherType;
  String email;
  String deviceType;
  String deviceToken;
  String access_token;
  Details details;
  bool payment_status;

  User(
      {this.id,
      this.name,
      this.details,
      this.weatherType,
      this.email,
      this.deviceType,
      this.deviceToken,
      this.access_token,
      this.payment_status});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      details: ((json['details'] != null)
          ? new Details.fromJson(json['details'])
          : null),
      deviceType: json['deviceType'],
      deviceToken: json['deviceToken'],
      access_token: json['access_token'],
      payment_status: json['payment_status'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["name"] = name;
    map["email"] = email;
    if (this.details != null) {
      map['details'] = this.details.toMap();
    }

    map["deviceType"] = deviceType;
    map["deviceToken"] = deviceToken;
    map["deviceType"] = deviceType;
    map["access_token"] = access_token;
    map["payment_status"] = payment_status;
    return map;
  }
}

class Details {
  int id;
  String image;
  String is_social_login;
  String image_url;

  Details({
    this.id,
    this.image,
    this.is_social_login,
    this.image_url,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
        id: json['id'],
        image: json['image'],
        is_social_login: json['is_social_login'],
        image_url: json['image_url']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["image"] = image;
    map["is_social_login"] = is_social_login;
    // map["details"]["image_url"] = image;
    map["image_url"] = image_url;
    // map["deviceTimage_urloken"] = deviceToken;
    // map["deviceType"] = deviceType;
    // map["access_token"] = access_token;
    // map["payment_status"] = payment_status;
    return map;
  }
}
