class User {
  int id;
  String name;
  String weatherType;
  String email;
  String deviceType;
  String deviceToken;
  String access_token;
  bool payment_status;

  User(
      {this.id,
      this.name,
      this.weatherType,
      this.email,
      this.deviceType,
      this.deviceToken,
      this.access_token,
      this.payment_status
      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      deviceType: json['deviceType'],
      deviceToken: json['deviceToken'],
      access_token: json['access_token'],
      payment_status: json['payment_status'],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "deviceType": deviceType,
      "deviceToken": deviceToken,
      "deviceType": deviceType,
      "access_token": access_token,
      "payment_status": payment_status,
    };
  }
}
