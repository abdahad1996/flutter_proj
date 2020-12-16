import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/network/rest_api.dart';
import 'package:flutter/material.dart';

void login(
    {@required String email,
    @required String password,
    @required String deviceType,
    @required String deviceToken,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: '/login',
      body: {
        "email": email,
        'password': password,
        "device_type": deviceType,
        "device_token": deviceToken
      },
      onSuccess: (BaseModel baseModel) {
        onSuccess(baseModel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void socialLogin(
    {@required String platform,
    @required String client_id,
    @required String token,
    @required String username,
    @required String email,
    @required dynamic image,
    @required String device_token,
    @required String device_type,
    @required String expires_at,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: '/social_login',
      body: {
        "platform": platform,
        "client_id": client_id,
        "token": token,
        "username": username,
        "email": email,
        "image": image,
        "device_token": device_token,
        "device_type": device_type,
        "expires_at": expires_at
      },


      onSuccess: (BaseModel baseModel) {
        onSuccess(baseModel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void register(
    {@required String name,
    @required String email,
    @required String password,
    @required String confirmPassword,
    @required String deviceType,
    @required String deviceToken,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: '/register',
      body: {
        "name": name,
        "email": email,
        'password': password,
        'password_confirmation': confirmPassword,
        "device_type": deviceType,
        "device_token": deviceToken
      },
      onSuccess: (BaseModel baseModel) {
        onSuccess(baseModel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void changePassword(
    {@required String token,
    @required String current_password,
    @required String password,
    @required String password_confirmation,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Post,
      authToken: token,
      endPoint: '/change-password',
      body: {
        "current_password": current_password,
        'password': password,
        "password_confirmation": password_confirmation
      },
      onSuccess: (BaseModel baseModel) {
        onSuccess(baseModel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void forgetPassword(
    {@required String email,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: '/forget-password?email=$email',
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void verifyResetCode(
    {@required String verificationCode,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: '/verify-reset-code',
      body: {"verification_code": verificationCode},
      onSuccess: (BaseModel baseModel) {
        onSuccess(baseModel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void resetPassword(
    {@required String email,
    @required String verificationCode,
    @required String password,
    @required String confirmPassword,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: '/verify-reset-code',
      body: {
        "email": email,
        "verification_code": verificationCode,
        "password": password,
        "password_confirmation": confirmPassword
      },
      onSuccess: (BaseModel baseModel) {
        onSuccess(baseModel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void me(
    {@required String accessToken,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Post,
      authToken: accessToken,
      endPoint: '/me',
      onSuccess: (BaseModel baseModel) {
        onSuccess(baseModel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void getUser(
    {@required String authToken,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: '/me',
      authToken: authToken,
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

Future<BaseModel> updateUserProfile(
    {@required String accessToken, @required String name}) {
  return invoke(
      method: Method.Post,
      endPoint: 'api/update_user_profile',
      authToken: accessToken,
      body: {"name": name});
}

void getSnowForecastWeekly(
    {@required String authToken,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: '/snow-forecasts-by-type/weekly',
      authToken: authToken,
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void getSnowForecastCumulative(
    {@required String authToken,
    @required String startDate,
    @required String endDate,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: '/snow-forecasts-by-type/range/$startDate/$endDate',
      authToken: authToken,
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void getSnowForecastDate(
    {@required String authToken,
    @required String date,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: '/snow-forecasts-by-type/date/$date/$date',
      authToken: authToken,
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void signOut(
    {@required String accessToken,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Post,
      authToken: accessToken,
      endPoint: '/logout',
      onSuccess: (BaseModel baseModel) {
        onSuccess(baseModel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

void getAd(
    {@required String authToken,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Get,
      endPoint: '/active-advertisement',
      authToken: authToken,
      onSuccess: (BaseModel basemodel) {
        onSuccess(basemodel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}

Future<BaseModel> getPackagesScreen({@required String authToken}) {
  return invoke(
      method: Method.Get, endPoint: '/packages', authToken: authToken);
}

Future<BaseModel> getThreeDaysForecast({@required String authToken}) {
  return invoke(
      method: Method.Get, endPoint: '/daily-forecasts', authToken: authToken);
}

Future<BaseModel> getStormForecast({@required String authToken}) {
  return invoke(
      method: Method.Get, endPoint: '/storm-forecasts', authToken: authToken);
}

Future<BaseModel> getContentPages(
    {@required String authToken, @required String pageId}) {
  return invoke(
      method: Method.Get, endPoint: '/pages/$pageId', authToken: authToken);
}

Future<BaseModel> getDiscussions(
    {@required String authToken, String currentDate}) {
  return invoke(
      method: Method.Get,
      endPoint: '/discussions-by-date/$currentDate',
      authToken: authToken);
}

void chargePayment(
    {@required String accessToken,
    @required String packageId,
    @required String cardName,
    @required String cardNumber,
    @required String expiryDate,
    @required String cvcNumber,
    @required Function(BaseModel baseModel) onSuccess,
    @required Function(String error, BaseModel baseModel) onError}) {
  invokeAsync(
      method: Method.Post,
      endPoint: '/charge',
      authToken: accessToken,
      body: {
        "package_id": packageId,
        "card_name": cardName,
        'card_number': cardNumber,
        'expiry_date': expiryDate,
        "cvc_number": cvcNumber
      },
      onSuccess: (BaseModel baseModel) {
        onSuccess(baseModel);
      },
      onError: (String error, BaseModel baseModel) {
        onError(error, baseModel);
      });
}
