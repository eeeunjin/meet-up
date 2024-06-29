import 'package:flutter/material.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/good_history_model.dart';
import 'package:meet_up/repository/good_history_repository.dart';

class CoinBuyViewModel with ChangeNotifier {
  GoodHistoryRepository _goodHistoryRepository = GoodHistoryRepository();

  CoinAmount? _coinAmount;
  CoinAmount? get coinAmount => _coinAmount;

  int _selectedNum = 1;
  int get selectedNum => _selectedNum;

  String purchaseStatus = 'init'; // init, purchased, error, pending, canceled

  void setCoinAmount(CoinAmount? coinAmount) {
    _coinAmount = coinAmount;
    logger.d('coinAmount: $coinAmount');
    notifyListeners();
  }

  void setSelectedNum(int num) {
    _selectedNum = num;
    notifyListeners();
  }

  void setPurchaseStatus(String status) {
    purchaseStatus = status;
    notifyListeners();
  }

  Future<void> createGoodHistory(
      {required GoodHistoryModel goodHistoryModel}) async {
    await _goodHistoryRepository.createGoodHistory(goodHistoryModel);
  }

  void resetState() {
    _coinAmount = null;
    _selectedNum = 1;
    notifyListeners();
  }
}

enum CoinAmount {
  oneThousand,
  fourThousand,
}
