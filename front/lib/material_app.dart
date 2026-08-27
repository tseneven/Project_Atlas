import 'package:flutter/material.dart';
import 'package:front/Screens/login_screen.dart';

class MaterialAppFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}