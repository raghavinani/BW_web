// import 'package:flutter/material.dart';
// import 'package:login/splash_screen.dart';
// import 'package:login/login.dart';
// import 'package:login/register.dart';
// // import 'package:login/login_otp.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: SplashScreen(),
//     routes: {
//       'login': (context) => MyLogin(),
//       'register': (context) => MyRegister(),
//       // 'login_otp': (context) => LoginWithOTP(),
//     },
//   ));
// }
import 'package:flutter/material.dart';
import 'package:login/splash_screen.dart';
import 'package:login/login.dart';
import 'package:login/register.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:login/content.dart';
import 'secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? _initialPage;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SecureStorage secureStorage = SecureStorage();
    final storedEmail = await secureStorage.readData('email');
    final storedPassword = await secureStorage.readData('password');

    // Wait for splash screen
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // If logged in, go to ContentPage, otherwise go to LoginPage
      _initialPage = (storedEmail != null && storedPassword != null)
          ? ContentPage()
          : MyLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          _initialPage ?? SplashScreen(), // Show splash until decision is made
      routes: {
        'login': (context) => MyLogin(),
        'register': (context) => MyRegister(),
      },
    );
  }
}
