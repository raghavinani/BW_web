import 'package:flutter/material.dart';
import 'package:login/login.dart';
import 'package:login/register.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences_web/shared_preferences_web.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // await Hive.initFlutter();
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter is ready before using async functions
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyLogin(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
    },
  ));
}
