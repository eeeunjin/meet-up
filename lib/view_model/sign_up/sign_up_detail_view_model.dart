import 'package:flutter/material.dart';

class SignUpDetailViewModel with ChangeNotifier {
  //
  // MARK: - Properties
  //
  Gender _selectedGender = Gender.none;
  Gender get selectedGender => _selectedGender; // 선택 성별

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate; // 선택 Date

  //
  // MARK: - methods
  //
  void selectGender(Gender gender) {
    if (_selectedGender != gender) {
      _selectedGender = gender;
      notifyListeners();
    }
  }

  void setDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      notifyListeners();
    }
  }
}

enum Gender { none, female, male }
