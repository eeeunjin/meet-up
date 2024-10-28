import 'package:flutter/material.dart';
import 'package:meet_up/model/good_history_model.dart';
import 'package:meet_up/repository/good_history_repository.dart';

class TicketBuyViewModel with ChangeNotifier {
  final GoodHistoryRepository _goodHistoryRepository = GoodHistoryRepository();

  bool? _isFixed;
  bool? get isFixed => _isFixed;

  int _selectedNum = 1;
  int get selectedNum => _selectedNum;

  void setTicketKind(bool isFixed) {
    _isFixed = isFixed;
    notifyListeners();
  }

  void setSelectedNum(int num) {
    _selectedNum = num;
    notifyListeners();
  }

  Future<void> createGoodHistory(
      {required GoodHistoryModel goodHistoryModel}) async {
    await _goodHistoryRepository.createGoodHistory(goodHistoryModel);
  }

  void resetState() {
    _isFixed = null;
    _selectedNum = 1;
    notifyListeners();
  }
}
