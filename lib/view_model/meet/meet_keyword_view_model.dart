import 'package:flutter/material.dart';

class MeetKeyWordViewModel with ChangeNotifier {
  String _textCount = '';

  String get textCount => _textCount;

  void setDescription(String newTextCount) {
    if (_textCount != newTextCount) {
      _textCount = newTextCount;
      notifyListeners();
    }
  }

  String get subTextCount => '${_textCount.length}/6';

  // list
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

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
