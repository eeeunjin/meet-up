import 'package:flutter/material.dart';

class ProfileViewModel with ChangeNotifier {
  String _selectedRank = 'Novice';

  String get selectedRank => _selectedRank;

  void selectRank(String rank) {
    _selectedRank = rank;
    notifyListeners();
  }
}
