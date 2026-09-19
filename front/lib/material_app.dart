import 'package:atlas/Routes.dart';
import 'package:flutter/material.dart';
import 'package:atlas/Modules/Auth/Screens/AuthScreen.dart';

class MaterialAppFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
    );
  }
}