import 'package:flutter/material.dart';

class SidebarState extends ChangeNotifier {
  int? expandedIndex;

  void expandSection(int index) {
    expandedIndex = index;
    notifyListeners();
  }
}

final sidebarState = SidebarState();
