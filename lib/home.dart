import 'package:flutter/material.dart';

void main() {
  runApp(const home());
}

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ActivityEntryScreen(),
    );
  }
}

class ActivityEntryScreen extends StatefulWidget {
  const ActivityEntryScreen({super.key});

  @override
  State<ActivityEntryScreen> createState() => _ActivityEntryScreenState();
}

class _ActivityEntryScreenState extends State<ActivityEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedProcessType,
      selectedActivity,
      selectedObjective,
      selectedArea,
      selectedDistrict,
      selectedPinCode,
      selectedProduct;
  DateTime? selectedDate;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController meetingVenueController = TextEditingController();

  final List<String> processTypes = ['Add', 'Edit', 'Delete'];
  final List<String> activities = ['Brand Approval', 'Product Awareness'];
  final List<String> objectives = ['Objective 1', 'Objective 2'];
  final List<String> areas = ['Mumbai', 'Pune'];

  final Map<String, List<String>> districtsByArea = {
    'Mumbai': ['Thane', 'Borivali'],
    'Pune': ['Shivajinagar', 'Kothrud'],
  };

  final Map<String, Map<String, List<String>>> pinCodesByAreaAndDistrict = {
    'Mumbai': {
      'Thane': ['400703', '400604'],
      'Borivali': ['400091', '400092'],
    },
    'Pune': {
      'Shivajinagar': ['411005', '411006'],
      'Kothrud': ['411038', '411039'],
    },
  };

  final List<String> products = ['Product A', 'Product B'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Entry'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      _buildDropdownField(
                        label: 'Process Type *',
                        value: selectedProcessType,
                        items: processTypes,
                        onChanged: (value) {
                          setState(() {
                            selectedProcessType = value;
                          });
                        },
                        validator: (value) => value == null
                            ? 'Please select a process type'
                            : null,
                      ),
                      _buildDropdownField(
                        label: 'Activity *',
                        value: selectedActivity,
                        items: activities,
                        onChanged: (value) {
                          setState(() {
                            selectedActivity = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select an activity' : null,
                      ),
                      _buildTextField(
                        descriptionController,
                        'Description *',
                        validator: (value) => value!.isEmpty
                            ? 'Please enter a description'
                            : null,
                      ),
                      _buildDropdownField(
                        label: 'Objective *',
                        value: selectedObjective,
                        items: objectives,
                        onChanged: (value) {
                          setState(() {
                            selectedObjective = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select an objective' : null,
                      ),
                      _buildTextField(
                        TextEditingController(
                          text: selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : '',
                        ),
                        'Activity Date *',
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        validator: (value) => selectedDate == null
                            ? 'Please select a date'
                            : null,
                      ),
                      _buildTextField(
                        meetingVenueController,
                        'Meeting Venue *',
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a venue' : null,
                      ),
                      _buildDropdownField(
                        label: 'Area *',
                        value: selectedArea,
                        items: areas,
                        onChanged: (value) {
                          setState(() {
                            selectedArea = value;
                            selectedDistrict = null;
                            selectedPinCode = null;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select an area' : null,
                      ),
                      _buildDropdownField(
                        label: 'District *',
                        value: selectedDistrict,
                        items: selectedArea != null
                            ? districtsByArea[selectedArea] ?? []
                            : [],
                        onChanged: (value) {
                          setState(() {
                            selectedDistrict = value;
                            selectedPinCode = null;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a district' : null,
                      ),
                      _buildDropdownField(
                        label: 'Pin Code *',
                        value: selectedPinCode,
                        items:
                            (selectedArea != null && selectedDistrict != null)
                                ? pinCodesByAreaAndDistrict[selectedArea]![
                                        selectedDistrict] ??
                                    []
                                : [],
                        onChanged: (value) {
                          setState(() {
                            selectedPinCode = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a pin code' : null,
                      ),
                      _buildDropdownField(
                        label: 'Product *',
                        value: selectedProduct,
                        items: products,
                        onChanged: (value) {
                          setState(() {
                            selectedProduct = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a product' : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print('Form submitted successfully');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print('Delete pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            onTap: onTap,
            readOnly: onTap != null,
            validator: validator,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            validator: validator,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item, style: const TextStyle(fontSize: 14)),
                    ))
                .toList(),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
