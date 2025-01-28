import 'package:flutter/material.dart';
import 'package:login/QR_scanner.dart';
import 'package:login/order_entry.dart';
import 'app_links.dart';
import 'package:login/profile_page.dart';
import 'package:login/RetailerEntry.dart';
import 'package:login/content.dart';
import 'package:login/order_update.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final VoidCallback onOpenFirstEndDrawer;
  // final VoidCallback onOpenSecondEndDrawer;

  const CustomAppBar({
    super.key,
    // required this.onOpenFirstEndDrawer,
    // required this.onOpenSecondEndDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[800]!, // Dark Blue
              Colors.blueAccent, // Light Blue / BlueAccent
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      toolbarHeight: 100,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContentPage()),
                );
              },
              child: Image.asset(
                'assets/logo.jpeg',
                height: 80,
                width: 150, // Adjust to make the logo larger
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (screenWidth > 1080)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center the dropdowns
                children: [
                  _buildDropdownMenu(context, 'Transactions', transactionLinks),
                  _buildDropdownMenu(context, 'Reports', reportLinks),
                  _buildDropdownMenu(context, 'Masters', masterLinks),
                  _buildDropdownMenu(context, 'Miscellaneous', miscLinks),
                ],
              ),
            ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            iconSize: 42,
            icon: const Icon(Icons.list, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open right sidebar
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            iconSize: 42,
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 8.0),
          child: IconButton(
            iconSize: 60,
            icon: const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/profile_image.png'),
            ),
            onPressed: () {
              final isMobile =
                  Theme.of(context).platform == TargetPlatform.iOS ||
                      Theme.of(context).platform == TargetPlatform.android;

              if (isMobile) {
                Scaffold.of(context).openEndDrawer();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownMenu(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> links,
  ) {
    return PopupMenuButton<String>(
      tooltip: title,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add spacing
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      onSelected: (value) {
        if (value == 'Rural Retailer Entry/Update') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RetailerRegistrationApp()),
          );
        } else if (value == 'Token Scan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QrCodeScanner()),
          );
        } else if (value == 'Order Update') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderUpdate()),
          );
        } else if (value == 'Order Entry') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderEntry()),
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$value clicked')));
        }
      },
      itemBuilder: (context) => links.map((link) {
        return PopupMenuItem<String>(
          value: link['title'],
          child: link['subLinks'] != null
              ? _buildSubMenu(context, link)
              : Text(link['title']),
        );
      }).toList(),
    );
  }

  Widget _buildSubMenu(BuildContext context, Map<String, dynamic> link) {
    return PopupMenuButton<String>(
      offset: const Offset(200, 0), // Adjust the dropdown position to the right
      child: Padding(
        padding: const EdgeInsets.only(
            left: 30.0), // Shift submenu items slightly right
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              link['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold, // Make the title bold
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: const Icon(Icons.arrow_right, size: 16),
            ),
          ],
        ),
      ),
      onSelected: (value) {
        if (value == 'Rural Retailer Entry/Update') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RetailerRegistrationPage()),
          );
        } else if (value == 'Token Scan') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QrCodeScanner()),
          );
        } else if (value == 'Order Update') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderUpdate()),
          );
        } else if (value == 'Order Entry') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderEntry()),
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$value clicked')));
        }
      },
      itemBuilder: (context) => link['subLinks']
          .map<PopupMenuItem<String>>((subLink) => PopupMenuItem<String>(
                value: subLink,
                child: Text('• $subLink'),
              ))
          .toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
