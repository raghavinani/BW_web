import 'package:flutter/material.dart';

class TokenDetailsPage extends StatelessWidget {
  const TokenDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Token Details'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildTokenCard('08WX1NDVTPKB', '112473052', '12 Jan 2026',
                      '35', '3.50', true, '256'),
                  _buildTokenCard('15TY8BGFWCNH', '112425634', '12 Jan 2026',
                      '35', '3.50', true, '123'),
                  _buildTokenCard('XTR9PU5RXT00', '', '', '', '', false, ''),
                  _buildTokenCard('15TY8BGFWCNH', '112425634', '12 Jan 2026',
                      '35', '3.50', true, '123'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                _buildButton(context, 'Close', Colors.grey,
                    () => Navigator.pop(context)),
                _buildButton(context, 'Submit', Colors.blue, () {}),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenCard(String token, String id, String date, String value,
      String handling, bool isValid, String pin) {
    return Card(
      color: isValid ? Colors.blue : Colors.red,
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
                  : const Column(
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

  Widget _buildButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      ),
      onPressed: onPressed,
      child:
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
