import 'package:flutter/material.dart';

class SignUpDetailViewModel with ChangeNotifier {
  Gender _selectedGender = Gender.none;
  Gender get selectedGender => _selectedGender; // 선택된 성별

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate; // 선택된 날짜

  Affiliation _selectedAffiliation = Affiliation.none;
  Affiliation get selectedAffiliation => _selectedAffiliation; // 선택된 소속

  String _selectedProvince = '';
  String get selectedProvince => _selectedProvince; // 선택된 도/시

  String _selectedDistrict = '';
  String get selectedDistrict => _selectedDistrict; // 선택된 구/군

  void selectProvince(String province) {
    if (_selectedProvince != province) {
      _selectedProvince = province;
      notifyListeners();
    }
  }

  void selectDistrict(String district) {
    if (_selectedDistrict != district) {
      _selectedDistrict = district;
      notifyListeners();
    }
  }

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

  void selectAffiliation(Affiliation affiliation) {
    if (_selectedAffiliation != affiliation) {
      _selectedAffiliation = affiliation;
      notifyListeners();
    }
  }
}

enum Gender { none, female, male }

enum Affiliation { none, student, employee, freelancer, unemployed }
