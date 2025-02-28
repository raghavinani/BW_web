import 'package:flutter/material.dart';
import 'package:login/splash_screen.dart';
import 'package:login/login.dart';
import 'package:login/register.dart';
// import 'package:login/login_otp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: {
      'login': (context) => MyLogin(),
      'register': (context) => MyRegister(),
      // 'login_otp': (context) => LoginWithOTP(),
    },
  ));
}
