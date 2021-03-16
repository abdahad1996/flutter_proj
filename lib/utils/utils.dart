import 'dart:io';
import 'dart:math';
import 'package:aspen_weather/models/today_weather_model.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'const.dart';

// void jpgTOpng(path) async {
//   File imagePath = File(path);
//   //get temporary directory
//   final tempDir = await getTemporaryDirectory();
//   int rand = new Math.Random().nextInt(10000);
//   //reading jpg image
//   Im.Image image = Im.decodeImage(imagePath.readAsBytesSync());
//   //decreasing the size of image- optional
//   Im.Image smallerImage = Im.copyResize(image, width:800);
//       //get converting and saving in file
//   File compressedImage = new File('${tempDir.path}/img_$rand.png')..writeAsBytesSync(Im.encodePng(smallerImage, level:8));
// }
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

String validateCardNum(String input) {
  if (input.isEmpty) {
    return 'Required';
  }

  input = getCleanedNumber(input);

  if (input.length < 8) {
    return 'number is invalid ';
  }

  int sum = 0;
  int length = input.length;
  for (var i = 0; i < length; i++) {
    // get digits in reverse order
    int digit = int.parse(input[length - i - 1]);

    // every 2nd number multiply with 2
    if (i % 2 == 1) {
      digit *= 2;
    }
    sum += digit > 9 ? (digit - 9) : digit;
  }

  if (sum % 10 == 0) {
    return null;
  }

  return 'number is invalid ';
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

String format(TodayWeatherModel model) {
  var date = (model.dateTime.contains('T')
      ? model.dateTime.substring(0, model.dateTime.indexOf('T'))
      : '');
  //  +
  // '' +
  var hours = (model.dateTime.contains('T')
      ? model.dateTime
          .substring(model.dateTime.indexOf('T') + 1, model.dateTime.length)
      : '');
  DateTime dt = DateTime.parse(date);

  final d = dt.format(DateTimeFormats.commonLogFormat);
  var splitag = d.split(":");

  print("splitag[0] + ' ' + hours");
  print(splitag[0] + ' ' + hours);

  //logic for converting 24 hours to 12 hour format
  var hoursplit = hours.split("-");
  var fromunformated = hoursplit[0];
  var tomunformated = hoursplit[1];

  var fromformatted = fromunformated.split(":00:00");
  var toformatted = tomunformated.split(":");

  var frompm;
  var fromisPm = false;
  var appendZero = false;

  var topm;
  var toisPm = false;

  //greater than 12 apppend pm and minus
  if (int.parse(fromformatted[0]) > 11) {
    if (int.parse(fromformatted[0]) == 12) {
      frompm = 12;
      fromisPm = true;
      appendZero = false;
    } else {
      var modulus = int.parse(fromformatted[0]) % 12;

      frompm = modulus;
      if (frompm > 9) {
        appendZero = false;
      } else {
        appendZero = true;
      }
      fromisPm = true;
    }
  } else {
    if (int.parse(fromformatted[0]) == 0) {
      frompm = 12;
      fromisPm = true;
      appendZero = false;
    }
  }

  print("fromisPm $fromisPm");
  print("frompm $frompm");
  print("int.parse(fromformatted[0]) ${int.parse(fromformatted[0])}");

  var fromProper =
      "${appendZero ? 0 : ""}${(fromisPm ? frompm : int.parse(fromformatted[0]))}" +
          // fromformatted[1] +
          (fromisPm ? "PM" : "AM");

  if (int.parse(toformatted[0]) > 11) {
    if (int.parse(toformatted[0]) == 12) {
      topm = 12;
      toisPm = true;
    } else {
      var modulus = int.parse(toformatted[0]) % 12;
      topm = modulus;
      toisPm = true;
    }
  }
  var toProper = (toisPm ? topm : toformatted[0]) + "AM";
  // (toisPm ? "PM" :"AM");

  print("from + ' ' + tp");
  print(fromProper + ' - ' + toProper);
  return fromProper;
  // return splitag[0] + ' ' + hours;
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
  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
  http.Response response = await http.get(imageUrl);
// write bodyBytes received in response to file.
  await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
  return file;
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

String getCleanedNumber(String text) {
  RegExp regExp = new RegExp(r"[^0-9]");
  return text.replaceAll(regExp, '');
}

String validateDate(String value) {
  if (value.isEmpty) {
    return "Expiration date is required";
  }

  int year;
  int month;
  // The value contains a forward slash if the month and year has been
  // entered.
  if (value.contains(new RegExp(r'(\/)'))) {
    var split = value.split(new RegExp(r'(\/)'));
    // The value before the slash is the month while the value to right of
    // it is the year.
    month = int.parse(split[0]);
    year = int.parse(split[1]);
  } else {
    // Only the month was entered
    month = int.parse(value.substring(0, (value.length)));
    year = -1; // Lets use an invalid year intentionally
  }

  if ((month < 1) || (month > 12)) {
    // A valid month is between 1 (January) and 12 (December)
    return 'Expiry month is invalid';
  }

  var fourDigitsYear = convertYearTo4Digits(year);
  if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
    // We are assuming a valid should be between 1 and 2099.
    // Note that, it's valid doesn't mean that it has not expired.
    return 'Expiry year is invalid';
  }

  if (!hasDateExpired(month, year)) {
    return "Card has expired";
  }
  return null;
}

/// Convert the two-digit year to four-digit year if necessary
int convertYearTo4Digits(int year) {
  if (year < 100 && year >= 0) {
    var now = DateTime.now();
    String currentYear = now.year.toString();
    String prefix = currentYear.substring(0, currentYear.length - 2);
    year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
  }
  return year;
}

bool hasDateExpired(int month, int year) {
  return !(month == null || year == null) && isNotExpired(year, month);
}

bool isNotExpired(int year, int month) {
  // It has not expired if both the year and date has not passed
  return !hasYearPassed(year) && !hasMonthPassed(year, month);
}

List<int> getExpiryDate(String value) {
  var split = value.split(new RegExp(r'(\/)'));
  return [int.parse(split[0]), int.parse(split[1])];
}

bool hasMonthPassed(int year, int month) {
  var now = DateTime.now();
  // The month has passed if:
  // 1. The year is in the past. In that case, we just assume that the month
  // has passed
  // 2. Card's month (plus another month) is more than current month.
  return hasYearPassed(year) ||
      convertYearTo4Digits(year) == now.year && (month < now.month + 1);
}

bool hasYearPassed(int year) {
  int fourDigitsYear = convertYearTo4Digits(year);
  var now = DateTime.now();
  // The year has passed if the year we are currently is more than card's
  // year
  return fourDigitsYear < now.year;
}

launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    toast('Could not launch $url');
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
