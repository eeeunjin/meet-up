import 'package:flutter/material.dart';

class MeetCreateViewModel with ChangeNotifier {
  // naming
  String _namingCount = '';

  String get namingCount => _namingCount;

  void countNaming(String newNamingCount) {
    if (_namingCount != newNamingCount) {
      _namingCount = newNamingCount;
      notifyListeners();
    }
  }

  String get subNamingCount => '${_namingCount.length}/16';

  // naming check
  bool get namingCompleted {
    return _namingCount.trim().isNotEmpty;
  }

  // detail
  String _textCount = '';

  String get textCount => _textCount;

  void setDescription(String newTextCount) {
    if (_textCount != newTextCount) {
      _textCount = newTextCount;
      notifyListeners();
    }
  }

  String get subTextCount => '${_textCount.length}/50';

  // age
  final List<String> _selectedAges = [];

  List<String> get selectedAges => _selectedAges;

  void selectAge(String age) {
    if (_selectedAges.contains(age)) {
      // 이미 선택된 나이라면 리스트에서 제거
      _selectedAges.remove(age);
    } else {
      // 선택되지 않은 나이라면 리스트에 추가
      _selectedAges.add(age);
    }
    debugPrint('Selected ages: $_selectedAges');
    notifyListeners();
  }

  // gender ratio
  bool _isWomen4Selected = false;
  bool _isWomen2Men2Selected = false;
  bool _isMen4Selected = false;

  void selectWomen4() {
    _isWomen4Selected = true;
    _isWomen2Men2Selected = false;
    _isMen4Selected = false;
    notifyListeners();
  }

  void selectWomen2Men2() {
    _isWomen4Selected = false;
    _isWomen2Men2Selected = true;
    _isMen4Selected = false;
    notifyListeners();
  }

  void selectMen4() {
    _isWomen4Selected = false;
    _isWomen2Men2Selected = false;
    _isMen4Selected = true;
    notifyListeners();
  }

  bool get isWomen4Selected => _isWomen4Selected;
  bool get isWomen2Men2Selected => _isWomen2Men2Selected;
  bool get isMen4Selected => _isMen4Selected;

  // rules
  final Map<String, bool?> _rulesQuestion = {
    '만남 시 대화 녹음': null,
    '만남 후 앱을 통해 연락처 공유': null,
    '아는 지인과 동반 신청': null,
    '첫 만남에 2차 이동': null,
    '귀가 시 동성과 동행': null,
  };

  Map<String, bool?> get rules => _rulesQuestion;

  void setRuleQuestion(String rule, bool? agree) {
    if (_rulesQuestion[rule] != agree) {
      _rulesQuestion[rule] = agree;
      notifyListeners();
    }
  }

  // check

  bool get allCheckCompleted {
    return namingCompleted;
  }

  // MARK - CategoryPage
  // 상세 카테고리
  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  set selectedCategory(String? value) {
    _selectedCategory = value;
    notifyListeners();
  }

  // age
  List<bool> isSelected = [false, false, false, false];

  void toggleSelection(int index) {
    isSelected[index] = !isSelected[index];
    notifyListeners();
  }

  // 세부규칙
  List<bool> selectedRules = [false, false, false, false, false];

  void toggleRule(int index) {
    selectedRules[index] = !selectedRules[index];
  }
}
