import 'package:flutter/material.dart';
import 'package:login/RetailerEntry.dart';
import 'package:login/custom_app_bar/profile_sidebar.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';
import 'package:login/carousel.dart';
import 'package:login/bottom_nav_bar_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:login/view_orders.dart';
import 'package:login/loginBanner.dart';
import 'package:login/DSR.dart';
import 'package:login/sales_summary.dart';

void main() {
  runApp(const ContentPage());
}

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android
          ? const HomeMobile()
          : const HomePage(),
    );
  }
}

class AppConfig {
  static const double smallScreenBreakpoint = 800.0;
  static const double boxPadding = 4.0;
  static const double borderRadius = 8.0;
  static const double shadowBlurRadius = 6.0;
  static const double shadowSpreadRadius = 2.0;
  static const Color boxBackgroundColor = Colors.white;
  static const Color boxShadowColor = Colors.black26;
  static const Color borderColor = Colors.grey;
  static const double titleFontSize = 18.0;
  static const double valueFontSize = 12.0;
  static const Map<String, List<String>> boxContents = {
    'Credit Limit': ['Credit Limit: 0', 'Open Billing: 0', 'Open Order: 0'],
    'Primary Sale': [
      'WC: 0',
      'WCP: 0',
      'VAP: 0',
      'Primer: 0',
      'Water Proofing Compound: 0',
      'Distemper: 0'
    ],
    'Secondary Sale': [
      'WC: 0',
      'WCP: 0',
      'VAP: 0',
      'Primer: 0',
      'Water Proofing Compound: 0',
      'Distemper: 0'
    ],
    'My Network': [
      'Total Unique Billed: 0',
      'WC: 0',
      'WCP: 0',
      'VAP: 0',
      'Primer: 0',
      'Water Proofing Compound: 0',
      'Distemper: 0'
    ],
  };
}

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeBase(
      isMobile: true,
      quickMenuItems: _quickMenuItems,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeBase(
      isMobile: false,
      quickMenuItems: _quickMenuItems,
    );
  }
}

class HomeBase extends StatelessWidget {
  final bool isMobile;
  final List<Map<String, dynamic>> quickMenuItems;

  const HomeBase({
    required this.isMobile,
    required this.quickMenuItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < AppConfig.smallScreenBreakpoint;

    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(),
      drawer: CustomSidebar(),
      endDrawer: const ProfileSidebar(),
      body: Stack(
        children: [
          // Main content
          Container(
            color: AppConfig.boxBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppConfig.boxPadding * 2,
                              horizontal: AppConfig.boxPadding),
                          child: const CustomCarousel(),
                        ),
                        _buildQuickMenu(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppConfig.boxPadding * 2,
                              horizontal: AppConfig.boxPadding),
                          child: _buildBoxesLayout(isMobile, isSmallScreen,
                              screenWidth, screenHeight),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Banner Overlay
          const LoginBanner(),

          // Floating Bottom Navigation Bar
          if (isMobile)
            Positioned(
              left: 20.0,
              right: 20.0,
              bottom: 10.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Container(
                  color:
                      Colors.transparent, // Ensure no background blocks content
                  child: CustomBottomNavigationBar(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBoxesLayout(bool isMobile, bool isSmallScreen,
      double screenWidth, double screenHeight) {
    final boxWidgets = AppConfig.boxContents.entries
        .map((entry) => _buildBox(
              title: entry.key,
              values: entry.value,
              width: isMobile || isSmallScreen
                  ? screenWidth - (AppConfig.boxPadding * 2)
                  : (screenWidth / 4) - (AppConfig.boxPadding * 2),
            ))
        .toList();

    if (isMobile || isSmallScreen) {
      return Column(children: boxWidgets);
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          // Find max height of all boxes
          double maxHeight = 0;
          List<GlobalKey> boxKeys =
              List.generate(boxWidgets.length, (_) => GlobalKey());

          return FutureBuilder(
            future: Future.delayed(Duration.zero, () {
              maxHeight = boxKeys
                  .map((key) => key.currentContext?.size?.height ?? 0)
                  .reduce((a, b) => a > b ? a : b);
              return maxHeight;
            }),
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(boxWidgets.length, (index) {
                  return Container(
                    key: boxKeys[index],
                    constraints:
                        BoxConstraints(minHeight: snapshot.data ?? 200),
                    child: boxWidgets[index],
                  );
                }),
              );
            },
          );
        },
      );
    }
  }

  Widget _buildBox({
    required String title,
    required List<String> values,
    required double width,
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: AppConfig.boxPadding),
      decoration: BoxDecoration(
        color: AppConfig.boxBackgroundColor,
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppConfig.boxShadowColor,
            blurRadius: AppConfig.shadowBlurRadius,
            spreadRadius: AppConfig.shadowSpreadRadius,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConfig.boxPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: AppConfig.titleFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
          const SizedBox(height: 8),

          // Graph positioned below title
          Center(
            child: Image.asset(
              'assets/graph.png',
              width: 200, // Set square aspect ratio
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),

          // Information positioned below the graph
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: values.map((value) {
              final valueParts = value.split(':');
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.remove, size: 16, color: Colors.blueGrey),
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 2,
                      child: Text(
                        valueParts[0].trim(),
                        style: const TextStyle(
                          fontSize: AppConfig.valueFontSize,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Text(
                        valueParts[1].trim(),
                        style: const TextStyle(
                          fontSize: AppConfig.valueFontSize,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenu() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Ensures it takes only needed height
        children: [
          const Text(
            'Quick Menu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true, // Takes only required space
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.2, // Adjust as needed
              ),
              itemCount: quickMenuItems.length,
              itemBuilder: (context, index) {
                final item = quickMenuItems[index];
                return GestureDetector(
                  onTap: () => _handleQuickMenuItemTap(context, item['label']),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 21,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['label'].replaceAll(' ', '\n'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleQuickMenuItemTap(BuildContext context, String label) {
    if (label == 'Retailer Registration') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RetailerRegistrationApp()),
      );
    } else if (label == 'Order History') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ManageOrderPage()),
      );
    } else if (label == 'DSR') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DSR()),
      );
    } else if (label == 'Sales Summary') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SalesSummaryPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label clicked')),
      );
    }
  }
}

final List<Map<String, dynamic>> _quickMenuItems = [
  {'icon': Icons.app_registration, 'label': 'Retailer Registration'},
  {'icon': Icons.history, 'label': 'Order History'},
  {'icon': Icons.bar_chart, 'label': 'DSR'},
  {'icon': Icons.inventory, 'label': 'Inventory'},
  {'icon': Icons.settings, 'label': 'Settings'},
  {'icon': Icons.summarize_outlined, 'label': 'Sales Summary'},
  {'icon': Icons.support_agent, 'label': 'Customer Support'},
  {'icon': Icons.analytics, 'label': 'Analytics'},
  {'icon': Icons.campaign, 'label': 'Promotions'},
  {'icon': Icons.account_circle, 'label': 'Account Management'},
  {'icon': Icons.local_shipping, 'label': 'Delivery Status'},
  {'icon': Icons.feedback, 'label': 'Feedback'},
];
