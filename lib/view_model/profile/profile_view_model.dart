import 'package:flutter/material.dart';

class ProfileViewModel with ChangeNotifier {
  String _selectedRank = 'Novice';

  String get selectedRank => _selectedRank;

  void selectRank(String rank) {
    _selectedRank = rank;
    notifyListeners();
  }

  Map<String, List<String>> get rankBenefits {
    return {
      'Beginner': ['추가 할인 0%'],
      'Novice': ['추가 할인 2%', '최초 달성 시, 만남권 1개 지급'],
      'Intermediate': ['추가 할인 4%', '최초 달성 시, 만남권 1개 지급'],
      'Advanced': ['추가 할인 6%', '최초 달성 시, 만남권 1개 지급'],
      'Master': ['추가 할인 8%', '최초 달성 시, 만남권 2개 지급'],
    };
  }
}
