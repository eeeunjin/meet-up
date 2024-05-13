import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MeetKeywordViewModel with ChangeNotifier {
  // MARK: - keyword
  String _textCount = '';
  String get textKeywordCount => _textCount;

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
      _keywordCount = '0/8';
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

  // MARK: - keyword 입력 읽어오기
  TextEditingController keywordTextController = TextEditingController();
  String _keywordCount = '0/8';
  String get keywordCount => _keywordCount;

  void setKeywordCount() {
    _keywordCount = '${textController.text.length}/8';
    notifyListeners();
  }
}
