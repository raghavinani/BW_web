import 'package:flutter/material.dart';
import 'package:login/token_summary.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:login/custom_app_bar/app_bar.dart';
// import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/content.dart';
import 'package:login/token_details.dart';
import 'package:login/token_report.dart';

void main() {
  runApp(const TokenScanApp());
}

class TokenScanApp extends StatelessWidget {
  const TokenScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TokenScanPage(),
    );
  }
}

class TokenScanPage extends StatefulWidget {
  const TokenScanPage({super.key});

  @override
  State<TokenScanPage> createState() => _TokenScanPageState();
}

class _TokenScanPageState extends State<TokenScanPage> {
  final MobileScannerController _cameraController = MobileScannerController();
  String? _scannedValue;
  String? _pinValidationMessage;
  bool _isTokenValid = false;
  int _remainingAttempts = 3;
  final TextEditingController _pinController = TextEditingController();
  bool _isCameraPaused = false;

  void _validateToken(String value) {
    setState(() {
      if (value == 'http://en.m.wikipedia.org') {
        _scannedValue = '✅ Token Details: $value';
        _isTokenValid = true;
      } else {
        _scannedValue =
            '❌ Error: $value - Please check with IT or Company Officer';
        _isTokenValid = false;
      }
      _isCameraPaused = true; // Pause the scanner
    });

    _cameraController.stop(); // Stop scanning after detection
  }

  void _validatePin(String value) {
    if (value == '123') {
      setState(() {
        _pinValidationMessage = '✅ OK';
      });
    } else {
      setState(() {
        _remainingAttempts--;
        _pinValidationMessage =
            '❌ WRONG PIN, $_remainingAttempts RETRY REMAINING';
      });
    }
  }

  void _restartScan() {
    setState(() {
      _scannedValue = null;
      _isTokenValid = false;
      _isCameraPaused = false;
      _pinController.clear();
      _pinValidationMessage = null;
      _remainingAttempts = 3;
    });

    _cameraController.start(); // Restart the scanner
  }

  @override
  void dispose() {
    _cameraController.stop().then((_) {
      _cameraController.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(),
      // drawer: CustomSidebar(),
      appBar: AppBar(
        title: const Text('Token Scan'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            dispose();
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContentPage()),
              );
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // const Text(
            //   'Token Scan',
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.blueAccent,
            //   ),
            // ),
            // const SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: _isCameraPaused
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          color: Colors.black.withOpacity(0.7),
                          child: Center(
                            child: Text(
                              "Scanned",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: ElevatedButton(
                            onPressed: _restartScan,
                            child: const Text('Rescan'),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: MobileScanner(
                            controller: _cameraController,
                            onDetect: (capture) {
                              final barcode = capture.barcodes.first;
                              if (barcode.rawValue != null) {
                                _validateToken(barcode.rawValue!);
                              }
                            },
                          ),
                        ),
                        const VerticalDivider(
                            color: Colors.black, thickness: 1),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.flash_on),
                                onPressed: () =>
                                    _cameraController.toggleTorch(),
                              ),
                              IconButton(
                                icon: const Icon(Icons.zoom_in),
                                onPressed: () =>
                                    _cameraController.setZoomScale(2.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              _scannedValue ?? 'Scan a token',
              style: TextStyle(
                color: _isTokenValid ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('Enter PIN -'),
                  const SizedBox(
                      width: 10), // Add spacing between label and input
                  Expanded(
                    // Ensures TextField has a bounded width
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        enabled: _isTokenValid,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.length == 3) {
                            _validatePin(value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _pinValidationMessage ?? '',
              style: TextStyle(
                color:
                    _pinValidationMessage == '✅ OK' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TokenDetailsPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700),
                    child: const Text('Details',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TokenReportScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700),
                    child: const Text('Report',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TokenSummaryScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700),
                    child: const Text('Summary',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
