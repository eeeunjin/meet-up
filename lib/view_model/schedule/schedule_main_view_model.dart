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
}

enum SelectedPart { meetUp, personal }
