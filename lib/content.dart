import 'package:flutter/material.dart';
import 'package:login/RetailerEntry.dart';
import 'package:login/custom_app_bar/profile_sidebar.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';
import 'package:login/carousel.dart';
import 'package:login/bottom_nav_bar_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:login/view_orders.dart';
import 'package:login/search.dart' as search;

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
  static const double boxPadding = 16.0;
  static const double borderRadius = 8.0;
  static const double shadowBlurRadius = 6.0;
  static const double shadowSpreadRadius = 2.0;
  static const Color boxBackgroundColor = Colors.white;
  static const Color boxShadowColor = Colors.black26;
  static const Color borderColor = Colors.grey;
  static const double titleFontSize = 24.0;
  static const double valueFontSize = 18.0;
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
            color: Colors.grey.shade300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const search.SearchBar(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: AppConfig.boxPadding),
                          child: const CustomCarousel(),
                        ),
                        _buildHorizontalQuickMenu(),
                        Padding(
                          padding: const EdgeInsets.all(AppConfig.boxPadding),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConfig.boxPadding),
      color: Colors.blue.shade50,
      child: const Center(
        child: Text(
          'Birla White',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildBoxesLayout(bool isMobile, bool isSmallScreen,
      double screenWidth, double screenHeight) {
    final boxContents = AppConfig.boxContents.entries.map((entry) => _buildBox(
          title: entry.key,
          values: entry.value,
          width: isMobile || isSmallScreen
              ? screenWidth
              : (screenWidth / 4) - (AppConfig.boxPadding * 2),
        ));
    return isMobile || isSmallScreen
        ? Column(children: boxContents.toList())
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: boxContents.toList());
  }

  Widget _buildBox({
    required String title,
    required List<String> values,
    required double width,
  }) {
    return Container(
      width: width,
      // height: height,
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
          const SizedBox(height: 16),
          // Graph and Information Layout (Horizontal Row)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Graph on the left side (using an image from assets)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Image.asset(
                  'assets/graph.png',
                  width: 300,
                  height: 200,
                ),
              ),
              const SizedBox(width: 30),
              // Information on the right side (values list)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: values.map((value) {
                      final valueParts = value.split(':');
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.remove,
                                size: 16, color: Colors.blueGrey),
                            const SizedBox(width: 8),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalQuickMenu() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Menu',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 156,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: quickMenuItems.length,
              itemBuilder: (context, index) {
                final item = quickMenuItems[index];
                return GestureDetector(
                  onTap: () => _handleQuickMenuItemTap(context, item['label']),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4.0,
                              spreadRadius: 2.0,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          size: 42,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['label'].replaceAll(' ', '\n') as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
  {'icon': Icons.bar_chart, 'label': 'Sales Report'},
  {'icon': Icons.inventory, 'label': 'Inventory'},
  {'icon': Icons.settings, 'label': 'Settings'},
  {'icon': Icons.help, 'label': 'Help Center'},
  {'icon': Icons.support_agent, 'label': 'Customer Support'},
  {'icon': Icons.analytics, 'label': 'Analytics'},
  {'icon': Icons.campaign, 'label': 'Promotions'},
  {'icon': Icons.account_circle, 'label': 'Account Management'},
  {'icon': Icons.local_shipping, 'label': 'Delivery Status'},
  {'icon': Icons.feedback, 'label': 'Feedback'},
];
