import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';

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
      selectedArea,
      selectedDistrict,
      selectedPinCode,
      selectedProduct;
  DateTime? selectedDate;

  final TextEditingController docNumController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController meetingVenueController = TextEditingController();

  final List<String> processTypes = ['Add', 'Edit', 'Delete'];
  final List<String> activities = ['Brand Approval', 'Product Awareness'];
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOTE with delay and scrolling
                SizedBox(
                    height: 30,
                    child: Marquee(
                      text:
                          'NOTE: DocNum is NOT required for adding details. For searching and deleting, only DocNum is required.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      blankSpace: 500.0,
                      velocity: 30.0,
                      startAfter: const Duration(seconds: 2),
                      pauseAfterRound: const Duration(seconds: 1),
                      accelerationDuration: const Duration(seconds: 1),
                    )),
                const SizedBox(height: 8),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          _buildTextField(
                            docNumController,
                            'DocNum',
                            validator: (value) => null, // Optional for Add
                          ),
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
                            validator: (value) => value == null
                                ? 'Please select an activity'
                                : null,
                          ),
                          _buildTextField(
                            descriptionController,
                            'Description *',
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a description'
                                : null,
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
                            validator: (value) => value == null
                                ? 'Please select a district'
                                : null,
                          ),
                          _buildDropdownField(
                            label: 'Pin Code *',
                            value: selectedPinCode,
                            items: (selectedArea != null &&
                                    selectedDistrict != null)
                                ? pinCodesByAreaAndDistrict[selectedArea]![
                                        selectedDistrict] ??
                                    []
                                : [],
                            onChanged: (value) {
                              setState(() {
                                selectedPinCode = value;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Please select a pin code'
                                : null,
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
                            validator: (value) => value == null
                                ? 'Please select a product'
                                : null,
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
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Info'),
                                    content: const Text(
                                        'DocNum will be assigned automatically.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          print('Entry added successfully.');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
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
                              if (docNumController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('DocNum is required for delete.'),
                                  ),
                                );
                              } else {
                                print(
                                    'Delete pressed for DocNum: ${docNumController.text}');
                              }
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
                          ElevatedButton(
                            onPressed: () {
                              if (docNumController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('DocNum is required for search.'),
                                  ),
                                );
                              } else {
                                print(
                                    'Search pressed for DocNum: ${docNumController.text}');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                            child: const Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _downloadAllData(context);
                              print('Download all data');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                            ),
                            child: const Text(
                              'All',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadAllData(BuildContext context) async {
    final List<Map<String, dynamic>> sampleData = [
      {
        "DocNum": "101",
        "Process Type": "Add",
        "Activity": "Brand Approval",
        "Description": "Brand XYZ approved for promotion",
        "Activity Date": "10/12/2024",
        "Meeting Venue": "Mumbai Office",
        "Area": "Mumbai",
        "District": "Thane",
        "Pin Code": "400703",
        "Product": "Product A",
      },
      {
        "DocNum": "102",
        "Process Type": "Edit",
        "Activity": "Product Awareness",
        "Description": "Session conducted for awareness",
        "Activity Date": "11/12/2024",
        "Meeting Venue": "Pune Office",
        "Area": "Pune",
        "District": "Shivajinagar",
        "Pin Code": "411005",
        "Product": "Product B",
      },
    ];

    final Excel excel = Excel.createExcel();
    final Sheet sheet = excel['Activity Data'];

    // Add header row
    final List<String> headers = sampleData.first.keys.toList();
    for (int col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = TextCellValue(headers[col]); // Explicitly set TextCellValue
    }

    // Add data rows
    for (int row = 0; row < sampleData.length; row++) {
      final dataRow = sampleData[row].values.toList();
      for (int col = 0; col < dataRow.length; col++) {
        final value = dataRow[col];
        // Use appropriate CellValue types based on value type
        if (value is String) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: col, rowIndex: row + 1))
              .value = TextCellValue(value);
        } else if (value is int) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: col, rowIndex: row + 1))
              .value = IntCellValue(value);
        } else if (value is double) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: col, rowIndex: row + 1))
              .value = DoubleCellValue(value);
        } else {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: col, rowIndex: row + 1))
              .value = TextCellValue(value.toString());
        }
      }
    }

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = '${directory.path}/ActivityData.xlsx';
      final File file = File(path);
      file.writeAsBytesSync(excel.save()!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel file saved at $path')),
      );
      print('Excel file saved at $path');
    } catch (e) {
      print('$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: $e')),
      );
    }
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
