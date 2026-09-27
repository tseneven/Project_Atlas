import 'package:atlas/Routes.dart';
import 'package:flutter/material.dart';

class MaterialAppFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "register",
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
    );
  }
}