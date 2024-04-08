import 'package:flutter/material.dart';

class MeetBrowseViewModel with ChangeNotifier {
  // 상세 카테고리
  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  set selectedCategory(String? value) {
    _selectedCategory = value;
    notifyListeners();
  }

  // age
  List<bool> isSelected = [false, false, false, false];

  void toggleSelection(int index) {
    isSelected[index] = !isSelected[index];
    notifyListeners();
  }

  // 세부규칙
  List<bool> selectedRules = [false, false, false, false, false];

  void toggleRule(int index) {
    selectedRules[index] = !selectedRules[index];
  }
}
