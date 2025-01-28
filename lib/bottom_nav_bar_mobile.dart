import 'package:flutter/material.dart';
import 'package:login/QR_scanner.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int currentIndex = -1; // Default selected index

  // Function that will be called when an item is tapped
  void onItemTapped(int index) {
    setState(() {
      currentIndex = index; // Update the current index
    });

    // Open the drawer when a bottom navigation item is clicked
    if (index == 0) {
      // Show the 'Transactions' sublinks
      Scaffold.of(context).openDrawer();
    } else if (index == 1) {
      // Show the 'Reports' sublinks
      Scaffold.of(context).openDrawer();
    } else if (index == 2) {
      // Show the 'Masters' sublinks
      Scaffold.of(context).openDrawer();
    } else if (index == 3) {
      // Show the 'Miscellaneous' sublinks
      Scaffold.of(context).openDrawer();
    } else if (index == 4) {
      // Show QR Scanner screen or action
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QrCodeScanner()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70.0,
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                  // Transactions Icon
                  GestureDetector(
                    onTap: () => onItemTapped(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          color: currentIndex == 0 ? Colors.blue : Colors.black,
                          size: 45.0,
                        ),
                        Text(
                          'Transactions',
                          style: TextStyle(
                            color:
                                currentIndex == 0 ? Colors.blue : Colors.black,
                            fontSize: 16.0,
                            fontWeight: currentIndex == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Reports Icon
                  GestureDetector(
                    onTap: () => onItemTapped(1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.insert_chart_outlined,
                          color: currentIndex == 1 ? Colors.blue : Colors.black,
                          size: 45.0,
                        ),
                        Text(
                          'Reports',
                          style: TextStyle(
                            color:
                                currentIndex == 1 ? Colors.blue : Colors.black,
                            fontSize: 16.0,
                            fontWeight: currentIndex == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacer for QR scanner
                  const SizedBox(width: 70.0),
                  // Masters Icon
                  GestureDetector(
                    onTap: () => onItemTapped(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings_outlined,
                          color: currentIndex == 2 ? Colors.blue : Colors.black,
                          size: 45.0,
                        ),
                        Text(
                          'Masters',
                          style: TextStyle(
                            color:
                                currentIndex == 2 ? Colors.blue : Colors.black,
                            fontSize: 16.0,
                            fontWeight: currentIndex == 2
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Miscellaneous Icon
                  GestureDetector(
                    onTap: () => onItemTapped(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.more_horiz_outlined,
                          color: currentIndex == 3 ? Colors.blue : Colors.black,
                          size: 45.0,
                        ),
                        Text(
                          'Miscellaneous',
                          style: TextStyle(
                            color:
                                currentIndex == 3 ? Colors.blue : Colors.black,
                            fontSize: 16.0,
                            fontWeight: currentIndex == 3
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
              left: MediaQuery.of(context).size.width / 2 - 80,
              child: GestureDetector(
                onTap: () => onItemTapped(4),
                child: Container(
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
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: currentIndex == 4 ? Colors.white : Colors.black,
                    size: 60.0,
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
