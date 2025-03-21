import 'package:flutter/material.dart';

class TokenSummaryScreen extends StatelessWidget {
  const TokenSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:
            const Text('Token Summary', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 6)
                ],
              ),
              child: Table(
                border: TableBorder.all(color: Colors.grey.shade400),
                children: [
                  _buildTableRow("Total Scan", "3", Colors.blue),
                  _buildTableRow("Valid Scan", "2", Colors.green),
                  _buildTableRow("Expired Scan", "0", Colors.green),
                  _buildTableRow("Already Scanned", "0", Colors.green),
                  _buildTableRow("Invalid Scan", "1", Colors.red),
                  _buildTableRow("Total Amount", "77", Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                _buildButton("Close", Colors.grey, Colors.black,
                    () => Navigator.pop(context)),
                _buildButton("Save", Colors.blue, Colors.white, () {}),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value, Color valueColor) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: valueColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
      String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
    );
  }
}
