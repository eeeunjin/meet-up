import 'package:flutter/material.dart';

class ScheduleMainViewModel with ChangeNotifier {
  // Main

  // meetUp을 기본 페이지로
  SelectedPart _selectedPart = SelectedPart.meetUp;

  SelectedPart get selectedPart => _selectedPart;

  void selectMeetUp() {
    if (_selectedPart != SelectedPart.meetUp) {
      _selectedPart = SelectedPart.meetUp;
      notifyListeners();
    }
  }

  void selectPersonal() {
    if (_selectedPart != SelectedPart.personal) {
      _selectedPart = SelectedPart.personal;
      notifyListeners();
    }
  }

  // MARK - 개인 일정 추가

  // 일정
  String _roomNaming = '';

  String get roomNaming => _roomNaming;

  void namingContents(String newNamingCount) {
    if (_roomNaming != newNamingCount) {
      _roomNaming = newNamingCount;
      notifyListeners();
    }
  }

  // naming check
  bool get namingCompleted {
    return _roomNaming.trim().isNotEmpty;
  }

  // datePicker
  bool _isDatePanelExpanded = false;

  bool get isDatePanelExpanded => _isDatePanelExpanded;

  // ExpansionPanel 토글
  void toggleDatePanel() {
    _isDatePanelExpanded = !_isDatePanelExpanded; // 상태 반전
    notifyListeners();
  }

  // timePicker
  bool _isTimePanelExpanded = false;

  bool get isTimePanelExpanded => _isTimePanelExpanded;

  // ExpansionPanel 토글
  void toggleTimePanel() {
    _isTimePanelExpanded = !_isTimePanelExpanded;
    notifyListeners();
  }

  // check

  bool get allCheckCompleted {
    return namingCompleted;
  }
}

enum SelectedPart { meetUp, personal }
