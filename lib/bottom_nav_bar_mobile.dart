import 'package:flutter/material.dart';
import 'package:login/QR_scanner.dart';
import 'package:login/content.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int? tappedIndex;

  void onItemTapped(int index, BuildContext context) {
    setState(() {
      tappedIndex = index;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        tappedIndex = null;
      });
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContentPage()),
      );
    } else if (index == 1) {
      Scaffold.of(context).openEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 40.0,
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home Button
                  GestureDetector(
                    onTap: () => onItemTapped(0, context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: tappedIndex == 0 ? Colors.blue : Colors.black,
                          size: 21.0,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color:
                                tappedIndex == 0 ? Colors.blue : Colors.black,
                            fontSize: 12.0,
                            fontWeight: tappedIndex == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacer for QR scanner
                  const SizedBox(width: 100.0),
                  // Menu Button
                  GestureDetector(
                    onTap: () => onItemTapped(1, context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_2_outlined,
                          color: tappedIndex == 1 ? Colors.blue : Colors.black,
                          size: 21.0,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color:
                                tappedIndex == 1 ? Colors.blue : Colors.black,
                            fontSize: 12.0,
                            fontWeight: tappedIndex == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Floating QR Scanner Icon
            Positioned(
              top: -10.0,
              bottom: -10,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QrCodeScanner()),
                  );
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
