import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';
import 'package:meet_up/service/remote/firebase_service.dart';
import 'package:meet_up/model/province_district_model.dart';

class MeetCreateViewModel with ChangeNotifier {
  // Room 관련 DB 동작을 하는 Repository
  final RoomRepository _roomRepository = RoomRepository();
  final UserRepository _userRepository = UserRepository();
  final FirebaseRefs _firebaseRefs = FirebaseRefs();

  // MARK: - naming
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

  // MARK: - detail
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

  bool get detailCompleted {
    return _roomText.trim().isNotEmpty;
  }

  // MARK: - age
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

  // MARK: - gender ratio
  RoomGenderRatio _roomGenderRatio = RoomGenderRatio.womanOnly;
  bool get ageCompleted => selectedAges.isNotEmpty;

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

  // MARK: - categoryPage
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

    // 기타 골랐을 시, 이전 내역 초기화
    if (category == '기타') {
      _selectedSubCategories.clear();
    }
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

  String findCategory({
    required bool isMainCategory,
    required String category,
  }) {
    if (isMainCategory) {
      switch (selectedMainCategory) {
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
      switch (selectedSubCategory) {
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

  // MARK: - keyword

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

  // MARK: - location
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

  bool get isLocationSelectionComplete {
    return _selectedProvince.isNotEmpty && _selectedDistrict.isNotEmpty;
  }

  // MARK: - createRoom
  Future<void> createRoom({required String uid}) async {
    print("내가 왔따");
    // 카테고리 변환
    String mainCategory =
        findCategory(isMainCategory: true, category: selectedMainCategory);
    String subCategory =
        findCategory(isMainCategory: false, category: selectedSubCategory);

    // 나이대 변환
    List<String> roomAge = selectedAges.map((string) {
      switch (string) {
        case "20대":
          RoomAge.twenties.name;
        case "30대":
          RoomAge.thirties.name;
        case "40대":
          RoomAge.fourties.name;
        case "50대":
          RoomAge.fifties.name;
      }
      return string.toUpperCase();
    }).toList();

    // 규칙 변환
    List<bool> roomRules = rules.values.toList();

    // DB에 정보 방 정보 추가
    // 방 정보 생성
    RoomModel roomModel = RoomModel(
      room_name: roomNaming,
      room_category: mainCategory,
      room_category_detail: subCategory,
      room_region_province: selectedProvince,
      room_region_district: selectedDistrict,
      room_keyword: keywords,
      room_description: roomText,
      room_age: roomAge,
      room_gender_ratio: roomGenderRatio.name,
      room_rules: roomRules,
      room_creation_date: Timestamp.now(),
      room_owner_reference: _firebaseRefs.colRefUser.doc(uid),
      room_participant_reference: [],
    );
    // 방 정보 저장
    final roomDocRef =
        await _roomRepository.createRoomDocument(data: roomModel);

    // 유저 정보에 자신이 만든 방 정보 추가
    // 유저의 방 정보 생성
    final myRoomModel = MyRoomModel(
      isMyRoom: true,
      room_reference: roomDocRef,
    );
    // 유저의 방 정보 저장
    _userRepository.createMyRoomDocument(
      data: myRoomModel,
      uid: uid,
      roomId: roomDocRef.path.split('/').last,
    );
  }

  // MARK: -  Reset state
  void backClearSelection() {
    _roomNaming = '';
    _roomText = '';
    _selectedAges.clear();
    _roomGenderRatio = RoomGenderRatio.womanOnly;
    _rulesQuestion.forEach((key, value) => _rulesQuestion[key] = false);
    _selectedMainCategories.clear();
    _selectedSubCategories.clear();
    _textCount = '';
    _keywords.clear();
    _currentInput = '';
    _selectedProvince = '';
    _selectedDistrict = '';
    _selectedProvinceNotifier.value = '';
    _selectedDistrictNotifier.value = '';
    notifyListeners();
  }

  // category tap clear
  void categoryClearSelection() {
    _selectedMainCategories.clear();
    _selectedSubCategories.clear();
    notifyListeners();
  }

  // location tap clear
  void locationClearSelection() {
    _selectedProvince = '';
    _selectedDistrict = '';
    _selectedProvinceNotifier.value = '';
    _selectedDistrictNotifier.value = '';
    notifyListeners();
  }

  // keyword tap clear
  void keywordClearSelection() {
    _textCount = '';
    _currentInput = '';
    _keywords.clear();
    notifyListeners();
  }

  // MARK: - all check
  bool get allCheckCompleted {
    return namingCompleted &&
        isCategorySelectionComplete &&
        isLocationSelectionComplete &&
        keywordCheckComplted &&
        detailCompleted &&
        ageCompleted;
  }

  // MARK: - check bottomsheet
  bool _allAgreed = false;
  bool get allAgreed => _allAgreed;

  bool _individualAgreement1 = false;
  bool _individualAgreement2 = false;
  bool get individualAgreement1 => _individualAgreement1;
  bool get individualAgreement2 => _individualAgreement2;

  void setAllAgreed(bool agreed) {
    _allAgreed = agreed;
    _individualAgreement1 = agreed;
    _individualAgreement2 = agreed;
    notifyListeners();
  }

  void setIndividualAgreement1(bool agreed) {
    _individualAgreement1 = agreed;
    _checkAllAgreed();
    notifyListeners();
  }

  void setIndividualAgreement2(bool agreed) {
    _individualAgreement2 = agreed;
    _checkAllAgreed();
    notifyListeners();
  }

  void _checkAllAgreed() {
    if (_individualAgreement1 && _individualAgreement2) {
      _allAgreed = true;
    } else {
      _allAgreed = false;
    }
  }

  bool get isAllAgreed {
    return _allAgreed &&
        individualAgreement1 &&
        individualAgreement2 /* ... && individualAgreementN */;
  }
}
