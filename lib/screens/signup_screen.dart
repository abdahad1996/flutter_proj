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

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String weatherType;
  bool checkedValue = false;
  User user;
  String _name, _email, _password, _confirmPassword, _deviceType, _deviceToken;
  bool passwordNotVisible = true;
  bool confirmPasswordNotVisible = true;
  File _image;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    Prefs.getWeatherType((String weather) {
      setState(() {
        weatherType = weather;
      });
    });
  }

  void load() async {}

  @override
  Widget build(BuildContext context) {
    String ImageUrl = 'https://i.stack.imgur.com/Dw6f7.png';

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
                height: MediaQuery.of(context).size.height * 0.6,
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
                                              BorderRadius.circular(50),
                                          child: Image.file(
                                            _image,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(50)),
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
                            decoration: InputDecoration(
                                hintText: 'Enter your username',
                                labelText: 'Username'),
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
                            decoration: InputDecoration(
                                hintText: 'Enter your email',
                                labelText: 'Email'),
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
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter your password',
                                labelText: 'Password'),
                            validator: validatePassword,
                            obscureText: passwordNotVisible,
                            autofocus: false,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.done,
                            onSaved: (text) {
                              _password = text;
                            },
                            onChanged: (text) {
                              _password = text;
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Enter your confirm password'),
                            validator: validateConfirmPassword,
                            textInputAction: TextInputAction.done,
                            focusNode: _confirmPasswordFocus,
                            obscureText: confirmPasswordNotVisible,
                            onFieldSubmitted: (v) {},
                            onSaved: (text) {
                              _confirmPassword = text;
                            },
                            onChanged: (text) {
                              _confirmPassword = text;
                            },
                          ),
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
                                  if (_password != _confirmPassword) {
                                    toast(
                                        'Password and Confirm Password must be same.');
                                  } else {
                                    _formKey.currentState.save();
                                    apiCallForSignUp();
                                  }
                                }
                              },
                              color: Color(0xff3D73FF),
                              textColor: Colors.white,
                              child: Text("Sign up",
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

  _imgFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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

  uploadImage() async {
    // final _storage = FirebaseStorage.instance;
    // final _picker = ImagePicker();
    // PickedFile image;

    // //Check Permissions
    // await Permission.photos.request();

    // var permissionStatus = await Permission.photos.status;

    // if (permissionStatus.isGranted){
    //   //Select Image
    //   image = await _picker.getImage(source: ImageSource.gallery);
    //   var file = File(image.path);

    //   if (image != null){
    //     //Upload to Firebase
    //     var snapshot = await _storage.ref()
    //     .child('folderName/imageName')
    //     .putFile(file)
    //     .onComplete;

    //     var downloadUrl = await snapshot.ref.getDownloadURL();

    //     setState(() {
    //       imageUrl = downloadUrl;
    //     });
    //   } else {
    //     print('No Path Received');
    //   }

    // } else {
    //   print('Grant Permissions and try again');
    // }

    // }
  }

  Future<void> apiCallForSignUp() async {
    if (Platform.isIOS) {
      _deviceType = "ios";
    } else if (Platform.isAndroid) {
      _deviceType = "android";
    }
    // Prefs.getFCMToken((pushtoken) {
    //   if (pushtoken == null) {
    //     _deviceToken = "123";
    //   } else {
    //     _deviceToken = pushtoken;
    //   }
    // });
    _deviceToken = await Prefs.getFCMTokenAwait();
    if (_deviceToken == null) {
      _deviceToken = "123";
    } else {
      _deviceToken = _deviceToken;
    }

    if (_image == null) {
      toast("please select an image");
      return;
    }
    Dialogs.showLoadingDialog(context);
    registerWithImage(_name, _email, _password, _confirmPassword, _deviceType,
        _deviceToken, _image);
    // onSuccess: (BaseModel baseModel) {
    //   Dialogs.hideDialog(context); //toast(baseModel.message);

    //   if (baseModel.data != null) {
    //     UserAuthModel userAuthModel =
    //         UserAuthModel.fromJson(baseModel.data);
    //     user = userAuthModel.user;

    //     Prefs.setAccessToken(user.access_token);
    //     Prefs.setUser(user);

    //     apiCallForAd(user.access_token);
    //   }
    // },
    // onError: (String error, BaseModel baseModel) {
    //   Dialogs.hideDialog(context);
    //   toast(error);
    // });
  }

  void registerWithImage(
    @required String name,
    @required String email,
    @required String password,
    @required String confirmPassword,
    @required String deviceType,
    @required String deviceToken,
    @required dynamic image,
  ) async {
    // request.files.add(new http.MultipartFile.fromBytes('file',  image, contentType: new MediaType('image', 'jpeg')))
    String fileName = image.path.split('/').last;
    print("fileName $fileName");
    // dynamic pngFile = await urlToPngFile(image.path);
    // print("pngFile $pngFile");

    var formData = FormData.fromMap({
      // "platform": platform,
      // "client_id": client_id,
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
      //important),
      "device_token": deviceToken,
      "device_type": deviceType,
      "image": await MultipartFile.fromFile(image.path, filename: fileName),

      // "expires_at": expires_at,
    });
    print("FORM DATA ${formData.fields}");
    print("image path ${image.path}");

    try {
      BaseOptions options = new BaseOptions(
          baseUrl: "https://kanztainer.com/aspen-weather/api/v1",
          receiveDataWhenStatusError: true,
          connectTimeout: 60000, // 60 seconds
          receiveTimeout: 60000 // 60 seconds
          );

      dynamic response = await Dio(options).post("/register",
          options: Options(contentType: 'multipart/form-data'), data: formData);
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
          UserAuthModel userAuthModel = UserAuthModel.fromJson(baseModel.data);

          user = userAuthModel.user;
          Prefs.setAccessToken(user.access_token);
          if (user.payment_status != null) {
            Prefs.setUser(user);
          }

          apiCallForAd(user.access_token);
        }
      } else {
        print("error response:, ${response}");
        toast(baseModel.message);
        // throw Exception(response);
      }
    } on DioError catch (ex) {
      Dialogs.hideDialog(context);

      if (ex.type == DioErrorType.CONNECT_TIMEOUT ||
          ex.type == DioErrorType.SEND_TIMEOUT ||
          ex.type == DioErrorType.RECEIVE_TIMEOUT) {
        toast("Connection Timeout");

        // throw Exception("Connection  Timeout Exception");
      } else if (ex.type == DioErrorType.RESPONSE) {
        dynamic responsebody = ex.response.data;
        print(" responsebody:, ${responsebody}");
        final baseModel = BaseModel.fromJson(responsebody);
        toast(baseModel.message);
      } else if (ex.type == DioErrorType.DEFAULT) {
        dynamic responsebody = ex.response.data;
        print(" responsebody:, ${responsebody}");
        final baseModel = BaseModel.fromJson(responsebody);
        toast(baseModel.message);
        // toast(ex.message);
      } else if (ex.type == DioErrorType.CANCEL) {
        toast(ex.message);
      }
    }
    // } catch (error) {
    //   Dialogs.hideDialog(context);

    //   if (error.response == null || error.response == "") {
    //     toast(error.message);
    //   } else {
    //     toast(error.response.data.message);
    //   }
    //   // if (err.response == null ||  err.response == ""){
    //   // toast(err.message);
    //   // }
    //   //  toast(error.message);
    //   // print("error is ${error}");
    //   // print("error is ${error.response}");
    //   // print("error is ${error.response?.statusCode}");
  }

  Future<void> apiCallForAd(String accessToken) async {
    getAd(
        authToken: accessToken,
        onSuccess: (BaseModel baseModel) {
          if (baseModel.data != null) {
            AdsModel adModel = AdsModel.fromJson(baseModel.data);
            Prefs.setAdsUrl(adModel);

            if (user.payment_status == null) {
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
