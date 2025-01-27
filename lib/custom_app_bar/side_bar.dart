import 'package:flutter/material.dart';
import 'app_links.dart';
import 'package:login/RetailerEntry.dart';
import 'package:login/QR_scanner.dart';
import 'package:login/order_update.dart';
import 'package:login/order_entry.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.01, // Offset from the top
          bottom: MediaQuery.of(context).size.height *
              0.01, // Offset from the bottom
          left: 0, // Align to the left
          child: SizedBox(
            width: screenWidth * 0.4, // Set width to 40% of the screen width
            child: Drawer(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 76, 188, 244),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50), // Rounded top-right corner
                    bottomRight:
                        Radius.circular(50), // Rounded bottom-right corner
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListView(
                  children: [
                    Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 65, 128, 239),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24 * 1.5, // Font size increased 1.5x
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 16.0), // Space between header and first menu
                    _buildSidebarMenu(
                        context, 'Transactions', transactionLinks),
                    const SizedBox(height: 16.0), // Space between menus
                    _buildSidebarMenu(context, 'Reports', reportLinks),
                    const SizedBox(height: 16.0),
                    _buildSidebarMenu(context, 'Masters', masterLinks),
                    const SizedBox(height: 16.0),
                    _buildSidebarMenu(context, 'Miscellaneous', miscLinks),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarMenu(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> links,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 12.0), // Add padding for the menu
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.only(
              left: 16.0), // Shift the title slightly right
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16 * 1.5, // Font size increased 1.5x
            ),
          ),
        ),
        children: links.map<Widget>((link) {
          return _buildSubMenu(context, link);
        }).toList(),
      ),
    );
  }

  Widget _buildSubMenu(BuildContext context, Map<String, dynamic> link) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Space between submenu items
      child: PopupMenuButton<String>(
        offset: const Offset(150, 0), // Adjust dropdown position
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30.0), // Shift submenu items slightly right
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                link['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14 * 1.5, // Font size increased 1.5x
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 30.0),
                child: Icon(Icons.arrow_right, size: 16),
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
            .map<PopupMenuItem<String>>(
              (subLink) => PopupMenuItem<String>(
                value: subLink,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0), // Padding between sublinks
                  child: Text(
                    '• $subLink',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
