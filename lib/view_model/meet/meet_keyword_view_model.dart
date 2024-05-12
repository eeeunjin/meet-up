import 'package:flutter/material.dart';

class MeetKeywordViewModel with ChangeNotifier {
  // MARK: - keyword
  String _textCount = '';
  String get textKeywordCount => _textCount;
  String get subTextCount => '${_textCount.length}/6';

  void setKeywordDescription(String newTextCount) {
    if (_textCount != newTextCount) {
      _textCount = newTextCount;
      notifyListeners();
    }
  }

  // keywords list
  final TextEditingController textController = TextEditingController();
  final List<String> _keywords = [];
  List<String> get keywords => _keywords;

  void addKeyword(String keyword) {
    if (keyword.isNotEmpty && !_keywords.contains(keyword)) {
      _keywords.add(keyword);
      notifyListeners();
    }
  }

  String _currentInput = '';
  String get currentInput => _currentInput;

  void removeKeyword(String keyword) {
    _keywords.remove(keyword);
    notifyListeners();
  }

  void updateCurrentInput(String input) {
    if (input.length <= 6) {
      _currentInput = input;
      notifyListeners();
    }
  }

  // check
  bool get keywordCheckComplted =>
      _keywords.isNotEmpty && _keywords.length <= 3;

  // keyword tap clear
  void keywordClearSelection() {
    _textCount = '';
    _currentInput = '';
    _keywords.clear();
    notifyListeners();
  }
}
