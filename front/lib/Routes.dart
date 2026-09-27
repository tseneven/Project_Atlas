import 'package:atlas/Modules/Auth/Screens/AuthScreen.dart';
import 'package:atlas/Modules/Auth/Screens/RegisterScreen.dart';
import 'package:atlas/Modules/Main/Screen/MainScreen.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    "auth": (context) => AuthScreen(),
    "register": (context) => RegisterScreen(),
    "main" : (context) => MainScreen()
  };
}
