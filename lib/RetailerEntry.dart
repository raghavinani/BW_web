import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:login/app_bar.dart';

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
  String? _uploadedFile;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _uploadedFile = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Retailer Registration',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    constraints.maxWidth > 800
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildBasicDetailsForm()),
                              const SizedBox(width: 16.0),
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
                    const SizedBox(height: 32.0),
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
                              horizontal: 40, vertical: 16),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text('Submit',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField('Process Type*', ['Add', 'Update']),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildDropdownField(
                    'Retailer Category*', ['Urban', 'Rural', 'Direct Dealer']),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child:
                    _buildDropdownField('Area*', ['Rajasthan', 'Maharashtra']),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildDropdownField('District*', ['Jaipur', 'Mumbai']),
              ),
            ],
          ),
          _buildClickableOptions(
              'Register With PAN/GST*', ['With GST', 'With PAN']),
          Row(
            children: [
              Expanded(
                child: _buildTextField('GST Number*'),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildTextField('PAN Number*'),
              ),
            ],
          ),
          _buildTextField('Firm Name*'),
          Row(
            children: [
              Expanded(
                child: _buildTextField('Mobile*'),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildTextField('Office Telephone'),
              ),
            ],
          ),
          _buildTextField('Email'),
          _buildTextField('Address 1*'),
          Row(
            children: [
              Expanded(
                child: _buildTextField('Address 2'),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildTextField('Address 3'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: _buildPredefinedField('Stockist Code*', '4401S711'),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildTextField('Tally Retailer Code'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField('Concern Employee*'),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildUploadField('Retailer Profile Image'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildUploadField('PAN / GST No Image Upload / View'),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildDropdownField('Scheme Required*', ['Yes', 'No']),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField('Aadhar Card No*'),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildUploadField('Aadhar Card Upload'),
              ),
            ],
          ),
          _buildTextField('Proprietor / Partner Name*'),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextFormField(
          decoration: InputDecoration(
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
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (value) {},
          decoration: InputDecoration(
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
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildClickableOptions(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          children: options
              .map((option) => ChoiceChip(
                    label: Text(option),
                    selected: false,
                    onSelected: (selected) {},
                    labelStyle: const TextStyle(color: Colors.blueAccent),
                    backgroundColor: Colors.blue[100],
                    selectedColor: Colors.blueAccent,
                  ))
              .toList(),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildUploadField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child:
                  const Text('Upload', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: _uploadedFile != null
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Viewing file: $_uploadedFile'),
                      ));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('View', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        if (_uploadedFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Uploaded File: $_uploadedFile',
              style: const TextStyle(color: Colors.grey),
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
        Text(label),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
