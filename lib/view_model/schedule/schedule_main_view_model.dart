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

  // datePicker
  bool _isDatePanelExpanded = false;

  bool get isDatePanelExpanded => _isDatePanelExpanded;

  // ExpansionPanel을 토글하는 함수
  void toggleDatePanel() {
    _isDatePanelExpanded = !_isDatePanelExpanded; // 상태를 반전시킵니다.
    notifyListeners(); // 위젯들에게 상태 변경을 알립니다.
  }
}

enum SelectedPart { meetUp, personal }
