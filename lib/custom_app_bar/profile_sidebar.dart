import 'package:flutter/material.dart';
import 'package:login/aadhar_kyc.dart';
import 'package:login/view_orders.dart';

class ProfileSidebar extends StatelessWidget {
  const ProfileSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0, // Align sidebar to the right
          top: MediaQuery.of(context).size.height * 0.05,
          bottom: MediaQuery.of(context).size.height * 0, // Offset
          child: SizedBox(
            width: MediaQuery.of(context).size.width * (5 / 7),
            height: MediaQuery.of(context).size.height,
            child: Drawer(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent, // Sidebar background color
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36.0),
                    bottomLeft: Radius.circular(36.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(4, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close button
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, left: 24.0, bottom: 24),
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 48),
                        onPressed: () {
                          Navigator.pop(context); // Close the sidebar
                        },
                      ),
                    ),
                    // Profile section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 60, // Larger avatar
                            backgroundImage:
                                AssetImage('assets/profile_image.png'),
                          ),
                          const SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Raghav Inani',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '7340031941',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Divider
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Divider(color: Colors.white, thickness: 0.8),
                    ),
                    // Menu items
                    _buildMenuItem(
                      context,
                      icon: Icons.dashboard,
                      label: 'Dashboard',
                      onTap: () {
                        Navigator.pop(context); // Close the sidebar
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.shopping_bag,
                      label: 'Manage Orders',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManageOrderPage()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.vpn_key,
                      label: 'KYC Details',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AadharCardKYCPage()),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Divider(color: Colors.white, thickness: 0.8),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Settings Clicked')),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.logout,
                      label: 'Log Out',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Log Out Clicked')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 18.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 42), // Larger icon
            const SizedBox(width: 24),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32, // Larger text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
