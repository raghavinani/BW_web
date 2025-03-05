import 'package:flutter/material.dart';
import 'package:login/content.dart';
import 'package:login/login_otp.dart';
import 'secure_storage.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> with SingleTickerProviderStateMixin {
  bool isChecked = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final SecureStorage secureStorage = SecureStorage();
  String? errorMessage;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
    getStoredData();
  }

  void getStoredData() async {
    final storedEmail = await secureStorage.readData('email');
    final storedPassword = await secureStorage.readData('password');
    if (storedEmail != null && storedPassword != null) {
      email.text = storedEmail;
      password.text = storedPassword;
      isChecked = true;
      setState(() {});
    }
  }

  void login() async {
    final storedEmail = await secureStorage.readData('email');
    final storedPassword = await secureStorage.readData('password');
    if (email.text == storedEmail && password.text == storedPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ContentPage()),
      );
    } else {
      setState(() {
        errorMessage = "Invalid email or password";
      });
    }
    if (isChecked) {
      await secureStorage.saveData('email', email.text);
      await secureStorage.saveData('password', password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/login.png",
              fit: BoxFit.fill, // Covers the entire screen
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Center(
                child: Text(
                  'WelCome Back',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'SPARSH',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SlideTransition(
                  position: _animation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        if (errorMessage !=
                            null) // Show error message if present
                          Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: email,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Username",
                            hintStyle: const TextStyle(color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: password,
                          obscureText: true,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Password",
                            hintStyle: const TextStyle(color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?",
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ),
                        Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isChecked,
                              visualDensity: VisualDensity.compact,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value ?? false;
                                });
                              },
                            ),
                            const Text("Remember Me",
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 50),
                          ),
                          onPressed: login,
                          child: const Text("Log In",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginWithOtp()),
                            );
                          },
                          child: const Text("Log in With Otp",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
