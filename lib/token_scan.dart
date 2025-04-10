import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:login/custom_app_bar/app_bar.dart';
// import 'package:login/custom_app_bar/side_bar.dart';
import 'package:login/content.dart';
import 'package:login/token_summary.dart';
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
  double _currentZoom = 0.5;
  final double _minZoom = 0.5;
  final double _maxZoom = 3;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 280,
                child: _isCameraPaused
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Scanned",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
                          // Scanner View Container
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
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
                            ),
                          ),

                          // Control Panel Container
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Flash Icon Button
                                  SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.flash_on,
                                            color: Colors.black, size: 20),
                                        onPressed: () =>
                                            _cameraController.toggleTorch(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  // Zoom Slider
                                  const Icon(Icons.add, size: 16),
                                  RotatedBox(
                                    quarterTurns: -1,
                                    child: SizedBox(
                                      width: 150,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: 3,
                                          activeTrackColor: Colors.blue,
                                          inactiveTrackColor: Colors.black,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                  enabledThumbRadius: 10),
                                          overlayShape:
                                              SliderComponentShape.noOverlay,
                                        ),
                                        child: Slider(
                                          value:
                                              _currentZoom, // reversed direction
                                          min: _minZoom,
                                          max: _maxZoom,
                                          divisions: 3,
                                          label:
                                              _currentZoom.toStringAsFixed(1),
                                          onChanged: (value) {
                                            final actualZoom =
                                                _maxZoom - value - _minZoom;
                                            setState(() {
                                              _currentZoom = actualZoom;
                                            });
                                            print(_currentZoom);
                                            _cameraController
                                                .setZoomScale(_currentZoom);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.remove, size: 16),
                                ],
                              ),
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
                  color: _pinValidationMessage == '✅ OK'
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Token Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        _buildTokenCard('08WX1NDVTPKB', '112473052',
                            '12 Jan 2026', '35', '3.50', true, '256'),
                        _buildTokenCard('15TY8BGFWCNH', '112425634',
                            '12 Jan 2026', '35', '3.50', true, '123'),
                        _buildTokenCard(
                            'XTR9PU5RXT00', '', '', '', '', false, ''),
                        _buildTokenCard('15TY8BGFWCNH', '112425634',
                            '12 Jan 2026', '35', '3.50', true, '123'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button (Centered)
              ElevatedButton(
                onPressed: () {
                  // Handle submit action
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  elevation: 5,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // Rounded container with Report & Summary buttons
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.grey.shade400),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Report Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TokenReportScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Report',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 20),
                    // Summary Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TokenSummaryScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Summary",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              // Container(
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     color: Colors.grey.shade300,
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       ElevatedButton(
              //         onPressed: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => const TokenDetailsPage()),
              //           );
              //         },
              //         style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.grey.shade700),
              //         child: const Text('Details',
              //             style: TextStyle(
              //                 color: Colors.white, fontWeight: FontWeight.bold)),
              //       ),
              //       ElevatedButton(
              // onPressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const TokenReportScreen()),
              //   );
              // },
              //         style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.grey.shade700),
              //   child: const Text('Report',
              //       style: TextStyle(
              //           color: Colors.white, fontWeight: FontWeight.bold)),
              // ),
              //       ElevatedButton(
              // onPressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const TokenSummaryScreen()),
              //   );
              // },
              //         style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.grey.shade700),
              //         child: const Text('Summary',
              //             style: TextStyle(
              //                 color: Colors.white, fontWeight: FontWeight.bold)),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTokenCard(String token, String id, String date, String value,
      String handling, bool isValid, String pin) {
    return Card(
      color: isValid ? Colors.blue.shade600 : Colors.red,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              token,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: isValid
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(id, style: const TextStyle(fontSize: 16)),
                        Text('Valid Upto - $date'),
                        Text('Value To Pay - $value'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Handling - $handling',
                                style: const TextStyle(color: Colors.green)),
                            Row(
                              children: [
                                const Text('PIN',
                                    style: TextStyle(color: Colors.grey)),
                                const SizedBox(width: 5),
                                Container(
                                  width: 50,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(pin,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Error - XTR9PU5RXT00',
                            style: TextStyle(color: Colors.red)),
                        Text('Please check with IT or Company Officer'),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
