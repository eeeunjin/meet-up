import 'package:flutter/material.dart';

class SignUpDetailViewModel with ChangeNotifier {
  //
  // MARK: - Properties
  //
  Gender _selectedGender = Gender.none;
  Gender get selectedGender => _selectedGender; // 선택 성별

  final DateTime _selectedDate = DateTime.now();
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

  // MARK : - Page 3

  void _selectKeyword(String keyword, List<String> targetList) {
    if (targetList.contains(keyword)) {
      targetList.remove(keyword);
      notifyListeners();
    } else {
      if (targetList.length < 3) {
        targetList.add(keyword);
      }
      notifyListeners();
    }
  }

  bool get areBothSectionsCompleted {
    return areThreeRelationshipKeywordsSelected &&
        areThreeLifestyleKeywordsSelected;
  }

  // relationship
  List<String> selectedRelationshipKeywords = [];

  void selectRelationshipKeyword(String keyword) {
    _selectKeyword(keyword, selectedRelationshipKeywords);
  }

  // relationship_check
  bool get areThreeRelationshipKeywordsSelected {
    return selectedRelationshipKeywords.length == 3;
  }

  // lifestyle
  List<String> selectedLifestyleKeywords = [];

  void selectLifestyleKeyword(String keyword) {
    _selectKeyword(keyword, selectedLifestyleKeywords);
  }

  // lifestyle_check
  bool get areThreeLifestyleKeywordsSelected {
    return selectedLifestyleKeywords.length == 3;
  }
}

enum Gender { none, female, male }
