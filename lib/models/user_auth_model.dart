import 'package:aspen_weather/models/user_model_response.dart';

class UserAuthModel {
  User user;

  UserAuthModel({this.user});

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
        user: json['user'] != null
            ? new User.fromJson(json['user'])
            : null);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toMap();
    }
    return data;
  }
}
