import 'package:flutter/material.dart';
import 'package:meet_up/model/province_district_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/repository/room_repository.dart';

class MeetFilterViewModel with ChangeNotifier {
  // MARK: - Category
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
  List<String> get selectedSubCategories => _selectedSubCategories;

  void selectSubCategory(String subCategory) {
    _selectedSubCategories.clear();
    _selectedSubCategories.add(subCategory);
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
    _selectedMainCategories.clear();
    _selectedMainCategories.add(category);
    _isSelectedCategory = true;

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

  // MARK: - Area
  String _selectedProvince = '';
  String _selectedProvinceInAreaPage = '';
  final ValueNotifier<String> _selectedProvinceNotifier = ValueNotifier('');

  String _selectedDistrict = '';
  String _selectedDistrictInAreaPage = '';
  final ValueNotifier<String> _selectedDistrictNotifier = ValueNotifier('');

  String get selectedProvince => _selectedProvince;
  String get selectedProvinceInAreaPage => _selectedProvinceInAreaPage;
  String get selectedDistrict => _selectedDistrict;
  String get selectedDistrictInAreaPage => _selectedDistrictInAreaPage;

  ValueNotifier<String> get selectedProvinceNotifier =>
      _selectedProvinceNotifier;

  ValueNotifier<String> get selectedDistrictNotifier =>
      _selectedDistrictNotifier;

  set selectedProvinceInAreaPage(String province) {
    _selectedDistrictInAreaPage = '';
    _selectedDistrictNotifier.value = '';
    _selectedProvinceInAreaPage = province;
    _selectedProvinceNotifier.value = province;
    notifyListeners();
  }

  set selectedDistrictInAreaPage(String district) {
    _selectedDistrictInAreaPage = district;
    _selectedDistrictNotifier.value = district;
    notifyListeners();
  }

  void clearAreaPageSelection() {
    _selectedProvinceInAreaPage = '';
    _selectedDistrictInAreaPage = '';
    _selectedProvinceNotifier.value = '';
    _selectedDistrictNotifier.value = '';
    notifyListeners();
  }

  void clearSelection() {
    _selectedProvince = ''; // 선택된 시/도 초기화
    _selectedDistrict = ''; // 선택된 시/도/군 초기화
    notifyListeners();
  }

  List<String> getDistrictsByProvince(String province) {
    return ProvinceDistrict.entireDistricts[province] ?? [];
  }

  bool get isAreaSelectionComplete {
    return _selectedProvinceInAreaPage.isNotEmpty &&
        _selectedDistrictInAreaPage.isNotEmpty;
  }

  bool get isAreaSelected {
    return _selectedProvince.isNotEmpty && _selectedDistrict.isNotEmpty;
  }

  void saveAreaFilterInfo() {
    _selectedProvince = _selectedProvinceInAreaPage;
    _selectedDistrict = _selectedDistrictInAreaPage;
    notifyListeners();
  }

  // MARK: - Age
  String _selectedAge = '';

  String get selectedAge => _selectedAge;

  void selectAge(String age) {
    _selectedAge = age;
    debugPrint('Selected age: $_selectedAge');
    notifyListeners();
  }

  // MARK: - Gender ratio
  RoomGenderRatio? _roomGenderRatio;

  void selectWomen4() {
    _roomGenderRatio = RoomGenderRatio.womanOnly;
    notifyListeners();
  }

  void selectWomen2Men2() {
    _roomGenderRatio = RoomGenderRatio.mixed;
    notifyListeners();
  }

  void selectMen4() {
    _roomGenderRatio = RoomGenderRatio.manOnly;
    notifyListeners();
  }

  RoomGenderRatio? get roomGenderRatio => _roomGenderRatio;

  // MARK: - Rules
  final Map<String, bool> _rulesQuestion = {
    '만남 시 SNS 공유': false,
    '만남 시 연락처 공유': false,
    '지인과 동반 신청': false,
    '첫 만남에 2차 이동': false,
    '저녁 시간대 만남': false,
  };

  Map<String, bool?> get rules => _rulesQuestion;
  void setRuleQuestion(String rule, bool agree) {
    if (_rulesQuestion[rule] != agree) {
      _rulesQuestion[rule] = agree;
      notifyListeners();
    }
  }

  int get numberOfSelectedRules {
    return _rulesQuestion.values.where((value) => value == true).length;
  }

  // MARK: - AllCheckCompleted

  bool get allCheckCompleted {
    bool ruleSelected =
        _rulesQuestion.values.any((isSelected) => isSelected == true);

    bool categoriesCompleted =
        isSelectedCategory || isCategorySelectionComplete;

    bool areaCompleted = isAreaSelected;

    bool ageCompleted = selectedAge.isNotEmpty;

    bool genderRatioCompleted = (roomGenderRatio != null);
    bool allCompleted = ruleSelected ||
        categoriesCompleted ||
        areaCompleted ||
        ageCompleted ||
        genderRatioCompleted;

    return allCompleted;
  }

  // MARK: - Filter
  bool get isAnyFilterSelected {
    return (_selectedMainCategories.isNotEmpty ||
        _selectedSubCategories.isNotEmpty ||
        _selectedProvince.isNotEmpty ||
        _selectedDistrict.isNotEmpty ||
        _selectedAge.isNotEmpty ||
        _roomGenderRatio != null ||
        numberOfSelectedRules > 0);
  }

  // 필터 초기화
  void clearAllFilters() {
    _selectedMainCategories.clear();
    _isSelectedCategory = false;
    _selectedSubCategories.clear();
    _selectedProvince = '';
    _selectedDistrict = '';
    _selectedAge = '';
    _roomGenderRatio = null;
    _rulesQuestion.forEach((key, value) => _rulesQuestion[key] = false);
    notifyListeners();
  }

  // 필터 Info로 정보를 변환해주는 함수
  FilterInfo getFilterInfo() {
    List<bool> rulesList = _rulesQuestion.values.toList();

    final roomCategory = convertCategoryToEng(
        isMainCategory: true,
        category: _selectedMainCategories.isNotEmpty
            ? _selectedMainCategories.first
            : '');
    final roomCategoryDetail = convertCategoryToEng(
        isMainCategory: false,
        category: _selectedSubCategories.isNotEmpty
            ? _selectedSubCategories.first
            : '');
    final roomAge = convertAgeToEng(age: _selectedAge);

    FilterInfo filterInfo = FilterInfo(
      room_category: roomCategory.isNotEmpty ? roomCategory : null,
      room_category_detail:
          roomCategoryDetail.isNotEmpty ? roomCategoryDetail : null,
      room_region_province: _selectedProvince != '' ? _selectedProvince : null,
      room_region_district: _selectedDistrict != '' ? _selectedDistrict : null,
      room_age: roomAge != '' ? roomAge : null,
      room_gender_ratio: _roomGenderRatio?.name,
      room_rules: _rulesQuestion.containsValue(true) ? rulesList : null,
    );

    return filterInfo;
  }

  // MARK: -  카테고리를 한글에서 영어로 바꿔주는 함수
  String convertCategoryToEng({
    required bool isMainCategory,
    required String category,
  }) {
    if (isMainCategory) {
      switch (category) {
        case "취미":
          return RoomCategory.hobby.name;
        case "운동":
          return RoomCategory.exercise.name;
        case "공부/학업":
          return RoomCategory.study.name;
        case "휴식/친목":
          return RoomCategory.socializing.name;
        case "기타":
          return RoomCategory.etc.name;
      }
    } else {
      switch (category) {
        case "여행":
          return Hobby.travel.name;
        case "맛집":
          return Hobby.foodie.name;
        case "연예인":
          return Hobby.celebrity.name;
        case "사진":
          return Hobby.photography.name;
        case "영화":
          return Hobby.movies.name;
        case "게임":
          return Hobby.gaming.name;

        case "축구":
          return Exercise.soccer.name;
        case "야구":
          return Exercise.baseball.name;
        case "농구":
          return Exercise.basketball.name;
        case "테니스":
          return Exercise.tennis.name;
        case "요가":
          return Exercise.yoga.name;
        case "헬스":
          return Exercise.fitness.name;
        case "탁구":
          return Exercise.pingpong.name;
        case "조깅":
          return Exercise.jogging.name;
        case "배드민턴":
          return Exercise.badminton.name;

        case "취업":
          return Study.employment.name;
        case "독서":
          return Study.reading.name;
        case "대학":
          return Study.university.name;
        case "미라클 모닝":
          return Study.miracleMorning.name;
        case "자격증":
          return Study.certification.name;
        case "아르바이트":
          return Study.partTimeJob.name;

        case "카페":
          return Socializing.cafe.name;
        case "산책":
          return Socializing.walking.name;
        case "저녁 식사":
          return Socializing.dinner.name;
      }
    }
    return "";
  }

  // MARK: -  나이를 한글에서 영어로 바꿔주는 함수
  String convertAgeToEng({required String age}) {
    switch (age) {
      case "20대":
        return RoomAge.twenties.name;
      case "30대":
        return RoomAge.thirties.name;
      case "40대":
        return RoomAge.fourties.name;
      case "50대":
        return RoomAge.fifties.name;
      default:
        return "";
    }
  }
}
