import 'package:flutter/material.dart';
import 'package:login/content.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('My Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContentPage()),
              );
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/profile_image.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Raghav Inani',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        'ID  S2948',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Text(
                        'IT Department',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.edit, color: Colors.black),
                ],
              ),
            ),
            _sectionTitle('Account info'),
            _infoPlaceholder(),
            _infoPlaceholder(),
            _infoPlaceholder(),
            _sectionTitle('Dashboard Report'),
            _infoPlaceholder(),
            _infoPlaceholder(),
            _infoPlaceholder(),
            _sectionTitle('Personal Info'),
            _infoPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _infoPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
