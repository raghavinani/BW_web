import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.transparent, // Border color
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          filled: true,
          fillColor: Colors.white, // Search bar background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                30.0), // Rounded corners for the text field
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          prefixIcon: Icon(Icons.search, color: Colors.blue), // Search icon
        ),
      ),
    );
  }
}
