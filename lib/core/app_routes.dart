import 'package:driver/screens/earning/earning.dart';
import 'package:driver/screens/help/help.dart';
import 'package:driver/screens/home/home.dart';
import 'package:driver/screens/message/messag.dart';
import 'package:driver/screens/recentorder/order.dart';
import 'package:driver/screens/setting/setting.dart';
import 'package:flutter/material.dart';

import '../screens/auth/loginSucess.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signUp.dart';
import '../screens/chat/chat.dart';
import '../screens/chat/inbox.dart';
import '../screens/location/location.dart';
import '../screens/order/order.dart';
import '../screens/review_screen/review_screen.dart';
import '../screens/splash/splash.dart';
import '../screens/tabar/tabar.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String loginSucess = "/loginSuccess";
  static const String signup = "/signup";
  static const String location = "/location";
  static const String home = '/home';
  static const String earning = '/earning';
  static const String order = "/order";
  static const notification = "/notification";
  static const message = '/message';
  static const String chatInbox = "/inbox";

  static const settings = "/setting";
  static const help = '/help';
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
        return MaterialPageRoute(builder: (_) => LocationScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case order:
        return MaterialPageRoute(builder: (_) => TabarScreen());
      case earning:
        return MaterialPageRoute(builder: (_) => EarningsScreen());
      case notification:
        return MaterialPageRoute(builder: (_) => UserChatScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => ReviewScreen());
      case help:
        return MaterialPageRoute(builder: (_) => HelpScreen());
      case chatInbox:
        return MaterialPageRoute(builder: (_) => ChatInbox());
      case message:
        return MaterialPageRoute(builder: (_) => ChatUsers());
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
