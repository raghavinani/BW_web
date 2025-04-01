import 'dart:io' as io; // For mobile file handling
import 'dart:typed_data'; // For web file handling
import 'package:flutter/foundation.dart'; // To check platform
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:login/custom_app_bar/profile_sidebar.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';
import 'package:login/content.dart';

void main() {
  runApp(const RetailerRegistrationApp());
}

class RetailerRegistrationApp extends StatelessWidget {
  const RetailerRegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RetailerRegistrationPage(),
    );
  }
}

class RetailerRegistrationPage extends StatefulWidget {
  const RetailerRegistrationPage({super.key});

  @override
  State<RetailerRegistrationPage> createState() =>
      _RetailerRegistrationPageState();
}

class _RetailerRegistrationPageState extends State<RetailerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedOption;

  String? _uploadedFileName;
  Uint8List? _fileBytes; // For web
  String? _filePath; // For mobile

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true, // Required for web
      withReadStream: false, // Optional for large files
    );

    if (result != null) {
      setState(() {
        _uploadedFileName = result.files.single.name;
        if (kIsWeb) {
          // For web, use bytes
          _fileBytes = result.files.single.bytes;
        } else {
          // For mobile, use file path
          _filePath = result.files.single.path;
        }
      });
    }
  }

  void _viewFile() {
    if (kIsWeb) {
      // Web: Display file from bytes
      if (_fileBytes != null) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: 300,
              height: 400,
              child: _uploadedFileName!.endsWith('.jpg') ||
                      _uploadedFileName!.endsWith('.png') ||
                      _uploadedFileName!.endsWith('.jpeg')
                  ? Image.memory(
                      _fileBytes!,
                      fit: BoxFit.fill,
                    )
                  : Center(
                      child: const Text(
                        'Cannot preview this file type.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
            ),
          ),
        );
      }
    } else {
      // Mobile: Display file from path
      if (_filePath != null) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: 300,
              height: 500,
              child: _filePath!.endsWith('.jpg') ||
                      _filePath!.endsWith('.png') ||
                      _filePath!.endsWith('.jpeg')
                  ? Image.file(
                      io.File(_filePath!),
                      fit: BoxFit.fill,
                    )
                  : Center(
                      child: const Text(
                        'Cannot preview this file type.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
            ),
          ),
        );
      }
    }
  }

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
                  'Retailer Registration',
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
                    isWideScreen
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildBasicDetailsForm()),
                              const SizedBox(width: 8.0),
                              Expanded(child: _buildContactDetailsForm()),
                            ],
                          )
                        : Column(
                            children: [
                              _buildBasicDetailsForm(),
                              const SizedBox(height: 16.0),
                              _buildContactDetailsForm(),
                            ],
                          ),
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

  Widget _buildBasicDetailsForm() {
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
          const Text(
            'Basic Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 112, 183, 1),
            ),
          ),
          const SizedBox(height: 8.0),
          _buildDropdownField('Process Type*', ['Add', 'Update']),
          _buildDropdownField(
              'Retailer Category*', ['Urban', 'Rural', 'Direct Dealer']),
          _buildDropdownField('Area*', ['Rajasthan', 'Maharashtra']),
          _buildDropdownField('District*', ['Jaipur', 'Mumbai']),
          _buildClickableOptions('Register With PAN/GST*', ['GST', 'PAN']),
          _buildTextField('GST Number*'),
          _buildTextField('PAN Number*'),
          _buildTextField('Firm Name*'),
          _buildTextField('Mobile*'),
          _buildTextField('Office Telephone'),
          _buildTextField('Email'),
          _buildTextField('Address 1*'),
          _buildTextField('Address 2'),
          _buildTextField('Address 3'),
        ],
      ),
    );
  }

  Widget _buildContactDetailsForm() {
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
          const Text(
            'Contact Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 112, 183, 1),
            ),
          ),
          const SizedBox(height: 8.0),
          _buildPredefinedField('Stockist Code*', '4401S711'),
          _buildTextField('Tally Retailer Code'),
          _buildTextField('Concern Employee*'),
          _buildUploadField('Retailer Profile Image'),
          _buildUploadField('PAN / GST No Image Upload / View'),
          _buildDropdownField('Scheme Required*', ['Yes', 'No']),
          _buildTextField('Aadhar Card No*'),
          _buildUploadField('Aadhar Card Upload'),
          _buildTextField('Proprietor / Partner Name*'),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40, // Increased height for better visibility
          child: TextFormField(
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              labelText: label, // Label inside the field
              labelStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              floatingLabelBehavior:
                  FloatingLabelBehavior.auto, // Moves label above when typing
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        SizedBox(
          height: 40,
          child: DropdownButtonFormField<String>(
            style: const TextStyle(fontSize: 14, color: Colors.black),
            dropdownColor: Colors.white,
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: const TextStyle(fontSize: 14)),
                    ))
                .toList(),
            onChanged: (value) {},
            decoration: InputDecoration(
              labelText: label, // Floating label
              labelStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              floatingLabelBehavior:
                  FloatingLabelBehavior.auto, // Moves label above when selected
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Widget _buildClickableOptions(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2.0),
        Wrap(
          spacing: 8.0, // Adjust spacing between chips if needed
          runSpacing: 8.0, // Adjust spacing between rows if needed
          children: options.map((option) {
            final isSelected = _selectedOption == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedOption = selected ? option : null;
                });
              },
              labelStyle: const TextStyle(color: Colors.white),
              backgroundColor: const Color.fromRGBO(0, 112, 183, 1),
              selectedColor: const Color.fromRGBO(0, 112, 183, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Circular shape
                side: BorderSide(
                  color: isSelected
                      ? Colors.white
                      : Colors.transparent, // Optional border
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildUploadField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              width: 120, // Increased width for better spacing
              child: ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.file_upload,
                    size: 18, color: Colors.white),
                label: const Text('Upload',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 112, 183, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(4.0), // Rectangular shape
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 40,
              width: 120,
              child: ElevatedButton.icon(
                onPressed: _uploadedFileName != null ? _viewFile : null,
                icon: const Icon(Icons.remove_red_eye_outlined,
                    size: 18, color: Colors.white),
                label: const Text('View',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
        if (_uploadedFileName != null)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              'Uploaded File: ${_uploadedFileName!.split('/').last}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
        SizedBox(
          height: 40,
          child: TextFormField(
            initialValue: value,
            enabled: false, // Keeps the field disabled
            style: const TextStyle(
                fontSize: 14, color: Colors.black54), // Slightly gray text
            decoration: InputDecoration(
              labelText: label, // Floating label
              labelStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              floatingLabelBehavior: FloatingLabelBehavior
                  .auto, // Moves label above when field is filled
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              disabledBorder: OutlineInputBorder(
                // Custom border for disabled state
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
