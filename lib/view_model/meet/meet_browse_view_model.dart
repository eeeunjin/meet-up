import 'package:flutter/material.dart';
import 'package:meet_up/model/province_district_model.dart';

class MeetBrowseViewModel with ChangeNotifier {
  // MARK: - category
  bool _isSelectedCategory = false;
  bool get isSelectedCategory => _isSelectedCategory;

  final List<String> _selectedMainCategories = [];
  List<String> get selectedMainCategories => _selectedMainCategories;

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

  final List<String> _selectedSubCategories = [];

  void selectSubCategory(String subCategory) {
    // 상세 카테고리 선택 로직, 단일 선택
    _selectedSubCategories.clear();
    _selectedSubCategories.add(subCategory);
    addFilter(subCategory);
    notifyListeners();
  }

  bool isSubCategorySelected(String subCategory) {
    return _selectedSubCategories.contains(subCategory);
  }

  bool get isCategorySelectionComplete {
    if (_selectedMainCategories.isNotEmpty &&
        _selectedMainCategories.first == '기타') {
      return true;
    }
    return _selectedMainCategories.isNotEmpty &&
        _selectedSubCategories.isNotEmpty;
  }

  void selectMainCategory(String category) {
    // 단일 선택
    _selectedMainCategories.clear();
    _selectedMainCategories.add(category);
    _isSelectedCategory = true;
    addFilter(category);

    // 기타 골랐을 시, 이전 내역 초기화
    if (category == '기타') {
      _selectedSubCategories.clear();
    }
    notifyListeners();
  }

  String get selectedMainCategory {
    return _selectedMainCategories.isNotEmpty
        ? _selectedMainCategories.first
        : '';
  }

  String get selectedSubCategory {
    return _selectedSubCategories.isNotEmpty
        ? _selectedSubCategories.first
        : '';
  }

  // MARK: - area
  String _selectedProvince = '';
  final ValueNotifier<String> _selectedProvinceNotifier = ValueNotifier('');

  String _selectedDistrict = '';
  final ValueNotifier<String> _selectedDistrictNotifier = ValueNotifier('');

  String get selectedProvince => _selectedProvince;
  String get selectedDistrict => _selectedDistrict;

  ValueNotifier<String> get selectedProvinceNotifier =>
      _selectedProvinceNotifier;

  ValueNotifier<String> get selectedDistrictNotifier =>
      _selectedDistrictNotifier;

  void updateLocationFilter() {
    selectedFilters.removeWhere((item) => item.contains(' > '));
    if (_selectedProvince.isNotEmpty && _selectedDistrict.isNotEmpty) {
      String combinedLocation = '$_selectedProvince > $_selectedDistrict';
      selectedFilters.add(combinedLocation);
    }
    notifyListeners();
  }

  set selectedProvince(String province) {
    _selectedProvince = province;
    _selectedProvinceNotifier.value = province;
    if (_selectedDistrict.isNotEmpty) {
      // 구/군이 이미 선택된 경우에만 업데이트
      updateLocationFilter();
    }
    notifyListeners();
    debugPrint('Selected province: $province');
  }

  set selectedDistrict(String district) {
    _selectedDistrict = district;
    _selectedDistrictNotifier.value = district;
    if (_selectedProvince.isNotEmpty) {
      // 시/도가 이미 선택된 경우에만 업데이트
      updateLocationFilter();
    }
    notifyListeners();
    debugPrint('Selected district: $district');
  }

  void clearSelection() {
    _selectedProvince = ''; // 선택된 시/도 초기화
    _selectedDistrict = ''; // 선택된 시/도/군 초기화
    _selectedProvinceNotifier.value = '';
    _selectedDistrictNotifier.value = '';
    selectedFilters.removeWhere((item) => item.contains(' > ')); // 지역 필터 제거
    notifyListeners();
  }

  List<String> getDistrictsByProvince(String province) {
    return ProvinceDistrict.entireDistricts[province] ?? [];
  }

  bool get isSelectionComplete {
    return _selectedProvince.isNotEmpty && _selectedDistrict.isNotEmpty;
  }

  // MARK: - age
  String _selectedAge = '';

  String get selectedAge => _selectedAge;

  void selectAge(String age) {
    _selectedAge = age;
    addFilter(age);
    debugPrint('Selected age: $_selectedAge');
    notifyListeners();
  }

  // MARK: - gender ratio
  bool _isWomen4Selected = false;
  bool _isWomen2Men2Selected = false;
  bool _isMen4Selected = false;

  void selectWomen4() {
    _isWomen4Selected = true;
    _isWomen2Men2Selected = false;
    _isMen4Selected = false;
    addFilter("여성4");
    notifyListeners();
  }

  void selectWomen2Men2() {
    _isWomen4Selected = false;
    _isWomen2Men2Selected = true;
    _isMen4Selected = false;
    addFilter("남성2,여성2");
    notifyListeners();
  }

  void selectMen4() {
    _isWomen4Selected = false;
    _isWomen2Men2Selected = false;
    _isMen4Selected = true;
    addFilter("남성4");
    notifyListeners();
  }

  bool get isWomen4Selected => _isWomen4Selected;
  bool get isWomen2Men2Selected => _isWomen2Men2Selected;
  bool get isMen4Selected => _isMen4Selected;

  // MARK: - detailedRules
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
      updateRulesFilter();
      notifyListeners();
    }
  }

  int get numberOfSelectedRules {
    return _rulesQuestion.values.where((value) => value == true).length;
  }

  void updateRulesFilter() {
    int count = numberOfSelectedRules;
    selectedFilters.removeWhere((item) => item.startsWith('세부 규칙 '));
    if (count > 0) {
      selectedFilters.add('세부 규칙 $count');
    }
    notifyListeners();
  }

// MARK: - bottom

  bool get allCheckCompleted {
    bool ruleSelected =
        _rulesQuestion.values.any((isSelected) => isSelected == true);

    bool categoriesCompleted =
        isSelectedCategory || isCategorySelectionComplete;

    bool areaCompleted = isSelectionComplete;

    bool ageCompleted = selectedAge.isNotEmpty;

    bool genderRatioCompleted =
        isWomen4Selected || isWomen2Men2Selected || isMen4Selected;

    bool allCompleted = ruleSelected ||
        categoriesCompleted ||
        areaCompleted ||
        ageCompleted ||
        genderRatioCompleted;

    return allCompleted;
  }

// MARK: - filter

// 필터 선택 여부 체크
  bool get isAnyFilterSelected {
    return _selectedMainCategories.isNotEmpty ||
        _selectedSubCategories.isNotEmpty ||
        _selectedProvince.isNotEmpty ||
        _selectedDistrict.isNotEmpty ||
        _selectedAge.isNotEmpty ||
        _isWomen4Selected ||
        _isWomen2Men2Selected ||
        _isMen4Selected ||
        numberOfSelectedRules > 0;
  }

// 필터 초기화
  void clearAllFilters() {
    _selectedMainCategories.clear();
    _selectedSubCategories.clear();
    _selectedProvince = '';
    _selectedDistrict = '';
    _selectedAge = '';
    _isWomen4Selected = false;
    _isWomen2Men2Selected = false;
    _isMen4Selected = false;
    _rulesQuestion.forEach((key, value) => _rulesQuestion[key] = null);
    selectedFilters.clear();
    notifyListeners();
  }

  // Filter management
  List<String> selectedFilters = [];

  void addFilter(String filter) {
    if (!selectedFilters.contains(filter)) {
      selectedFilters.add(filter);
      notifyListeners();
    }
  }

  void removeFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
      notifyListeners();
    }
  }
}
