import 'package:flutter/material.dart';

class SignUpDetailViewModel with ChangeNotifier {
  Gender _selectedGender = Gender.none;

  Gender get selectedGender => _selectedGender;

  void selectGender(Gender gender) {
    if (_selectedGender != gender) {
      _selectedGender = gender;
      notifyListeners();
    }
  }
}

// An enum to define the gender options
enum Gender { none, female, male }
