import 'package:flutter/material.dart';
import 'package:login/app_bar.dart';

void main() {
  runApp(const ContentPage());
}

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: const Center(
        child: Text(
          'Content goes here!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
