import 'dart:convert';
import 'dart:io';

import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'base_model.dart';

String baseUrl =
    'https://kanztainer.com/aspen-weather/api/v1'; // client - production
// 'http://admin.aspenweather.net/api';
enum Method { Get, Post, Put, Multipart }

Future<BaseModel> get(String endPoint, {String authToken}) async {
  Map<String, String> headers = {"Authorization": 'Bearer $authToken'};
  print(" URL $baseUrl$endPoint");
  print(" headers $headers");
  http.Response response = await http.get(baseUrl + endPoint, headers: headers);
  print(" response $response");
  int statusCode = response.statusCode;
  String responsebody = response.body;
  var jsonBody = json.decode(responsebody);
  print("response: ${jsonBody}");
  // int statusCode = response.statusCode;
  if (statusCode == 200) {
    String body = response.body;
    var jsonBody = json.decode(body);
    print(body);
    return BaseModel.fromJson(jsonBody);
  } else {
    print("error response:, ${response.body}");
    return BaseModel.fromJson(jsonBody);
    // throw Exception(response.reasonPhrase);
  }
}

Future<BaseModel> postFormData(String endPoint, Map<String, dynamic> body,
    {String authToken}) async {
  Map<String, String> headers = {"Authorization": 'Bearer $authToken'};
  print("end point : $endPoint");
  print("end body : $body");

  http.Response response =
      await http.post(baseUrl + endPoint, headers: headers, body: body);
  int statusCode = response.statusCode;
  String responsebody = response.body;
  var jsonBody = json.decode(responsebody);
  print("response: ${jsonBody}");

  if (statusCode == 200) {
    return BaseModel.fromJson(jsonBody);
  } else {
    print("error response:, ${response.body}");
    return BaseModel.fromJson(jsonBody);
  }
}

Future<BaseModel> postMultiPart(String methodType, String endPoint,
    Map<String, dynamic> body, Map<String, dynamic> files,
    {String authToken}) async {
  var uri = Uri.parse(baseUrl + endPoint);
  var request = http.MultipartRequest(methodType, uri);
  request.headers.addAll({
    "Authorization": 'Bearer $authToken',
  });
  body.forEach((key, val) {
    request.fields[key] = val.toString();
  });

  files.forEach((key, val) async {
    if (val != null) {
      print(key + (val as File).path);
      File file = (val as File);
      List<int> id = file.readAsBytesSync();
      String base64 = base64UrlEncode(id);
      request.fields[key] = base64;
    }
  });
  var response = await request.send();
  int statusCode = response.statusCode;
  if (statusCode == 200) {
    String body = await response.stream.bytesToString();
    var jsonBody = json.decode(body);
    print(body);
    return BaseModel.fromJson(jsonBody);
  } else {
    throw Exception(response.reasonPhrase);
  }
}

// when no ui in response - such as login sign up
Future<void> invokeAsync(
    {@required String endPoint,
    @required Method method,
    Map<String, dynamic> body,
    Map<String, dynamic> files,
    String authToken,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) async {
  if (await isConnected()) {
    try {
      BaseModel baseModel;
      if (method == Method.Get)
        baseModel = await get(endPoint, authToken: authToken);
      else if (method == Method.Post || method == Method.Put) {
        // print("auth token $authToken ");
        baseModel = await postFormData(endPoint, body, authToken: authToken);
      } else
        baseModel = await postMultiPart("POST", endPoint, body, files,
            authToken: authToken);

      if (baseModel.success)
        onSuccess(baseModel);
      else
        onError(baseModel.message, baseModel);
    } catch (error) {
      onError(error.toString(), null);
    }
  } else {
    onError(Const.NO_INTERNET_MESSAGE, null);
  }
}

// when ui in response - such as listing
Future<BaseModel> invoke(
    {@required String endPoint,
    @required Method method,
    Map<String, dynamic> body,
    String authToken}) async {
  if (await isConnected()) {
    BaseModel baseModel = (method == Method.Get)
        ? await get(endPoint, authToken: authToken)
        : await postFormData(endPoint, body, authToken: authToken);
    if (baseModel.success)
      return baseModel;
    else
      throw baseModel.message;
  } else {
    throw Const.NO_INTERNET_MESSAGE;
  }
}
