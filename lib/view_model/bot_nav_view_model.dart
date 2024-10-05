import 'package:flutter/material.dart';

class BottomNavigationBarViewModel with ChangeNotifier {
  int _index = 0; // 초기값 meet으로 설정
  final List<int> _history = [0]; // meet 인덱스

  bool _isHidden = false;
  bool get isHidden => _isHidden;

  void setIsHidden(bool isHidden) {
    _isHidden = isHidden;
    notifyListeners();
  }

  int get currentIndex => _index;

  void changeIndex(int index) {
    // 페이지 이동
    updateCurrentPage(index);
  }

  updateCurrentPage(int index) {
    if (_history.last != index) {
      _history.add(index);
    }
    _index = index;
    notifyListeners();
  }

  Future<bool> popAction() async {
    //뒤로가기 두 번 해야 종료
    if (_history.isEmpty) {
      return true;
    } else {
      _history.removeLast();
      _index = _history.last;
      notifyListeners();
      return false;
    }
  }
}
