import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onClose;

  const SearchBarWidget({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Reduce height to prevent overflow
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextField(
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 12, color: Colors.blue),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search for reports, orders, etc.',
          hintStyle: TextStyle(color: Colors.black.withOpacity(.40)),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, size: 12, color: Colors.blue),
            onPressed: onClose,
          ),
        ),
      ),
    );
  }
}
