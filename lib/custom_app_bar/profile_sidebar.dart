import 'package:flutter/material.dart';
import 'package:login/aadhar_kyc.dart';
import 'package:login/content.dart';
import 'package:login/emp_profile_update.dart';
import 'package:login/view_orders.dart';
// import 'app_links.dart';
// import 'package:login/RetailerEntry.dart';
// import 'package:login/QR_scanner.dart';
// import 'package:login/order_update.dart';
// import 'package:login/order_entry.dart';

class ProfileSidebar extends StatefulWidget {
  const ProfileSidebar({super.key});

  @override
  State<ProfileSidebar> createState() => _ProfileSidebarState();
}

class _ProfileSidebarState extends State<ProfileSidebar> {
  // Track expanded sections
  Map<String, bool> expandedSections = {
    'Transactions': false,
    'Reports': false,
    'Masters': false,
    'Miscellaneous': false,
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * (5 / 7),
            height: MediaQuery.of(context).size.height,
            child: Drawer(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
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
                      padding: const EdgeInsets.only(top: 2.0, left: 2),
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 21),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Section
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, bottom: 8, left: 4),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage('assets/profile_image.png'),
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Raghav Inani',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        '7340031941',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Sidebar Menu Items
                            _buildMenuItem(
                              context,
                              icon: Icons.dashboard,
                              label: 'Dashboard',
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ContentPage(),
                                  ),
                                );
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
                                    builder: (context) =>
                                        const ManageOrderPage(),
                                  ),
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
                                    builder: (context) =>
                                        const AadharCardKYCPage(),
                                  ),
                                );
                              },
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.person_2_outlined,
                              label: 'Employee Profile Updation',
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmployeeProfileUpdation(),
                                  ),
                                );
                              },
                            ),
                            // // Collapsible Menus
                            // _buildCollapsibleMenu('Transactions',
                            //     transactionLinks, Icons.receipt_long),
                            // _buildCollapsibleMenu(
                            //     'Reports', reportLinks, Icons.insert_chart),
                            // _buildCollapsibleMenu('Masters', masterLinks,
                            //     Icons.settings_applications),
                            // _buildCollapsibleMenu(
                            //     'Miscellaneous', miscLinks, Icons.more_horiz),

                            _buildMenuItem(
                              context,
                              icon: Icons.settings,
                              label: 'Settings',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Settings Clicked')),
                                );
                              },
                            ),
                            _buildMenuItem(
                              context,
                              icon: Icons.logout,
                              label: 'Log Out',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Log Out Clicked')),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

//   Widget _buildCollapsibleMenu(
//       String title, List<Map<String, dynamic>> links, IconData icon) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               expandedSections[title] = !expandedSections[title]!;
//             });
//           },
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//             child: Row(
//               children: [
//                 Icon(icon, color: Colors.white, size: 20),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   expandedSections[title]!
//                       ? Icons.expand_less
//                       : Icons.expand_more,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (expandedSections[title]!)
//           Column(
//             children:
//                 links.map((link) => _buildSubMenuItem(context, link)).toList(),
//           ),
//       ],
//     );
//   }

//   Widget _buildSubMenuItem(BuildContext context, Map<String, dynamic> link) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//           vertical: 2.0), // Space between submenu items
//       child: PopupMenuButton<String>(
//         offset: const Offset(-5, 0), // Adjust dropdown position
//         child: Padding(
//           padding: const EdgeInsets.only(
//               left: 20.0), // Shift submenu items slightly right
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 link['title'],
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12, // Font size increased 1.5x
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(right: 10.0),
//                 child: Icon(Icons.arrow_right, size: 10),
//               ),
//             ],
//           ),
//         ),
//         onSelected: (value) {
//           if (value == 'Rural Retailer Entry/Update') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const RetailerRegistrationPage()),
//             );
//           } else if (value == 'Token Scan') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const QrCodeScanner()),
//             );
//           } else if (value == 'Order Update') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const OrderUpdate()),
//             );
//           } else if (value == 'Order Entry') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const OrderEntry()),
//             );
//           } else {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text('$value clicked')));
//           }
//         },
//         itemBuilder: (context) => link['subLinks']
//             .map<PopupMenuItem<String>>(
//               (subLink) => PopupMenuItem<String>(
//                 value: subLink,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 1.5), // Padding between sublinks
//                   child: Text(
//                     '• $subLink',
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w300,
//                         fontSize: 12.0,
//                         color: Color.fromARGB(255, 2, 27, 48)),
//                   ),
//                 ),
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
}
