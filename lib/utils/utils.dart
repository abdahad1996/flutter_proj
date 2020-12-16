import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'const.dart';

String validateName(String value) {
  if (value.length < 3) return 'Full Name is required';
  if (value.length > 25)
    return 'Name is too long';
  else if (value.contains('  '))
    return 'Double space is not allowed between name';
  else
    return null;
}

String validateMobile(String value) {
  if (value.length == 0) return 'Phone number is required';
  if (value.substring(1).contains('+')) return 'Invalid phone number';
  if (value.length < 6) return 'Please enter a valid phone number';
  if (value.length > 10) return 'Phone number cannot be more than 10 digits';
  if (value.contains('-'))
    return 'Only numbers are allowed';
  else
    return null;
}

String validatePassword(String value) {
  if (value.length == 0)
    return 'Password is required';
  else
    return null;
}

String validateNewPassword(String value) {
  if (value.length == 0)
    return 'New Password is required';
  else
    return null;
}

String validateConfirmPassword(String value) {
  if (value.length == 0)
    return 'Confirm Password is required';
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Please enter valid email address';
  else
    return null;
}

String validateField(String value) {
  if (value.length == 0)
    return 'Required';
  else
    return null;
}

String validateGraduationYear(String value) {
  if (value.length == 0)
    return 'Graduate Year is required';
  else if (value.contains('-'))
    return 'Only numbers are allowed';
  else if (value.length != 4)
    return 'Example: 2005';
  else
    return null;
}

String formatDate(String dateString, String dateFormat) {
  DateTime dateTime = DateFormat("dd-MM-yyyy").parse(dateString);
  return DateFormat(dateFormat).format(dateTime);
}

//Date: 'EEEE, dd MMMM yyyy'  Time: 'hh:mm a'"
String formatTime(String timeString, String timeFormat) {
  DateTime dateTime = DateFormat("H:m").parse(timeString);
  return DateFormat(timeFormat).format(dateTime);
}

Future<bool> isConnected() async {
  try {
    final result = await InternetAddress.lookup('example.com')
        .timeout(Duration(seconds: 3), onTimeout: () {
      return List();
    });
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else
      return false;
  } on SocketException catch (_) {
    return false;
  }
}

void IsConnected(Function(bool) connected) async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      connected(true);
    } else
      connected(false);
  } on SocketException catch (_) {
    connected(false);
  }
}

void logOut(BuildContext context) async {
  //toast(Const.MESSAGE_SESSION_EXPIRED_APP);
  Prefs.setAccessToken(null);
  Prefs.removeUser();
}

Future<File> urlToPngFile(String imageUrl) async {
// generate random number.
var rng = new Random();
// get temporary directory of device.
Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// call http.get method and pass imageUrl into it to get response.
http.Response response = await http.get(imageUrl);
// write bodyBytes received in response to file.
await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in 
// temporary directory and image bytes from response is written to // that file.
return file;
}