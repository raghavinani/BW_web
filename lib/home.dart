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
        color: Colors.grey[200], // Simple light grey background
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Determine the number of columns based on screen width
              int crossAxisCount = constraints.maxWidth > 800
                  ? 3
                  : 2; // 3 columns for large screens, 2 for smaller screens

              return Center(
                child: GridView.count(
                  crossAxisCount:
                      crossAxisCount, // Adjust the number of columns dynamically
                  crossAxisSpacing: 8, // Reduced horizontal spacing
                  mainAxisSpacing: 1, // Reduced vertical spacing
                  childAspectRatio: 2, // Adjust height for form fields
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
                    ),
                    _buildTextField(descriptionController, 'Description *'),
                    _buildDropdownField(
                      label: 'Objective *',
                      value: selectedObjective,
                      items: objectives,
                      onChanged: (value) {
                        setState(() {
                          selectedObjective = value;
                        });
                      },
                    ),
                    _buildTextField(
                      TextEditingController(
                          text: selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : ''),
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
                    ),
                    _buildTextField(meetingVenueController, 'Meeting Venue *'),
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
                          selectedPinCode =
                              null; // Reset pin code when district changes
                        });
                      },
                    ),
                    _buildTextField(
                        cityController, 'City and District (Address) *'),
                    _buildDropdownField(
                      label: 'Pin Code *',
                      value: selectedPinCode,
                      items: (selectedArea != null && selectedDistrict != null)
                          ? pinCodesByAreaAndDistrict
                                      .containsKey(selectedArea) &&
                                  pinCodesByAreaAndDistrict[selectedArea]!
                                      .containsKey(selectedDistrict)
                              ? pinCodesByAreaAndDistrict[selectedArea]![
                                      selectedDistrict] ??
                                  []
                              : []
                          : [],
                      onChanged: (value) {
                        setState(() {
                          selectedPinCode = value;
                        });
                      },
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
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                print('Add pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                textStyle: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Delete pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade800,
                textStyle: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          onTap: onTap,
          readOnly: onTap != null,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ],
    );
  }
}
