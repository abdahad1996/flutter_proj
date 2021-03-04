import 'dart:async';

import 'package:aspen_weather/screens/Notification_Screen.dart';
import 'package:aspen_weather/screens/about_screen.dart';
import 'package:aspen_weather/screens/change_password_screen.dart';
import 'package:aspen_weather/screens/cumulative_snow.dart';
import 'package:aspen_weather/screens/forget_password_screen.dart';
import 'package:aspen_weather/screens/login_screen.dart';
import 'package:aspen_weather/screens/airport_screen.dart';
import 'package:aspen_weather/screens/payment_packages.dart';
import 'package:aspen_weather/screens/payment_pay_screen.dart';
import 'package:aspen_weather/screens/profile_screen.dart';
import 'package:aspen_weather/screens/reset_password_screen.dart';
import 'package:aspen_weather/screens/signup_screen.dart';
import 'package:aspen_weather/screens/snow_calendar.dart';
import 'package:aspen_weather/screens/snow_forecast.dart';
import 'package:aspen_weather/screens/splash_screen.dart';
import 'package:aspen_weather/screens/summer_home_screen.dart';
import 'package:aspen_weather/screens/terms_screen.dart';
import 'package:aspen_weather/screens/thunder_screen.dart';
import 'package:aspen_weather/screens/updateProfile_Screen.dart';
import 'package:aspen_weather/screens/verify_reset_code_screen.dart';
import 'package:aspen_weather/screens/why_join_screen.dart';
import 'package:aspen_weather/screens/winter_home_screen.dart';
import 'package:aspen_weather/service/pushServices.dart';
import 'package:aspen_weather/utils/views.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:overlay_support/overlay_support.dart' as overay;
import 'package:page_transition/page_transition.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// void main() => runApp(
//   MyApp());
void main() => runApp(
      DevicePreview(
        // enabled: !kReleaseMode,
        enabled: false,

        builder: (context) => MyApp(), // Wrap your app
      ),
    );

DateTime currentBackPressTime;

/*
  App theme
 */
const Color primaryColor = Color(0xff6B74DB);
const Color secondaryColor = Color(0xff747DE5);
const Color accentColor = Color(0xff4BD863);

var themeData = ThemeData(
    primaryColor: primaryColor,
    accentColor: accentColor,
    brightness: Brightness.light,
    canvasColor: Colors.white,
    iconTheme: IconThemeData(color: accentColor),
    unselectedWidgetColor: Colors.grey);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light); //Setting dark mode

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //locking to portrait mode
  }

  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
    return OKToast(
        child: WillPopScope(
            child: overay.OverlaySupport(
                child: MaterialApp(
              locale: DevicePreview.locale(context), // Add the locale here
              builder: (context, child) {
                return MediaQuery(
                  child: child,
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                );
              },
              title: 'Aspen Weather',
              theme: themeData,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: getRoute,
              navigatorKey: navigatorKey,
              onUnknownRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => SplashScreen(),
                );
              },
            )),
            onWillPop: onWillPop));
  }

  Route<dynamic> getRoute(RouteSettings settings) {
    Map<Object, Object> arguments = settings.arguments;

    switch (settings.name) {
      case '/':
        return setTransition(SplashScreen());
        break;

      case LoginScreen.routeName:
        return setTransition(LoginScreen());
        break;

      case SignupScreen.routeName:
        return setTransition(SignupScreen());
        break;

      case ChangePasswordScreen.routeName:
        return setTransition(ChangePasswordScreen());
        break;

      case ForgetPasswordScreen.routeName:
        return setTransition(ForgetPasswordScreen());
        break;

      case VerifyResetCodeScreen.routeName:
        return setTransition(VerifyResetCodeScreen(
          arguments['email'],
        ));
        break;

      case ResetPasswordScreen.routeName:
        return setTransition(ResetPasswordScreen(
          arguments['email'],
          arguments['code'],
        ));
        break;

      case SummerHomeScreen.routeName:
        return setTransition(SummerHomeScreen());
        break;

      case WinterHomeScreen.routeName:
        return setTransition(WinterHomeScreen());
        break;

      case AirportScreen.routeName:
        return setTransition(AirportScreen());
        break;

      case ProfileScreen.routeName:
        return setTransition(ProfileScreen());
        break;

      case PackagesScreen.routeName:
        return setTransition(PackagesScreen());
        break;

      case PayNowScreen.routeName:
        return setTransition(PayNowScreen(arguments['packageId']));
        break;

      case ThunderScreen.routeName:
        return setTransition(ThunderScreen());
        break;

      case AboutScreen.routeName:
        return setTransition(AboutScreen());
        break;

      case TermsScreen.routeName:
        return setTransition(TermsScreen());
        break;

      case WhyJoin.routeName:
        return setTransition(WhyJoin());
        break;

      case CumulativeSnowScreen.routeName:
        return setTransition(CumulativeSnowScreen());
        break;

      case SnowForecastScreen.routeName:
        return setTransition(SnowForecastScreen());
        break;

      case SnowCalendarScreen.routeName:
        return setTransition(SnowCalendarScreen());
        break;

      case UpdateProfileScreen.routeName:
        return setTransition(UpdateProfileScreen());
        break;
      case NotificationScreen.routeName:
        return setTransition(NotificationScreen());
        break;
      default:
        return null;
    }
  }

  PageTransition setTransition(Widget widget) {
    var animation = PageTransitionType.fade;
    return PageTransition(
        child: widget, type: animation, duration: Duration(milliseconds: 500));
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      toast('Press again to exit!');
      return Future.value(false);
    }

    return Future.value(true);
  }
}
