import 'dart:convert';

import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/utils/preference_helper.dart';

import 'const.dart';

class Prefs {
  static Future setWeatherType(String weatherType) {
    return PreferencesHelper.setString(Const.WEATHER_TYPE, weatherType);
  }

  static Future setThemeUrl(String setThemeUrl) {
    return PreferencesHelper.setString(Const.THEME_BACKGROUND_URL, setThemeUrl);
  }

  static Future<void> getThemeUrl(Function(String) success) async {
    String string =
        await PreferencesHelper.getString(Const.THEME_BACKGROUND_URL);
    if (string != null)
      return success(string);
    else
      return success(Const.WEATHER_TYPE_WINTER); // default - summer weather
  }

  static Future<void> getWeatherType(Function(String) success) async {
    String string = await PreferencesHelper.getString(Const.WEATHER_TYPE);
    if (string != null)
      return success(string);
    else
      return success(Const.WEATHER_TYPE_WINTER); // default - summer weather
  }

  static Future setUser(User user) {
    print("user.payment_status");
    print(user.payment_status.package.status);
    print(user.toMap());
    return PreferencesHelper.setString(Const.USER, json.encode(user.toMap()));
  }

  static Future setAccessToken(String accessToken) {
    return PreferencesHelper.setString(Const.ACCESS_TOKEN, accessToken);
  }

  static Future<void> getAccessToken(Function(String) success) async {
    String string = await PreferencesHelper.getString(Const.ACCESS_TOKEN);
    if (string != null)
      return success(string);
    else
      return success(null);
  }

  static Future getAccessTokenAwait() async {
    String string = await PreferencesHelper.getString(Const.ACCESS_TOKEN);
    if (string != null)
      return string;
    else
      return null;
  }

  static Future setAdsUrl(String accessToken) {
    return PreferencesHelper.setString(Const.ADVERTISEMENT_URL, accessToken);
  }

  static Future<void> getAdsUrl(Function(String) success) async {
    String string = await PreferencesHelper.getString(Const.ADVERTISEMENT_URL);
    if (string != null)
      return success(string);
    else
      return success('');
  }

  static Future setFCMToken(String fcmToken) {
    return PreferencesHelper.setString(Const.FCM_TOKEN, fcmToken);
  }

  static Future<void> getFCMToken(Function(String) success) async {
    String string = await PreferencesHelper.getString(Const.FCM_TOKEN);
    if (string != null)
      return success(string);
    else
      return success(null);
  }

  static Future<dynamic> getFCMTokenAwait() async {
    String string = await PreferencesHelper.getString(Const.FCM_TOKEN);
    if (string != null)
      return string;
    else
      return null;
  }

  static Future setNotificationClicked(String isClicked) {
    return PreferencesHelper.setString(
        Const.IS_NOTIFICATION_CLICKED, isClicked);
  }

  static Future<void> getIsClicked(Function(String) isClicked) async {
    String string =
        await PreferencesHelper.getString(Const.IS_NOTIFICATION_CLICKED);
    if (string != null)
      return isClicked(string);
    else
      return isClicked('0');
  }

  static Future<void> getUser(Function(User) success) async {
    String string = await PreferencesHelper.getString(Const.USER);
    print("user from sharedpref");
    print(string);
    if (string != null) {
      var decode = User.fromJson(json.decode(string));
      print("decoded");
      print(decode?.payment_status?.package?.status ?? "nil ");

      return success(decode);
    } else
      return success(null);
  }

  static Future<User> getUserSync() async {
    String string = await PreferencesHelper.getString(Const.USER);
    if (string != null)
      return User.fromJson(json.decode(string));
    else
      return null;
  }

  static void removeUser() {
    PreferencesHelper.remove(Const.USER);
  }

  static Future savePackageId(String packageId) {
    return PreferencesHelper.setString(Const.PACKAGEID, packageId);
  }

  static Future<void> getPackageId(Function(String) success) async {
    String string = await PreferencesHelper.getString(Const.PACKAGEID);
    if (string != null)
      return success(string);
    else
      return success(null);
  }

  static Future clearPackageId() {
    return PreferencesHelper.remove(Const.PACKAGEID);
  }
}
