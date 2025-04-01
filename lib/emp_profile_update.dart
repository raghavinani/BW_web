import 'package:flutter/material.dart';
import 'package:login/custom_app_bar/profile_sidebar.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';
import 'package:login/content.dart';

void main() {
  runApp(const EmployeeProfileUpdation());
}

class EmployeeProfileUpdation extends StatelessWidget {
  const EmployeeProfileUpdation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EmployeeProfileUpdationPage(),
    );
  }
}

class EmployeeProfileUpdationPage extends StatefulWidget {
  const EmployeeProfileUpdationPage({super.key});

  @override
  State<EmployeeProfileUpdationPage> createState() =>
      _EmployeeProfileUpdationPageState();
}

class _EmployeeProfileUpdationPageState
    extends State<EmployeeProfileUpdationPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 1080;
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomSidebar(),
      endDrawer: const ProfileSidebar(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 112, 183, 1), // Background color
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ContentPage()),
                      );
                    }
                  },
                ),
                const SizedBox(width: 8), // Spacing between icon and text
                const Text(
                  'Empl. Profile Updation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text color
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          // The form below will be scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildForm(),
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Form Submitted Successfully!')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text('Submit',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16.0)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Keeps content compact
              children: [
                CircleAvatar(
                  radius: 24, // Adjust size as needed
                  backgroundImage: AssetImage('assets/profile_image.png'),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Raghav Inani',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(50, 50, 50, 1), // Slightly darkened
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'raghav.inani-mt@adityabirla.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54, // Lighter shade
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          // _buildDropdownField('Process Type*', ['Add', 'Update']),
          // _buildDropdownField(
          //     'Retailer Category*', ['Urban', 'Rural', 'Direct Dealer']),
          // _buildDropdownField('Area*', ['Rajasthan', 'Maharashtra']),
          // _buildDropdownField('District*', ['Jaipur', 'Mumbai']),
          _buildTextField('Internal Phone No Off'),
          _buildTextField('Internal Phone No Resi'),
          _buildTextField('External Phone No Off'),
          _buildTextField('External Phone No Resi'),
          _buildTextField('Mobile Number*'),
          _buildTextField('Spouse Mobile Number'),
          // _buildTextField('Firm Name*'),
          // _buildTextField('Mobile*'),
          // _buildTextField('Office Telephone'),
          // _buildTextField('Email'),
          // _buildTextField('Address 1*'),
          // _buildTextField('Address 2'),
          // _buildTextField('Address 3'),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        SizedBox(
          height: 40,
          child: TextFormField(
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (label.endsWith('*') && (value == null || value.isEmpty)) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2),
        SizedBox(
          height: 40,
          child: DropdownButtonFormField<String>(
            style: const TextStyle(fontSize: 12, color: Colors.black),
            dropdownColor: Colors.white,
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black)),
                    ))
                .toList(),
            onChanged: (value) {},
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 8), // Removes default padding
              // isDense: true, // Reduces height
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (label.endsWith('*') && value == null) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildPredefinedField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2),
        SizedBox(
          height: 40,
          child: TextFormField(
            initialValue: value,
            enabled: false,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
