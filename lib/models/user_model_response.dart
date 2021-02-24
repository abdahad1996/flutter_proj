class User {
  int id;
  String name;
  String weatherType;
  String email;
  String deviceType;
  String deviceToken;
  String access_token;
  Details details;
  PaymentStatus payment_status;

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
      payment_status:
          ((json['payment_status'] != null && !(json['payment_status'] is bool))
              ? new PaymentStatus.fromJson(json['payment_status'])
              : null),
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
    if (this.payment_status != null && !(this.payment_status is bool)) {
      map['payment_status'] = this.payment_status.toMap();
    } else if (this.payment_status is bool) {
      map['payment_status'] = this.payment_status.toMap();
    }

    map["deviceType"] = deviceType;
    map["deviceToken"] = deviceToken;
    map["deviceType"] = deviceType;
    map["access_token"] = access_token;
    // map["payment_status"] = payment_status;
    return map;
  }
}

class Package {
  int id;
  String name;
  String description;
  int amount;
  dynamic status;
  Package({
    this.id,
    this.name,
    this.description,
    this.amount,
    this.status,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        amount: json['amount'],
        status: json['status']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["name"] = name;
    map["description"] = description;
    // map["details"]["image_url"] = image;
    map["amount"] = amount;
    map["status"] = status;

    // map["deviceTimage_urloken"] = deviceToken;
    // map["deviceType"] = deviceType;
    // map["access_token"] = access_token;
    // map["payment_status"] = payment_status;
    return map;
  }
}

class PaymentStatus {
  int id;
  int user_id;
  int package_id;
  int amount;
  String is_successful;
  Package package;

  PaymentStatus({
    this.id,
    this.user_id,
    this.package_id,
    this.amount,
    this.is_successful,
    this.package,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      id: json['id'],
      user_id: json['user_id'],
      package_id: json['package_id'],
      amount: json['amount'],
      is_successful: json['is_successful'],
      package: ((json['package'] != null)
          ? new Package.fromJson(json['package'])
          : null),
    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["user_id"] = user_id;
    map["package_id"] = package_id;
    // map["details"]["image_url"] = image;
    map["amount"] = amount;
    map["is_successful"] = is_successful;
    if (this.package != null) {
      map['package'] = this.package.toMap();
    }
    // map["package"] = deviceType;
    // map["access_token"] = access_token;
    // map["payment_status"] = payment_status;
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

class UpdateProfileModel {
  int id;
  String name;

  String email;

  Details details;
  PaymentStatus payment_status;
  UpdateProfileModel(
      {this.id, this.name, this.details, this.email, this.payment_status});

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      details: ((json['details'] != null)
          ? new Details.fromJson(json['details'])
          : null),
      payment_status:
          ((json['payment_status'] != null && !(json['payment_status'] is bool))
              ? new PaymentStatus.fromJson(json['payment_status'])
              : null),
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
    if (this.payment_status != null && !(this.payment_status is bool)) {
      map['payment_status'] = this.payment_status.toMap();
    }

    // map["payment_status"] = payment_status;
    return map;
  }
}
