import 'package:flutter/material.dart';
import 'package:login/aadhar_kyc.dart';
import 'package:login/view_orders.dart';

class ProfileSidebar extends StatelessWidget {
  final Widget mainPage;

  const ProfileSidebar({super.key, required this.mainPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content area (takes the full screen)
          Positioned.fill(
            child: mainPage,
          ),
          // Sidebar (Drawer) covering part of the screen
          Positioned(
            right: 0, // Align sidebar to the right
            top: MediaQuery.of(context).size.height * 0.05,
            bottom: MediaQuery.of(context).size.height * 0, // Offset
            child: Container(
              width: MediaQuery.of(context).size.width * (6 / 7),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.blue, // Sidebar background color
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
                  const Spacer(),
                  // My Points section
                  const PointsWidget(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
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

// PointsWidget as per your code
class PointsWidget extends StatefulWidget {
  const PointsWidget({super.key});

  @override
  _PointsWidgetState createState() => _PointsWidgetState();
}

class _PointsWidgetState extends State<PointsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    final coins = 1354356;
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: coins).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF003366), // Dark Blue
            Color(0xFF0073e6), // Light Blue
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.monetization_on, color: Colors.white, size: 48),
          const SizedBox(width: 24),
          Flexible(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Text(
                  'My Points: ${_animation.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
