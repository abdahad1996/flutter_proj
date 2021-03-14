import 'dart:io';

import 'package:aspen_weather/main.dart';
import 'package:aspen_weather/models/active_ad_model.dart';
import 'package:aspen_weather/models/error_data_response.dart';
import 'package:aspen_weather/models/user_auth_model.dart';
import 'package:aspen_weather/models/user_model_response.dart';
import 'package:aspen_weather/network/base_model.dart';
import 'package:aspen_weather/screens/payment_packages.dart';
import 'package:aspen_weather/screens/summer_home_screen.dart';
import 'package:aspen_weather/screens/winter_home_screen.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/service/webservices.dart';
import 'package:aspen_weather/utils/CachedImage.dart';
import 'package:aspen_weather/utils/Dialogs.dart';
import 'package:aspen_weather/utils/const.dart';
import 'package:aspen_weather/utils/prefs.dart';
import 'package:aspen_weather/utils/utils.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const routeName = '/UpdateProfileScreen-screen';

  @override
  UpdateProfileScreenState createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String weatherType;
  bool checkedValue = false;
  User user;
  String _name, _email, _password, _confirmPassword, _deviceType, _deviceToken;
  bool passwordNotVisible = true;
  bool confirmPasswordNotVisible = true;
  File _image;
  String accessToken = '';

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    Prefs.getAccessToken((String accessToken) async {
      print(accessToken);
      this.accessToken = accessToken;
      // apiCallForAd(accessToken);
    });

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });

    Prefs.getUser((User userModel) async {
      setState(() {
        user = userModel;
        // print("user is ${user.details.image_url}");
      });
    });
  }

  void load() async {}

  _imgFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("picked file is $_image");
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Container(
          child: SafeArea(
              child: Stack(
        children: <Widget>[
          Image.asset(weatherType == Const.WEATHER_TYPE_SUMMER
              ? 'assets/images/login_summer_image.png'
              : 'assets/images/login_winter_image.png'),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Image.asset(
                      "assets/images/ic_back_arrow_black.png",
                      fit: BoxFit.contain,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/login_bottom_card.png'),
                        fit: BoxFit.fill)),
                height: 450,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Color(0xffFDCF09),
                                  child: _image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          child: Image.file(
                                            _image,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : (user.details.image_url != null)
                                          ? Cached_Image(
                                              height: 80,
                                              width: 80,
                                              imageURL:
                                                  user?.details?.image_url ??
                                                      "",
                                              shape: BoxShape.circle,
                                              retry: (status) {
                                                print("RETRYINGGG");
                                              },
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              width: 100,
                                              height: 100,
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          TextFormField(
                            initialValue: (user != null) ? user.name : "",
                            decoration: InputDecoration(
                                hintText: 'Enter your username',
                                labelText: "Username"),
                            validator: validateName,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(_emailFocus);
                            },
                            keyboardType: TextInputType.text,
                            onSaved: (text) {
                              _name = text;
                            },
                            onChanged: (text) {
                              _name = text;
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            readOnly: true,
                            initialValue: (user != null) ? user.email : "",
                            decoration: InputDecoration(
                                hintText: 'Enter your email',
                                labelText: "Email"),
                            validator: validateEmail,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocus);
                            },
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (text) {
                              _email = text;
                            },
                            onChanged: (text) {
                              _email = text;
                            },
                          ),
                          SizedBox(height: 15),
                          // TextFormField(
                          //   decoration: InputDecoration(
                          //       hintText: 'Enter your password',
                          //       labelText: 'Password'),
                          //   validator: validatePassword,
                          //   obscureText: passwordNotVisible,
                          //   autofocus: false,
                          //   focusNode: _passwordFocus,
                          //   textInputAction: TextInputAction.done,
                          //   onSaved: (text) {
                          //     _password = text;
                          //   },
                          //   onChanged: (text) {
                          //     _password = text;
                          //   },
                          // ),
                          SizedBox(height: 15),
                          // TextFormField(
                          //   decoration: InputDecoration(
                          //       labelText: 'Confirm Password',
                          //       hintText: 'Enter your confirm password'),
                          //   validator: validateConfirmPassword,
                          //   textInputAction: TextInputAction.done,
                          //   focusNode: _confirmPasswordFocus,
                          //   obscureText: confirmPasswordNotVisible,
                          //   onFieldSubmitted: (v) {},
                          //   onSaved: (text) {
                          //     _confirmPassword = text;
                          //   },
                          //   onChanged: (text) {
                          //     _confirmPassword = text;
                          //   },
                          // ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  side: BorderSide(color: Color(0xff3D73FF))),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  // updateWithImage()
                                  // if (_password != _confirmPassword) {
                                  //   toast(
                                  //       'Password and Confirm Password must be same.');
                                  // } else {
                                  //   _formKey.currentState.save();
                                  apiCallForUpdate();
                                  // }
                                }
                              },
                              color: Color(0xff3D73FF),
                              textColor: Colors.white,
                              child: Text("Update",
                                  style: TextStyle(fontSize: 17)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ))),
    );
  }

  void updateWithImage(
    @required String name,
    @required String email,
    String password,
    String confirmPassword,
    String deviceType,
    String deviceToken,
    @required dynamic image,
  ) async {
    // request.files.add(new http.MultipartFile.fromBytes('file',  image, contentType: new MediaType('image', 'jpeg')))
    // try {
    dynamic fileName;
    dynamic imageToBe;
    if (_image == null && user?.details?.image_url != null ?? false) {
      imageToBe = null;
      fileName = null;
      // imageToBe = user?.details?.image_url ?? null;
      // fileName = user?.details?.image_url?.split('/')?.last ?? "test.jpg";
    } else if (_image != null) {
      print("image $image");
      fileName = await image.path.split('/').last;
      print("fileName $fileName");
      imageToBe = image.path;
    } else {
      imageToBe = null;
      fileName = null;
    }

    // dynamic pngFile = await urlToPngFile(image.path);
    // print("pngFile $pngFile");

    var formData = FormData.fromMap({
      // "platform": platform,
      // "client_id": client_id,
      "name": name,
      "email": email,
      // "password": password,
      // "password_confirmation": confirmPassword,
      //important),
      // "device_token": deviceToken,
      // "device_type": deviceType,
      "image": (imageToBe == null && fileName == null)
          ? null
          : await MultipartFile.fromFile(imageToBe, filename: fileName),

      // "expires_at": expires_at,
    });
    print("FORM DATA ${formData?.fields}");
    // print("image path ${image?.path ?? 2}");

    if ((formData?.fields?.isEmpty ?? false) &&
        (formData?.files?.isEmpty ?? false)) {
      toast("Please edit atleast one field ");

      Dialogs.hideDialog(context);
      return;
    }
    try {
      Dio dio = new Dio();
      // dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${this.accessToken}";
      dynamic response = await dio.post(
          "https://kanztainer.com/aspen-weather/api/v1/users/update-profile/${user.id}",
          options: Options(contentType: 'multipart/form-data'),
          data: formData);
      Dialogs.hideDialog(context);

      //
      // request.send().then((response) {
      print(" response:, ${response}");
      int statusCode = response.statusCode;
      dynamic responsebody = response.data;
      print(" responsebody:, ${responsebody}");
      final baseModel = BaseModel.fromJson(responsebody);

      // String jsonBody = json.decode(response);

      if (response.statusCode == 200) {
        print("sucesss");
        if (baseModel.data != null) {
          toast(baseModel.message);
          print("base model is ${baseModel.data}");
          UpdateProfileModel userAuthModel =
              UpdateProfileModel.fromJson(baseModel.data);

          // user = userAuthModel.user;
          // print("user is $user");
          // print("useraccess_token is ${user.access_token}");
          // print("user status is ${user}");
          // Prefs.getUser((User userModel) async {
          //   userModel.name = user.name;
          //   userModel.email = user.email;
          //   userModel.details.image_url = user.details.image_url;
          //   Prefs.setUser(user);
          // });

          print("user.name");
          print(userAuthModel.name);

          print(user.name);

          print("user.email");
          print(userAuthModel.email);

          print(user.email);

          user.name = userAuthModel.name;
          user.email = userAuthModel.email;
          user.details.image_url = userAuthModel.details.image_url;

          print(user.name);
          Prefs.setUser(user);

          if (user?.payment_status?.package?.status == null ?? false) {
            toast(
                'You need to buy package first to access application features.');
            // Prefs.clearPackageId();
            // Navigator.pushNamed(context, PackagesScreen.routeName);
          } else {
            if (weatherType == Const.WEATHER_TYPE_SUMMER) {
              Navigator.pushReplacementNamed(
                  context, SummerHomeScreen.routeName,
                  arguments: {
                    'user': user,
                  });
            } else {
              Navigator.pushReplacementNamed(
                  context, WinterHomeScreen.routeName,
                  arguments: {
                    'user': user,
                  });
            }
          }

          // Prefs.setAccessToken(user.access_token);

          // UserAuthModel userAuthModel = UserAuthModel.fromJson(baseModel.data);

          // user = userAuthModel.user;
          // Prefs.setAccessToken(user.access_token);
          // Prefs.setUser(user);
          // apiCallForAd( this.accessToken);

        }
      } else {
        print("error response:, ${response}");
        toast(baseModel.message);
        // throw Exception(response);
      }
    } catch (error) {
      Dialogs.hideDialog(context);
      toast(
          error?.response?.toString() ?? "error exception in updating image ");
      print("error is ${error?.response ?? "error in update profle screen "}");
      print("error is ${error.response?.statusCode ?? 400}");
      return;
    }
    // } catch (e) {
    //   Dialogs.hideDialog(context);
    //   print(e);
    //   toast("exception found $e");
    //   return;
    // }
  }

  Future<void> apiCallForUpdate() async {
    if (Platform.isIOS) {
      _deviceType = "ios";
    } else if (Platform.isAndroid) {
      _deviceType = "android";
    }
    _deviceToken = "123";

    if (_image == null && user.details.image_url == null) {
      toast("please select an image");
      return;
    }
    Dialogs.showLoadingDialog(context);
    updateWithImage(_name, _email, _password, _confirmPassword, _deviceType,
        _deviceToken, _image ?? user?.details?.image_url ?? null);
  }

  Future<void> apiCallForAd(String accessToken) async {
    getAd(
        authToken: accessToken,
        onSuccess: (BaseModel baseModel) {
          if (baseModel.data != null) {
            // AdsModel adModel = AdsModel.fromJson(baseModel.data);
            // Prefs.setAdsUrl(adModel.attachment_url);

            if (!user.payment_status.package.status) {
              toast(
                  'You need to buy package first to access application features.');
              Prefs.clearPackageId();
              Navigator.pushNamed(context, PackagesScreen.routeName);
            } else {
              if (weatherType == Const.WEATHER_TYPE_SUMMER) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    SummerHomeScreen.routeName,
                    (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    WinterHomeScreen.routeName,
                    (Route<dynamic> route) => false);
              }
            }
          }
        },
        onError: (String error, BaseModel baseModel) {
          toast(error);
        });
  }
}

class Final {}
