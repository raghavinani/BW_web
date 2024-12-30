import 'package:flutter/material.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';

class OrderUpdate extends StatefulWidget {
  const OrderUpdate({super.key});

  @override
  State<OrderUpdate> createState() => _OrderEntryState();
}

class _OrderEntryState extends State<OrderUpdate> {
  String? selectedProd1;
  String? selectedUnloadPoint;
  String? selectedDocuNum;
  bool _isAddChecked = true;
  bool _isRemoveChecked = false;
  bool _isUpdateChecked = false;

  bool _showDocuNumCard = false;

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

  final List<String> docuNumOptions = ['DOC001', 'DOC002', 'DOC003'];
  final List<String> prod1Options = [
    'White Cement',
    'WaterProof Putty',
    'Wall Care Putty'
  ];
  final List<String> unloadPointOptions = ['Delhi', 'Mumbai', 'Pune'];

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
                      // Order Type, Process Type, Product, Unload Point, and Document No.
                      _buildCard(
                        isSmallScreen,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Type',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0), // Larger font
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Expanded(child: _buildProcessTypeCheckboxes()),
                                const SizedBox(width: 8.0),
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
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildProductDropdown(
                                    label: 'Unload Point',
                                    options: unloadPointOptions,
                                    onChanged: (value) {
                                      _updatePurchaserAddress(value);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                if (_showDocuNumCard)
                                  Expanded(
                                    child: _buildProductDropdown(
                                      label: 'Document NO.',
                                      options: docuNumOptions,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Purchaser Details and Credit Limit
                      const SizedBox(height: 16.0),
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
                      // Conditionally show Products and Order Remarks only if a product is selected
                      if (selectedProd1 != null) ...[
                        // Products Section
                        _buildCard(
                          isSmallScreen,
                          child: Column(
                            children: [
                              const Text(
                                'Products',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
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
                                          value: product['product'],
                                          items: prod1Options
                                              .map((option) => DropdownMenuItem(
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
                        // Remarks Section
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
      value: label == 'Product'
          ? selectedProd1
          : (label == 'Document NO.' ? selectedDocuNum : selectedUnloadPoint),
      items: options
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      onChanged: onChanged ??
          (value) {
            setState(() {
              if (label == 'Product') {
                selectedProd1 = value;
              } else if (label == 'Document NO.') {
                selectedDocuNum = value;
              } else {
                selectedUnloadPoint = value;
              }
            });
          },
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

  Widget _buildTable(List<Map<String, String>> tableData) {
    return DataTable(
      border: TableBorder.all(
        color: Colors.grey.shade400,
        width: 1.0,
      ),
      columns: tableData.first.keys
          .map((key) => DataColumn(
                label: Text(
                  key,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ))
          .toList(),
      rows: tableData.map((row) {
        return DataRow(
          cells: row.entries.map((entry) {
            return DataCell(Text(entry.value));
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildProcessTypeCheckboxes() {
    return Row(
      children: [
        _buildRoundedCheckbox('Add', _isAddChecked, (value) {
          setState(() {
            _isAddChecked = value!;
            _isRemoveChecked = false;
            _isUpdateChecked = false;
            _showDocuNumCard = false;
          });
        }),
        const SizedBox(width: 8.0),
        _buildRoundedCheckbox('Remove', _isRemoveChecked, (value) {
          setState(() {
            _isRemoveChecked = value!;
            _isAddChecked = false;
            _isUpdateChecked = false;
            _showDocuNumCard = true;
          });
        }),
        const SizedBox(width: 8.0),
        _buildRoundedCheckbox('Update', _isUpdateChecked, (value) {
          setState(() {
            _isUpdateChecked = value!;
            _isAddChecked = false;
            _isRemoveChecked = false;
            _showDocuNumCard = true;
          });
        }),
      ],
    );
  }

  Widget _buildRoundedCheckbox(
      String label, bool value, ValueChanged<bool?>? onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        const SizedBox(width: 8.0),
        Text(label),
      ],
    );
  }
}
