import 'package:flutter/material.dart';
import 'package:login/custom_app_bar/profile_sidebar.dart';
import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/custom_app_bar/app_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const QrCodeScanner());
}

class QrCodeScanner extends StatelessWidget {
  const QrCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _tokenFields = [];

  @override
  void initState() {
    super.initState();
    _addTokenField();
  }

  void _addTokenField() {
    setState(() {
      _tokenFields.add({
        'controller': TextEditingController(),
        'validationMessage': null,
      });
    });
  }

  void _removeTokenField(int index) {
    setState(() {
      _tokenFields.removeAt(index);
    });
  }

  /// Function to validate the input value
  String? _validateToken(String value) {
    if (value == 'NU87787HVY') {
      return 'Token Details: Successfully scanned';
    } else {
      return 'Error: $value - Please check with IT or Company Officer';
    }
  }

  Widget _buildTokenField(int index) {
    var field = _tokenFields[index];
    TextEditingController inputController = field['controller'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeTokenField(index),
              ),
              Expanded(
                child: TextField(
                  controller: inputController,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () async {
                        final scannedValue = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QrCodeScannerPage(),
                          ),
                        );
                        if (scannedValue != null) {
                          setState(() {
                            inputController.text = scannedValue;
                            field['validationMessage'] =
                                _validateToken(scannedValue);
                          });
                        }
                      },
                    ),
                    border: InputBorder.none,
                    labelText: 'Enter code here',
                  ),
                  onChanged: (value) {
                    if (value.length >= 10) {
                      setState(() {
                        field['validationMessage'] = _validateToken(value);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          if (field['validationMessage'] != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                field['validationMessage'],
                style: TextStyle(
                  color: field['validationMessage'].contains('Error')
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(),
      drawer: CustomSidebar(),
      endDrawer: const ProfileSidebar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Token Scan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Area'),
                    items: ['Jaipur', 'Mumbai', 'Delhi']
                        .map((area) =>
                            DropdownMenuItem(value: area, child: Text(area)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: '4401S711',
                    decoration: const InputDecoration(labelText: 'Purchaser'),
                    readOnly: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      List.generate(_tokenFields.length, _buildTokenField),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _addTokenField,
                  child:
                      const Text('Add', style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {},
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QrCodeScannerPage extends StatelessWidget {
  QrCodeScannerPage({super.key});

  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('Scanning...'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              final barcode = barcodes.first;

              if (barcode.rawValue != null) {
                await controller
                    .stop()
                    .then((value) => controller.dispose())
                    .then(
                        (value) => Navigator.of(context).pop(barcode.rawValue));
              }
            },
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
