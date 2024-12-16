import 'package:flutter/material.dart';
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
            fit: BoxFit.fitWidth, // Makes the logo wider
            width: 500, // Set a fixed width to make it wider
            height: kToolbarHeight,
          ),
        ),
      ),
      title: screenWidth > 800
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDropdownMenu(context, 'Transactions', _transactionLinks),
                _buildDropdownMenu(context, 'Reports', _reportLinks),
                _buildDropdownMenu(context, 'Masters', _masterLinks),
                _buildDropdownMenu(context, 'Miscellaneous', _miscLinks),
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
            _showSidebar(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue),
          ),
          onSelected: (value) {
            if (value == 'Home') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContentPage()),
              );
            } else if (value == 'Logout') {
              // Handle logout logic
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'Home',
              child: Text('Home'),
            ),
            const PopupMenuItem(
              value: 'Logout',
              child: Text('Logout'),
            ),
          ],
        ),
      ],
    );
  }

  void _showSidebar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: const Color.fromARGB(255, 46, 112, 226),
          child: ListView(
            children: [
              _buildSidebarMenu(context, 'Transactions', _transactionLinks),
              _buildSidebarMenu(context, 'Reports', _reportLinks),
              _buildSidebarMenu(context, 'Masters', _masterLinks),
              _buildSidebarMenu(context, 'Miscellaneous', _miscLinks),
            ],
          ),
        );
      },
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

  Widget _buildSidebarMenu(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> links,
  ) {
    return ExpansionTile(
      title: Padding(
        padding:
            const EdgeInsets.only(left: 16.0), // Shift the title slightly right
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white, // Set the title color to black
            fontWeight: FontWeight.bold, // Bold the title
          ),
        ),
      ),
      children: links.map<Widget>((link) {
        return _buildSubMenu(context, link);
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

final _transactionLinks = [
  {
    'title': 'Financial Accounts',
    'subLinks': [
      'Token Scan',
      'Balance Confirmation',
      'Invoice Acknowledgement',
      'Ever White Coupon Generation',
      '194Q Detail Entry',
      'Token Scan Details',
      'Token Scan Report',
      'Token Scan New',
    ],
  },
  {
    'title': 'Depot Order',
    'subLinks': [
      'Secondary Sale Capture',
      'Order Update',
      'Order Entry',
    ],
  },
  {
    'title': 'Retailer',
    'subLinks': [
      'Rural Retailer Entry/Update',
      'Retailer Registration',
    ],
  },
  {
    'title': 'Sales Force',
    'subLinks': [
      'Notification Sent Details',
      'User Rating',
    ],
  },
  {
    'title': 'Mission Udaan',
    'subLinks': [
      'Invoice Cancellation in Bulk',
      'Secondary Sales Invoice Entry',
    ],
  },
];

final _reportLinks = [
  {
    'title': 'SAP Reports',
    'subLinks': [
      'Day Summary',
      'Day wise Details',
      'Day Summary Qty/Value Wise',
      'Sales-Purchase-wise Packaging-wise',
      'Year on Year Comparison',
    ],
  },
  {
    'title': 'General Reports',
    'subLinks': [
      'Pending freight report',
      'Account statement',
      'Contact us',
      'Information document',
    ],
  },
  {
    'title': 'MIS Reports',
    'subLinks': [
      'Purchaser aging report (SAP)',
    ],
  },
  {
    'title': 'Sales Reports',
    'subLinks': [
      'Product catg-wise sales',
      'Sales growth overview YTD/MTD',
    ],
  },
  {
    'title': 'Scheme/Discount',
    'subLinks': [
      'Purchaser and retailer disbursement details',
      'RPL Outlet tracker',
      'Scheme Disbursement View',
    ],
  },
  {
    'title': 'Retailer',
    'subLinks': [
      'Retailer report',
      'Retailer KYC details',
    ],
  },
  {
    'title': 'Chart Reports',
    'subLinks': [
      'Sales overview',
    ],
  },
  {
    'title': 'Mobile Reports',
    'subLinks': [
      'Purchaser 360',
    ],
  },
  {
    'title': 'Secondary Sale',
    'subLinks': [
      'Stock & RollOut data (Tally)',
      'Secondary Sale (Tally)',
      'Stock Data (Tally)',
      'Retailers Sales Report',
      'Retailer Target Vs Actual',
      'My Network',
      'Tally Data Customer Wise',
    ]
  },
  {
    'title': 'Scheme Details',
    'subLinks': [
      'Schemes Summary',
    ]
  },
];

final _masterLinks = [
  {
    'title': 'Customer',
    'subLinks': [
      'Purchaser Profile',
      'TAN No Update',
      'SAP Invoice Printing',
    ],
  },
  {
    'title': 'Misc Master',
    'subLinks': [
      'Pin Code Master',
      'Profile Photo',
    ],
  },
  {
    'title': 'Credit Note',
    'subLinks': [
      'Guarantor Orc Entry',
      'Guarantor Orc View',
    ],
  },
];

final _miscLinks = [
  {'title': 'Change Password'},
  {'title': 'Software Download'},
  {'title': 'Photo Gallery'},
  {'title': 'SMS Query Code Help'},
];
