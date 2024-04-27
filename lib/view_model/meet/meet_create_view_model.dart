import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/service/remote/firebase_service.dart';
import 'package:meet_up/model/province_district_model.dart';

class MeetCreateViewModel with ChangeNotifier {
  // Room 관련 DB 동작을 하는 Repository
  final RoomRepository _roomRepository = RoomRepository();
  final FirebaseRefs _firebaseRefs = FirebaseRefs();

  // naming
  String _roomNaming = '';

  String get roomNaming => _roomNaming;

  void namingContents(String newNamingCount) {
    if (_roomNaming != newNamingCount) {
      _roomNaming = newNamingCount;
      debugPrint('방 명 : $_roomNaming');
      notifyListeners();
    }
  }

  String get namingCount => '${_roomNaming.length}/16';

  // naming check
  bool get namingCompleted {
    return _roomNaming.trim().isNotEmpty;
  }

  // detail
  String _roomText = '';

  String get roomText => _roomText;

  void setDescription(String newTextCount) {
    if (_roomText != newTextCount) {
      _roomText = newTextCount;
      debugPrint('상세내용 : $_roomText');
      notifyListeners();
    }
  }

  String get textCount => '${_roomText.length}/50';

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
  RoomGenderRatio _roomGenderRatio = RoomGenderRatio.manOnly;

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

  RoomGenderRatio get roomGenderRatio => _roomGenderRatio;

  // rules
  final Map<String, bool> _rulesQuestion = {
    '만남 시 대화 녹음': false,
    '만남 후 앱을 통해 연락처 공유': false,
    '아는 지인과 동반 신청': false,
    '첫 만남에 2차 이동': false,
    '귀가 시 동성과 동행': false,
  };

  Map<String, bool> get rules => _rulesQuestion;

  void setRuleQuestion(String rule, bool agree) {
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
  final bool _isSelectedCategory = false;
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
    notifyListeners();
  }

  String get selectedMainCategory {
    if (_selectedMainCategories.isNotEmpty) {
      return _selectedMainCategories.first;
    }
    return '';
  }

  String get selectedSubCategory {
    if (_selectedSubCategories.isNotEmpty) {
      return _selectedSubCategories.first;
    }
    return '';
  }

  //Keyword

  String _textCount = '';

  String get textKeywordCount => _textCount;

  void setKeywordDescription(String newTextCount) {
    if (_textCount != newTextCount) {
      _textCount = newTextCount;
      notifyListeners();
    }
  }

  // 키워드 저장
  void saveKeywords() {
    debugPrint('$keywords');
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

  // check

  bool get keywordCheckComplted =>
      _keywords.isNotEmpty && _keywords.length <= 3;

  // MARK - Location
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

  set selectedProvince(String province) {
    _selectedProvince = province;
    _selectedProvinceNotifier.value = province;
    notifyListeners();
    debugPrint(' $province');
  }

  set selectedDistrict(String district) {
    _selectedDistrict = district;
    _selectedDistrictNotifier.value = district;
    notifyListeners();
    debugPrint(district);
  }

  List<String> getDistrictsByProvince(String province) {
    return ProvinceDistrict.entireDistricts[province] ?? [];
  }

  void clearSelection() {
    _selectedProvince = ''; // 선택된 시/도 초기화
    _selectedDistrict = ''; // 선택된 시/도/군 초기화
    _selectedProvinceNotifier.value = '';
    _selectedDistrictNotifier.value = '';
    notifyListeners();
  }

  bool get isSelectionComplete {
    return _selectedProvince.isNotEmpty && _selectedDistrict.isNotEmpty;
  }

  // MARK: - 방 만들기
  void createRoom(DocumentReference docRef) {
    List<String> roomAge = selectedAges.map((string) {
      switch (string) {
        case "20대":
          RoomAge.twenties;
        case "30대":
          RoomAge.thirties;
        case "40대":
          RoomAge.fourties;
        case "50대":
          RoomAge.fifties;
      }
      return string.toUpperCase();
    }).toList();

    List<bool> roomRules = rules.values.toList();

    RoomModel roomModel = RoomModel(
      room_name: roomNaming,
      room_category: RoomCategory.hobby.name,
      room_category_detail: Hobby.photography.name,
      room_region_province: "수정 필요",
      room_region_district: "수정 필요",
      room_keyword: ["수정 필요", "수정 필요", "수정 필요"],
      room_description: roomText,
      room_age: roomAge,
      room_gender_ratio: roomGenderRatio.name,
      room_rules: roomRules,
      room_creation_date: Timestamp.now(),
      room_owner_reference: docRef,
      room_participant_reference: [],
    );
  }
}
