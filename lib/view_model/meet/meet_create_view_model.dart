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
  bool _isSelectedCategory = false;
  bool get isSelectedCategory => _isSelectedCategory;

  String? _selectedMainCategory;
  String? get selectedMainCategory => _selectedMainCategory;

  final Map<String, List<String>> _subCategoriesMap = {
    '취미': ['여행', '맛집', '연예인', '사진', '영화', '게임'],
    '운동': ['축구', '야구', '농구', '테니스', '요가', '헬스', '탁구', '조깅', '배드민턴'],
    '공부/학업': ['취업', '독서', '대학', '미라클 모닝', '자격증', '아르바이트'],
    '휴식/친목': ['카페', '산책', '저녁 식사'],
    '기타': [],
  };

  List<String> getSubCategories(String mainCategory) {
    return _subCategoriesMap[mainCategory] ?? [];
  }

  void selectSubCategory(String subCategory) {
    notifyListeners();
  }

  void mainCategorySelection(String category) {
    if (_selectedMainCategory == category) {
      _selectedMainCategory = null;
      _isSelectedCategory = false;
    } else {
      _selectedMainCategory = category;
      _isSelectedCategory = true;
    }
    notifyListeners();
  }
}
