import 'package:flutter/material.dart';

class SignUpDetailViewModel with ChangeNotifier {
  Gender _selectedGender = Gender.none;
  Gender get selectedGender => _selectedGender; // 선택된 성별

  final DateTime _selectedDate = DateTime.now();
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

  final DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate; // 선택 Date

  void selectGender(Gender gender) {
    if (_selectedGender != gender) {
      _selectedGender = gender;
      notifyListeners();
    }
  }

  //datepicker
  DateTime _currentDate;
  final DateTime _start;
  final DateTime _end;

  SignUpDetailViewModel({
    required DateTime init,
    required DateTime start,
    required DateTime end,
  })  : _currentDate = init,
        _start = start,
        _end = end;

  DateTime get currentDate => _currentDate;
  DateTime get start => _start;
  DateTime get end => _end;

  void updateDate(DateTime date) {
    if (_currentDate != date) {
      _currentDate = date;
      notifyListeners();
    }
  }

  void selectAffiliation(Affiliation affiliation) {
    if (_selectedAffiliation != affiliation) {
      _selectedAffiliation = affiliation;
      notifyListeners();
    }
  }

  // 연도 업데이트
  void updateYear(int year) {
    if (_currentDate.year != year) {
      _currentDate = DateTime(year, _currentDate.month, _currentDate.day);
      notifyListeners();
    }
  }

  // 월 업데이트
  void updateMonth(int month) {
    if (_currentDate.month != month) {
      _currentDate = DateTime(_currentDate.year, month, _currentDate.day);
      notifyListeners();
    }
  }

  // 일 업데이트
  void updateDay(int day) {
    if (_currentDate.day != day) {
      _currentDate = DateTime(_currentDate.year, _currentDate.month, day);
      notifyListeners();
    }
  }

  List<int> getYearList() {
    return List<int>.generate(
        end.year - start.year + 1, (index) => start.year + index);
  }

  List<int> getMonthList() {
    return List<int>.generate(12, (index) => index + 1);
  }

  List<int> getDayList() {
    DateTime lastDateOfMonth =
        DateTime(currentDate.year, currentDate.month + 1, 0);
    return List<int>.generate(lastDateOfMonth.day, (index) => index + 1);
  }
}

enum Gender { none, female, male }

enum Affiliation { none, student, employee, freelancer, unemployed }
