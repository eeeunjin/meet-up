import 'package:flutter/material.dart';
import 'package:meet_up/main.dart';

class CoinBuyViewModel with ChangeNotifier {
  CoinAmount? _coinAmount;

  CoinAmount? get coinAmount => _coinAmount;

  int _selectedNum = 1;

  int get selectedNum => _selectedNum;

  void setCoinAmount(CoinAmount? coinAmount) {
    _coinAmount = coinAmount;
    logger.d('coinAmount: $coinAmount');
    notifyListeners();
  }

  void setSelectedNum(int num) {
    _selectedNum = num;
    notifyListeners();
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
