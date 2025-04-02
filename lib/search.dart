import 'package:flutter/material.dart';
import 'package:login/custom_app_bar/app_links.dart';
import 'package:login/RetailerEntry.dart';
import 'package:login/token_scan.dart';
import 'package:login/order_entry.dart';
import 'package:login/order_update.dart';
import 'package:login/sales_summary.dart';
import 'package:login/view_orders.dart';
import 'package:login/DSR.dart';
import 'package:login/token_summary.dart';
import 'package:login/token_details.dart';
import 'package:login/token_report.dart';

class SearchBarWidget extends StatefulWidget {
  SearchBarWidget({super.key});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];
  OverlayEntry? _overlayEntry;

  final List<String> _allSearchItems = {
    ...transactionLinks.expand((e) => e['subLinks'] as List<String>),
    ...reportLinks.expand((e) => e['subLinks'] as List<String>),
    ...masterLinks.expand((e) => e['subLinks'] as List<String>),
    ...miscLinks.map((e) => e['title'] as String),
    ...[
      'Retailer Registration',
      'Order History',
      'Sales Report',
      'Inventory',
      'Settings',
      'Help Center',
      'Customer Support',
      'Analytics',
      'Promotions',
      'Account Management',
      'Delivery Status',
      'Feedback',
      'DSR'
    ],
  }.toList(); // Convert back to List to preserve ordering

  void _handleNavigation(String value) {
    _removeOverlay(); // Close dropdown
    if (value == 'Retailer Registration') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RetailerRegistrationApp()),
      );
    } else if (value == 'Order History') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ManageOrderPage()),
      );
    } else if (value == 'Token Scan') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TokenScanApp()),
      );
    } else if (value == 'Token Scan Report') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TokenReportScreen()),
      );
    } else if (value == 'Token Scan Details') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TokenDetailsPage()),
      );
    } else if (value == 'Token Scan Summary') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TokenSummaryScreen()),
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
    } else if (value == 'Sales Report') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SalesSummaryPage()),
      );
    } else if (value == 'DSR') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DSR()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$value clicked')),
      );
    }
    _searchController.clear();
  }

  void _onSearchChanged(String query) {
    if (query.length >= 3) {
      _filteredItems = _allSearchItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay(); // Remove previous overlay if exists

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + renderBox.size.height + 5,
        width: renderBox.size.width,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(
                maxHeight: 200), // Fixed height for scrolling
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            child: ClipRRect(
              // Ensures rounded corners for scrolling
              borderRadius: BorderRadius.circular(10),
              child: Scrollbar(
                // Adds scrollbar for better UX
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_filteredItems[index]),
                      onTap: () => _handleNavigation(_filteredItems[index]),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextField(
        controller: _searchController,
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 16, color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search for reports, orders, etc.',
          hintStyle: TextStyle(color: Colors.black.withOpacity(.40)),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 25,
                width: 1.5,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 2),
              ),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner,
                    size: 20, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}
