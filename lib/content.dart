import 'package:flutter/material.dart';
import 'package:login/app_bar.dart'; // Assuming this is where the AppBar code is located

void main() {
  runApp(const ContentPage());
}

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: Colors.blue
            .shade600, // Medium blue shade background for the entire screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading bar below AppBar (white background, centered text, black bold text)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Birla White',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // The main content with boxes
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBox(
                        title: 'Credit Limit',
                        values: [
                          'Credit Limit: 0',
                          'Open Billing: 0',
                          'Open Order: 0',
                        ],
                        graph: true,
                        width:
                            (screenWidth - 64) / 4, // Adjust width dynamically
                      ),
                      _buildBox(
                        title: 'Primary Sale',
                        values: [
                          'WC: 0',
                          'WCP: 0',
                          'VAP: 0',
                          'Primer: 0',
                          'Water Proofing Compound: 0',
                          'Distemper: 0',
                        ],
                        graph: true,
                        width: (screenWidth - 64) / 4,
                      ),
                      _buildBox(
                        title: 'Secondary Sale',
                        values: [
                          'WC: 0',
                          'WCP: 0',
                          'VAP: 0',
                          'Primer: 0',
                          'Water Proofing Compound: 0',
                          'Distemper: 0',
                        ],
                        graph: true,
                        width: (screenWidth - 64) / 4,
                      ),
                      _buildBox(
                        title: 'My Network',
                        values: [
                          'Total Unique Billed: 0',
                          'WC: 0',
                          'WCP: 0',
                          'VAP: 0',
                          'Primer: 0',
                          'Water Proofing Compound: 0',
                          'Distemper: 0',
                        ],
                        graph: true,
                        width: (screenWidth - 64) / 4,
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

  Widget _buildBox({
    required String title,
    required List<String> values,
    required bool graph,
    required double width,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            spreadRadius: 2.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center content horizontally
        mainAxisSize: MainAxisSize.min, // Allow the height to be dynamic
        children: [
          // Box Title (Centered, Bold, and Larger Font)
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16, // Slightly larger font for the title
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Graph placeholder (empty grey graph)
          if (graph)
            Container(
              width: double.infinity,
              height: 60, // Placeholder height for the graph
              color: Colors.grey.shade300, // Empty graph placeholder
              margin: const EdgeInsets.only(bottom: 16),
              child: const Center(
                child: Icon(
                  Icons.insert_chart, // Placeholder icon for graph
                  size: 24,
                  color: Colors.grey,
                ),
              ),
            ),

          // Display values vertically
          for (var value in values)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
