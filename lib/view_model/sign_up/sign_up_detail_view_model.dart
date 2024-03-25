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

  // MARK: - page 6
  List<bool> acceptedPlicies = [
    false, // 필수
    false, // 필수
    false, // 필수
    false, // 필수
    false, // 필수
    false, // 선택
    false, // 선택
    false, // 전체 동의
  ];
  bool isAcceptionValid = false;

  void toggleAcceptPolicies({required int index}) {
    acceptedPlicies[index] = !acceptedPlicies[index];
    bool allAcceptionCheck = true;
    bool acceptionValidCheck = true;
    for (int i = 0; i < 7; i++) {
      if (acceptedPlicies[i] == false) {
        allAcceptionCheck = false;
        if (i < 5) acceptionValidCheck = false;
      }
    }
    if (allAcceptionCheck == true) {
      acceptedPlicies[7] = true;
    } else {
      acceptedPlicies[7] = false;
    }
    isAcceptionValid = acceptionValidCheck;

    notifyListeners();
  }

  void toggleAllAccpetPlicies() {
    if (acceptedPlicies[7] == false) {
      for (int i = 0; i < 8; i++) {
        acceptedPlicies[i] = true;
      }
      isAcceptionValid = true;
    } else {
      for (int i = 0; i < 8; i++) {
        acceptedPlicies[i] = false;
      }
      isAcceptionValid = false;
    }
    notifyListeners();
  }
}

enum Gender { none, female, male }
