import 'package:flutter/material.dart';
import 'package:login/custom_app_bar/profile_sidebar.dart';
import 'dart:core';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';
import 'package:login/view_orders.dart';
import 'package:login/global_state.dart' as global_state;

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

  final Map<String, List<String>> productVariants = {
    'White Cement': [
      'White Cement - 1kg',
      'White Cement - 5kg',
      'White Cement - 10kg',
      'White Cement - 50kg',
      'White Cement - 100kg',
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
      appBar: CustomAppBar(),
      drawer: CustomSidebar(),
      endDrawer: const ProfileSidebar(),
      body: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Static Heading bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Order Update',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
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
                                  fontSize: 14.0), // Larger font
                            ),
                            const SizedBox(height: 2.0),
                            _buildProcessTypeCheckboxes(),
                            const SizedBox(height: 4.0),
                            _buildProductDropdown(
                              label: 'Product',
                              options: prod1Options,
                              onChanged: (value) {
                                setState(() {
                                  selectedProd1 = value;
                                });
                              },
                            ),
                            const SizedBox(height: 8.0),
                            _buildProductDropdown(
                              label: 'Unload Point',
                              options: unloadPointOptions,
                              onChanged: (value) {
                                _updatePurchaserAddress(value);
                              },
                            ),
                            const SizedBox(height: 8.0),
                            if (_showDocuNumCard)
                              _buildProductDropdown(
                                label: 'Document NO.',
                                options: docuNumOptions,
                              ),
                          ],
                        ),
                      ),
                      // Purchaser Details and Credit Limit
                      const SizedBox(height: 4.0),
                      isSmallScreen
                          ? Column(
                              children: [
                                _buildPurchaserDetailCard(isSmallScreen),
                                const SizedBox(height: 4.0),
                                _buildCreditLimitCard(isSmallScreen),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: _buildPurchaserDetailCard(
                                        isSmallScreen)),
                                const SizedBox(width: 4.0),
                                Expanded(
                                    child:
                                        _buildCreditLimitCard(isSmallScreen)),
                              ],
                            ),
                      const SizedBox(height: 4.0),
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
                                    fontSize: 14.0),
                              ),
                              const SizedBox(height: 8.0),
                              Column(
                                children: [
                                  ...productList.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    Map<String, dynamic> product = entry.value;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 20,
                                            child:
                                                DropdownButtonFormField<String>(
                                              value:
                                                  product['product'] as String?,
                                              items: (selectedProd1 != null
                                                      ? productVariants[
                                                          selectedProd1]!
                                                      : [])
                                                  .map((option) =>
                                                      DropdownMenuItem<String>(
                                                        value: option,
                                                        child: Text(option,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    12.0)),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  product['product'] = value;
                                                });
                                              },
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Please select a product'
                                                  : null,
                                              decoration: InputDecoration(
                                                labelText: 'Product*',
                                                labelStyle:
                                                    TextStyle(fontSize: 12.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 8.0),
                                                constraints: BoxConstraints(
                                                    maxHeight: 40),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          Expanded(
                                            flex: 5,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              enabled:
                                                  product['product'] != null,
                                              decoration: InputDecoration(
                                                labelText: 'Qty (MT)*',
                                                labelStyle:
                                                    TextStyle(fontSize: 12.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 8.0),
                                                constraints: BoxConstraints(
                                                    maxHeight: 40),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  product['qty'] = value;
                                                  _updateCreditLimitTable();
                                                });
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter quantity';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          Expanded(
                                            flex: 10,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: TextEditingController(
                                                  text:
                                                      product['scheduleDate']),
                                              decoration: InputDecoration(
                                                labelText: 'Schedule Date*',
                                                labelStyle:
                                                    TextStyle(fontSize: 12.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 8.0),
                                                constraints: BoxConstraints(
                                                    maxHeight: 40),
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
                                              validator: (value) =>
                                                  value == null || value.isEmpty
                                                      ? 'Please select a date'
                                                      : null,
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          Expanded(
                                            flex: 5,
                                            child: ElevatedButton(
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
                                                fixedSize:
                                                    const Size.fromHeight(40),
                                                minimumSize: const Size(40,
                                                    40), // Ensures square size
                                                padding: EdgeInsets
                                                    .zero, // Removes extra padding
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // Optional: Rounded corners
                                                ),
                                              ),
                                              child: const Icon(Icons.delete,
                                                  color: Colors.white,
                                                  size: 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                productList.insert(
                                                    productList.length - 1, {
                                                  'product': null,
                                                  'qty': null,
                                                  'scheduleDate': null,
                                                });
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              fixedSize:
                                                  const Size.fromHeight(40),
                                            ),
                                            child: const Text(
                                              'Add',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10.0,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                                  labelStyle: TextStyle(fontSize: 12.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Center(
                                  child: ElevatedButton(
                                onPressed: _handleSubmit,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
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
      margin: EdgeInsets.all(isSmallScreen ? 5.0 : 10.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 5.0 : 10.0),
        child: child,
      ),
    );
  }

  Widget _buildProductDropdown({
    required String label,
    required List<String> options,
    ValueChanged<String?>? onChanged,
  }) {
    // Ensure the value for 'Product' is not null when it's being used
    String? dropdownValue = label == 'Product'
        ? selectedProd1
        : (label == 'Document NO.' ? selectedDocuNum : selectedUnloadPoint);

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 4), // Adjust padding
      ),
      value: dropdownValue,
      style: const TextStyle(fontSize: 12, color: Colors.black),
      items: options
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option,
                    style: const TextStyle(
                        fontSize: 14)), // Dropdown items size 14
              ))
          .toList(),
      onChanged: (value) {
        if (label == 'Product') {
          if (selectedProd1 != null && selectedProd1 != value) {
            // Check if any products have been added
            double totalQtyMT = 0;
            try {
              totalQtyMT = double.parse(
                tableData1.firstWhere((row) =>
                    row['Description'] == 'Total Order Qnty (MT)')['Lacs']!,
              );
            } catch (e) {
              totalQtyMT = 0; // Default to 0 if there's an error parsing
            }

            if (totalQtyMT > 0) {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Change'),
                  content: const Text(
                      'All the products you added before will be moved to bin. Do you want to proceed?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedProd1 = value; // Update the product
                          productList = [
                            {
                              'product': null,
                              'qty': null,
                              'scheduleDate': null,
                            }
                          ]; // Reset product list
                          _updateCreditLimitTable(); // Reset the credit limit table
                        });
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              // Directly update if no products were added
              setState(() {
                selectedProd1 = value;
              });
            }
          } else {
            setState(() {
              selectedProd1 = value;
            });
          }
        } else if (label == 'Document NO.') {
          setState(() {
            selectedDocuNum = value;
          });
        } else {
          setState(() {
            selectedUnloadPoint = value;
            _updatePurchaserAddress(value);
          });
        }
      },
    );
  }

  // Function to extract KG from the product name (e.g., "50 kg" from "White Cement - 50 kg")
  double _extractKgFromProduct(String productName) {
    final regex = RegExp(r'(\d+)\s*kg'); // Regex to match kg value
    final match = regex.firstMatch(productName);
    return match != null ? double.parse(match.group(1)!) : 0.0;
  }

  // Submit button handler
  void _handleSubmit() {
    double totalAmount = 0;
    List<Widget> productDetailsWidgets = [];

    // Calculate the total amount and prepare the product detail widgets
    for (var product in productList) {
      if (product['qty'] != null && product['qty'] != '') {
        double qty = double.parse(product['qty']);
        double kg = _extractKgFromProduct(product['product']);
        double price = kg * 1000 * qty; // Price per product

        totalAmount += price;

        // Add the product details to the list
        productDetailsWidgets.add(Text(
          '${product['product']} - ₹${price.toStringAsFixed(2)} (${kg}kg x $qty)',
          style: const TextStyle(fontSize: 16),
        ));
      }
    }

    // Show the confirmation dialog with product details and total outstanding
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bill Summary'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Make dialog size adaptive
          children: [
            ...productDetailsWidgets,
            const SizedBox(height: 16.0),
            Text(
              'Total Outstanding: ₹${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // On pressing "OK" button, show SnackBar and close the dialog
              Navigator.of(context).pop(); // Close the dialog

              // Save the product list to the global state
              global_state.productList = List.from(productList);

              // Delay showing the SnackBar to ensure dialog has closed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageOrderPage(),
                ),
              );
              setState(() {
                // Reset product list, you can adjust this to your needs
                productList = [
                  {'product': null, 'qty': null, 'scheduleDate': null}
                ];
              });
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              // On pressing "Update", allow user to update more products
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Update'),
          ),
        ],
      ),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          _buildTable(tableData1),
        ],
      ),
    );
  }

  Widget _buildTable(List<Map<String, String>> data) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.grey),
      children: data
          .map(
            (row) => TableRow(
              children: row.values
                  .map(
                    (value) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: Text(
                        value,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12.0),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
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
        const SizedBox(width: 2.0),
        Text(label),
      ],
    );
  }
}
