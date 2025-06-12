import 'package:driver/screens/home/home.dart';
import 'package:flutter/material.dart';

import '../screens/auth/loginSucess.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signUp.dart';
import '../screens/location/location.dart';
import '../screens/splash/splash.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String loginSucess = "/loginSuccess";
  static const String signup = "/signup";
  static const String location="/location";
  static const String home = '/home';
  static Route<dynamic> onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case loginSucess:
        return MaterialPageRoute(builder: (_) => Loginsucess());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case location:
        return MaterialPageRoute(builder: (_)=>LocationScreen());
      case home:
        return MaterialPageRoute(builder: (_)=> HomeScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text("No route defined for ${setting.name}"),
                ),
              ),
        );
    }
  }
}
