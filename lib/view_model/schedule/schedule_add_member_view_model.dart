import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScheduleAddMemberViewModel with ChangeNotifier {
  // MARK: - keyword
  String _textCount = '';
  String get textKeywordCount => _textCount;

  void setKeywordDescription(String newTextCount) {
    if (_textCount != newTextCount) {
      _textCount = newTextCount;
      notifyListeners();
    }
  }

  // members list
  final TextEditingController textController = TextEditingController();
  final List<String> _members = [];
  List<String> get members => _members;

  void addKeyword(String keyword) {
    if (keyword.isNotEmpty && !_members.contains(keyword)) {
      _members.add(keyword);
      _keywordCount = '0/8';
      notifyListeners();
    }
  }

  String _currentInput = '';
  String get currentInput => _currentInput;

  void removeKeyword(String keyword) {
    _members.remove(keyword);
    notifyListeners();
  }

  void updateCurrentInput(String input) {
    if (input.length <= 6) {
      _currentInput = input;
      notifyListeners();
    }
  }

  // MARK: - Check
  bool get memberCheckCompleted => _members.isNotEmpty && _members.length <= 4;

  // keyword tap clear
  void memberClearSelection() {
    textController.clear();
    _textCount = '';
    _currentInput = '';
    _members.clear();
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
