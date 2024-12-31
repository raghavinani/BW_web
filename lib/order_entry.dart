import 'package:flutter/material.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';

class OrderEntry extends StatefulWidget {
  const OrderEntry({super.key});

  @override
  State<OrderEntry> createState() => _OrderEntryState();
}

class _OrderEntryState extends State<OrderEntry> {
  String? selectedProd1;
  String? selectedUnloadPoint;
  String? selectedPlantCode;
  bool isRailTransport = true;

  List<Map<String, String>> tableData1 = [
    {'Description': 'Security', 'Lacs': '0.00'},
    {'Description': 'Credit Limit', 'Lacs': '0.00'},
    {'Description': 'Balance Limit', 'Lacs': '0.00'},
    {'Description': 'Penalty', 'Lacs': '0.00'},
    {'Description': 'Open Billing', 'Lacs': '0.00'},
    {'Description': 'Total Order Qnty (Bags)', 'Lacs': '0.00'},
    {'Description': 'Total Order Qnty (MT)', 'Lacs': '0.00'},
  ];

  List<Map<String, String>> tableData2 = [
    {'Detail': 'Purchaser Name:', 'Data': 'SHREE RAMDAS CEMENT AGENCY'},
    {'Detail': 'Mobile No:', 'Data': '9414048399'},
    {'Detail': 'Purchaser Type:', 'Data': 'ULTRA TECH RETAILERS'},
    {'Detail': 'Address:', 'Data': ''},
  ];

  final List<String> prod1Options = [
    'White Cement',
    'WaterProof Putty',
    'Wall Care Putty'
  ];
  final List<String> unloadPointOptions = ['Delhi', 'Mumbai', 'Pune'];
  final List<String> plantCodeOptions = [
    'JPF - Jaipur Factory',
    'KKR - Kharia Plant'
  ];

  final Map<String, List<String>> productVariants = {
    'White Cement': [
      'White Cement - 1kg',
      'White Cement - 5kg',
      'White Cement - 10kg',
      'White Cement - 50kg',
      'White Cement - 100kg',
      'White Cement - 500kg',
      'White Cement - 1000kg',
    ],
    'WaterProof Putty': [
      'WaterProof Putty - 1kg',
      'WaterProof Putty - 5kg',
      'WaterProof Putty - 10kg',
      'WaterProof Putty - 50kg',
    ],
    'Wall Care Putty': [
      'Wall Care Putty - 1kg',
      'Wall Care Putty - 5kg',
      'Wall Care Putty - 10kg',
      'Wall Care Putty - 50kg',
    ],
  };

  List<Map<String, dynamic>> productList = [
    {'product': null, 'qty': null, 'scheduleDate': null},
  ];

  void _updatePurchaserAddress(String? unloadPoint) {
    setState(() {
      tableData2
          .firstWhere((row) => row['Detail'] == 'Address:')
          .update('Data', (value) => unloadPoint ?? '');
    });
  }

  void _updateCreditLimitTable() {
    double totalQtyMT = productList.fold(
        0.0,
        (sum, product) =>
            sum +
            (product['qty'] != null ? double.parse(product['qty']) : 0.0));

    setState(() {
      tableData1
          .firstWhere((row) => row['Description'] == 'Total Order Qnty (Bags)')
          .update('Lacs', (value) => (totalQtyMT * 40).toStringAsFixed(2));
      tableData1
          .firstWhere((row) => row['Description'] == 'Total Order Qnty (MT)')
          .update('Lacs', (value) => totalQtyMT.toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const CustomSidebar(),
      body: Container(
        color: Colors.blue.shade600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Static Heading bar
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Order Entry',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product, Unload Point, Plant Code, and Mode of Transportation
                      _buildCard(
                        isSmallScreen,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildProductDropdown(
                                    label: 'Product',
                                    options: prod1Options,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedProd1 = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: _buildProductDropdown(
                                    label: 'Unload Point',
                                    options: unloadPointOptions,
                                    onChanged: (value) {
                                      _updatePurchaserAddress(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildProductDropdown(
                                    label: 'Plant Code',
                                    options: plantCodeOptions,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPlantCode = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Row(
                                    children: [
                                      _buildRoundedCheckbox(
                                        'Rail',
                                        isRailTransport,
                                        (value) {
                                          setState(() {
                                            isRailTransport = value!;
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 16.0),
                                      _buildRoundedCheckbox(
                                        'Road',
                                        !isRailTransport,
                                        (value) {
                                          setState(() {
                                            isRailTransport = !value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Purchaser Details and Credit Limit
                      isSmallScreen
                          ? Column(
                              children: [
                                _buildPurchaserDetailCard(isSmallScreen),
                                const SizedBox(height: 16.0),
                                _buildCreditLimitCard(isSmallScreen),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: _buildPurchaserDetailCard(
                                        isSmallScreen)),
                                const SizedBox(width: 16.0),
                                Expanded(
                                    child:
                                        _buildCreditLimitCard(isSmallScreen)),
                              ],
                            ),
                      const SizedBox(height: 16.0),
                      // Products Section
                      _buildCard(
                        isSmallScreen,
                        child: Column(
                          children: [
                            const Text(
                              'Products',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            const SizedBox(height: 16.0),
                            ...productList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> product = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: DropdownButtonFormField<String>(
                                        value: product['product'] as String?,
                                        items: (selectedProd1 != null
                                                ? productVariants[
                                                    selectedProd1]!
                                                : [])
                                            .map((option) =>
                                                DropdownMenuItem<String>(
                                                    value: option,
                                                    child: Text(option)))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            product['product'] = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Product*',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        enabled: product['product'] != null,
                                        decoration: InputDecoration(
                                          labelText: 'Qty (MT)*',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            product['qty'] = value;
                                            _updateCreditLimitTable();
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: product['scheduleDate']),
                                        decoration: InputDecoration(
                                          labelText: 'Schedule Date*',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2100),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              product['scheduleDate'] =
                                                  pickedDate
                                                      .toString()
                                                      .substring(0, 10);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              productList.add({
                                                'product': null,
                                                'qty': null,
                                                'scheduleDate': null,
                                              });
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Text(
                                            'Add',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (productList.length > 1) {
                                              setState(() {
                                                productList.removeAt(index);
                                                _updateCreditLimitTable();
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                                color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      _buildCard(
                        isSmallScreen,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Order Remarks',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Center(
                                child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Submitted')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.black),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(bool isSmallScreen, {required Widget child}) {
    return Card(
      margin: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
        child: child,
      ),
    );
  }

  Widget _buildProductDropdown(
      {required String label,
      required List<String> options,
      ValueChanged<String?>? onChanged}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        border: const OutlineInputBorder(),
      ),
      value: label == 'Product' ? selectedProd1 : null,
      items: options
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildPurchaserDetailCard(bool isSmallScreen) {
    return _buildCard(
      isSmallScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Purchaser Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          const SizedBox(height: 16.0),
          _buildTable(tableData2),
        ],
      ),
    );
  }

  Widget _buildCreditLimitCard(bool isSmallScreen) {
    return _buildCard(
      isSmallScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Credit Limit',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          const SizedBox(height: 16.0),
          _buildTable(tableData1),
        ],
      ),
    );
  }

  Widget _buildTable(List<Map<String, String>> data) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.grey),
      children: data
          .map(
            (row) => TableRow(
              children: row.values
                  .map(
                    (value) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }

  Widget _buildRoundedCheckbox(
      String label, bool value, ValueChanged<bool?>? onChanged) {
    return Row(
      children: [
        Checkbox(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          value: value,
          onChanged: onChanged,
        ),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ],
    );
  }
}
