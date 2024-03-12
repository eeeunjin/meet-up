import 'package:flutter/material.dart';

class SignUpDetailViewModel with ChangeNotifier {
  // gender
  Gender _selectedGender = Gender.none;

  Gender get selectedGender => _selectedGender;

  void selectGender(Gender gender) {
    if (_selectedGender != gender) {
      _selectedGender = gender;
      notifyListeners();
    }
  }

  //datepicker
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      notifyListeners();
    }
  }
}

enum Gender { none, female, male }
