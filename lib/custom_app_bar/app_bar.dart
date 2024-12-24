import 'package:flutter/material.dart';
import 'package:login/QR_scanner.dart';
import 'app_links.dart';
import 'package:login/profile_page.dart';
import 'package:login/RetailerEntry.dart';
import 'package:login/content.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: Colors.blueAccent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContentPage()),
            );
          },
          child: Image.asset(
            'assets/logo.jpeg',
            fit: BoxFit.fitWidth,
            width: 500,
            height: kToolbarHeight,
          ),
        ),
      ),
      title: screenWidth > 800
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDropdownMenu(context, 'Transactions', transactionLinks),
                _buildDropdownMenu(context, 'Reports', reportLinks),
                _buildDropdownMenu(context, 'Masters', masterLinks),
                _buildDropdownMenu(context, 'Miscellaneous', miscLinks),
              ],
            )
          : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.list, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); // Open right sidebar
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
      ],
    );
  }

  // void _openSidebar(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) => const CustomSidebar(),
  //   );
  // }

  Widget _buildDropdownMenu(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> links,
  ) {
    return PopupMenuButton<String>(
      tooltip: title,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
      offset: const Offset(150, 0), // Adjust the dropdown position to the right
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
              padding: const EdgeInsets.only(
                  right:
                      30.0), // Adjust the arrow position slightly to the left
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
  Size get preferredSize => const Size.fromHeight(70);
}
