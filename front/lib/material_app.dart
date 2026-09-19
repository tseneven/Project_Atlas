import 'package:atlas/Routes.dart';
import 'package:flutter/material.dart';

class MaterialAppFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "main",
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
    );
  }
}