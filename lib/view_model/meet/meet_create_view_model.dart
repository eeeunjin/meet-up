import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meet_up/model/chat_room_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/chat_repository.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';
import 'package:meet_up/service/remote/firebase_service.dart';
import 'package:meet_up/model/province_district_model.dart';

class MeetCreateViewModel with ChangeNotifier {
  // Room 관련 DB 동작을 하는 Repository
  final RoomRepository _roomRepository = RoomRepository();
  final UserRepository _userRepository = UserRepository();
  final ChatRepository _chatRepository = ChatRepository();
  final FirebaseRefs _firebaseRefs = FirebaseRefs();

  // MARK: - naming
  TextEditingController roomNamingTextController = TextEditingController();
  String _namingCount = '0/16';
  String get namingCount => _namingCount;

  void setNamingCount() {
    _namingCount = '${roomNamingTextController.text.length}/16';
    notifyListeners();
  }

  // naming check
  bool get namingCompleted {
    return roomNamingTextController.text.isNotEmpty;
  }

  // MARK: - detail
  TextEditingController descriptionTextController = TextEditingController();
  String _textCount = '0/50';
  String get textCount => _textCount;

  void setTextCount() {
    _textCount = '${descriptionTextController.text.length}/50';
    notifyListeners();
  }

  bool get detailCompleted {
    return descriptionTextController.text.isNotEmpty;
  }

  // MARK: - age
  final List<String> _selectedAges = [];

  List<String> get selectedAges => _selectedAges;

  void selectAge(String age, bool sendNotify) {
    if (_selectedAges.contains(age)) {
      // 이미 선택된 나이라면 리스트에서 제거
      _selectedAges.remove(age);
    } else {
      // 선택되지 않은 나이라면 리스트에 추가
      _selectedAges.add(age);
    }
    debugPrint('Selected ages: $_selectedAges');

    if (sendNotify) {
      notifyListeners();
    }
  }

  // MARK: - gender ratio

  RoomGenderRatio? _roomGenderRatio;
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

  RoomGenderRatio? get roomGenderRatio => _roomGenderRatio;

  // rules
  final Map<String, bool> _rulesQuestion = {
    '만남 시 SNS 공유': false,
    '만남 시 연락처 공유': false,
    '지인과 동반 신청': false,
    '첫 만남에 2차 이동': false,
    '저녁 시간대 만남': false,
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
  final List<String> _selectedMainCategoriesInCategoryPage = [];
  List<String> get selectedMainCategories => _selectedMainCategories;
  List<String> get selectedMainCategoriesInCategoryPage =>
      _selectedMainCategoriesInCategoryPage;

  final List<String> _selectedSubCategories = [];
  final List<String> _selectedSubCategoriesInCategoryPage = [];

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

  // 선택된 메인 카테고리 불러오기 (생성 페이지)
  String get selectedMainCategory {
    if (_selectedMainCategories.isNotEmpty) {
      return _selectedMainCategories.first;
    }
    return '';
  }

  // 선택된 서브 카테고리 불러오기 (생성 페이지)
  String get selectedSubCategory {
    if (_selectedSubCategories.isNotEmpty) {
      return _selectedSubCategories.first;
    }
    return '';
  }

  // 메인 카테고리 선택 (카테고리 페이지)
  void selectMainCategory(String category) {
    // 단일 선택
    _selectedMainCategoriesInCategoryPage.clear();
    _selectedSubCategoriesInCategoryPage.clear();
    _selectedMainCategoriesInCategoryPage.add(category);

    notifyListeners();
  }

  // 서브 카테고리 선택 (카테고리 페이지)
  void selectSubCategory(String subCategory) {
    // 상세 카테고리 선택 로직, 단일 선택
    _selectedSubCategoriesInCategoryPage.clear();
    _selectedSubCategoriesInCategoryPage.add(subCategory);
    notifyListeners();
  }

  // 해당 서브 카테고리가 선택됬는지 판별 (카테고리 페이지)
  bool isSubCategorySelected(String subCategory) {
    return _selectedSubCategoriesInCategoryPage.contains(subCategory);
  }

  // 저장 버튼을 누를 수 있는지 판별하는 함수 (카테고리 페이지)
  bool get isCategorySelectionCompleteInCategoryPage {
    if (_selectedMainCategoriesInCategoryPage.isNotEmpty &&
        _selectedMainCategoriesInCategoryPage.first == '기타') {
      return true;
    }
    return _selectedMainCategoriesInCategoryPage.isNotEmpty &&
        _selectedSubCategoriesInCategoryPage.isNotEmpty;
  }

  // 저장 버튼을 누를 수 있는지 판별하는 함수 (생성 페이지)
  bool get isCategorySelectionComplete {
    if (_selectedMainCategories.isNotEmpty &&
        _selectedMainCategories.first == '기타') {
      return true;
    } else if (_selectedMainCategories.isNotEmpty &&
        _selectedSubCategories.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // 카테고리 페이지의 정보를 생성 페이지로 넘기는 함수
  void setSelectedCategories() {
    _selectedMainCategories.clear();
    _selectedSubCategories.clear();
    _selectedMainCategories.add(_selectedMainCategoriesInCategoryPage.first);
    if (_selectedSubCategoriesInCategoryPage.isNotEmpty) {
      _selectedSubCategories.add(_selectedSubCategoriesInCategoryPage.first);
    }
    notifyListeners();
  }

  // MARK: - Filter area
  String _selectedProvinceInAreaPage = '';
  final ValueNotifier<String> _selectedProvinceNotifier = ValueNotifier('');
  String _selectedProvince = '';
  String get selectedProvince => _selectedProvince;

  String _selectedDistrictInAreaPage = '';
  final ValueNotifier<String> _selectedDistrictNotifier = ValueNotifier('');
  String _selectedDistrict = '';
  String get selectedDistrict => _selectedDistrict;

  String get selectedProvinceInAreaPage => _selectedProvinceInAreaPage;
  String get selectedDistrictInAreaPage => _selectedDistrictInAreaPage;

  ValueNotifier<String> get selectedProvinceNotifier =>
      _selectedProvinceNotifier;

  ValueNotifier<String> get selectedDistrictNotifier =>
      _selectedDistrictNotifier;

  set selectedProvinceInAreaPage(String province) {
    _selectedProvinceInAreaPage = province;
    _selectedProvinceNotifier.value = province;
    _selectedDistrictInAreaPage = '';
    _selectedDistrictNotifier.value = '';
    notifyListeners();
  }

  set selectedDistrictInAreaPage(String district) {
    _selectedDistrictInAreaPage = district;
    _selectedDistrictNotifier.value = district;
    notifyListeners();
  }

  set selectedProvince(String province) {
    _selectedProvince = province;
  }

  set selectedDistrict(String district) {
    _selectedDistrict = district;
  }

  List<String> getDistrictsByProvince(String province) {
    return ProvinceDistrict.entireDistricts[province] ?? [];
  }

  void clearSelection() {
    _selectedProvinceInAreaPage = ''; // 선택된 시/도 초기화
    _selectedDistrictInAreaPage = ''; // 선택된 시/도/군 초기화
    _selectedProvinceNotifier.value = '';
    _selectedDistrictNotifier.value = '';
    notifyListeners();
  }

  // 저장 버튼을 누를 수 있는지 판별하는 함수 (Area 페이지)
  bool get isLocationSelectionCompleteInAreaPage {
    return _selectedProvinceInAreaPage.isNotEmpty &&
        _selectedDistrictInAreaPage.isNotEmpty;
  }

  // 저장 버튼을 누를 수 있는지 판별하는 함수 (생성 페이지)
  bool get isLocationSelectionComplete {
    return _selectedProvince.isNotEmpty && _selectedDistrict.isNotEmpty;
  }

  // 확인을 누르면 Filter Area 페이지에서 Create View 페이지 변수로 정보 전달
  void setSelectedArea({required String province, required String district}) {
    _selectedProvince = province;
    _selectedDistrict = district;
    notifyListeners();
  }

  // MARK: - keywords
  List<String> _selectedKeywords = [];
  List<String> get selectedKeywords => _selectedKeywords;

  set selectedKeywords(List<String> keywords) {
    _selectedKeywords = keywords;
    notifyListeners();
  }

  // MARK: - createRoom
  Future<void> createRoom({required String uid}) async {
    // 카테고리 변환
    String mainCategory = convertCategoryToEng(
        isMainCategory: true, category: selectedMainCategory);
    String subCategory = convertCategoryToEng(
        isMainCategory: false, category: selectedSubCategory);

    // 나이대 변환
    List<String> roomAge = convertAgeToEng(ages: selectedAges);

    // 규칙 변환
    List<bool> roomRules = rules.values.toList();

    // DB에 정보 방 정보 추가
    // 방 정보 생성
    RoomModel roomModel = RoomModel(
      room_name: roomNamingTextController.text,
      room_category: mainCategory,
      room_category_detail: subCategory,
      room_region_province: selectedProvinceInAreaPage,
      room_region_district: selectedDistrictInAreaPage,
      room_keyword: selectedKeywords,
      room_description: descriptionTextController.text,
      room_age: roomAge,
      room_gender_ratio: roomGenderRatio!.name,
      room_rules: roomRules,
      room_creation_date: Timestamp.now(),
      room_owner_reference: _firebaseRefs.colRefUser.doc(uid),
      room_participant_reference: [],
      isScheduleDecided: false,
      room_meeting_review: [],
      recentMessage: '방이 생성되었습니다.',
      isRoomDeleted: false,
      isOwnerExit: false,
    );
    // 방 정보 저장
    final roomDocRef =
        await _roomRepository.createRoomDocument(data: roomModel);

    // 유저 정보에 자신이 만든 방 정보 추가
    // 유저의 방 정보 생성
    MyRoomModel myRoomModel = MyRoomModel(
      isMyRoom: true,
      isNew: true,
      room_reference: roomDocRef,
    );

    // 유저의 방 정보 저장
    await _userRepository.createMyRoomDocument(
      data: myRoomModel,
      uid: uid,
      roomId: roomDocRef.path.split('/').last,
    );

    // chatRoom Model 생성
    ChatRoomModel chatRoomModel = ChatRoomModel(
      room_reference: roomDocRef,
      isDeleted: false,
    );

    // chatRoom 생성
    await _chatRepository.createChatRoom(
      chatRoomModel,
      roomDocRef.id,
    );
  }

  // 카테고리를 한글에서 영어로 바꿔주는 함수
  String convertCategoryToEng({
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

  // 나이를 한글에서 영어로 바꿔주는 함수
  List<String> convertAgeToEng({required List<dynamic> ages}) {
    return selectedAges.map(
      (string) {
        switch (string) {
          case "20대":
            return RoomAge.twenties.name;
          case "30대":
            return RoomAge.thirties.name;
          case "40대":
            return RoomAge.fourties.name;
          case "50대":
            return RoomAge.fifties.name;
          default:
            return "Error";
        }
      },
    ).toList();
  }

  // MARK: -  Reset state
  void backClearSelection() {
    roomNamingTextController.clear();
    setNamingCount();
    _selectedKeywords.clear();
    descriptionTextController.clear();
    setTextCount();
    _selectedAges.clear();
    _roomGenderRatio = null;
    _rulesQuestion.forEach((key, value) => _rulesQuestion[key] = false);
    _selectedMainCategories.clear();
    _selectedSubCategories.clear();
    _selectedMainCategoriesInCategoryPage.clear();
    _selectedSubCategoriesInCategoryPage.clear();
    _selectedProvince = '';
    _selectedDistrict = '';
    _selectedProvinceInAreaPage = '';
    _selectedDistrictInAreaPage = '';
    _selectedProvinceNotifier.value = '';
    _selectedDistrictNotifier.value = '';
    notifyListeners();
  }

  // category tap clear
  void categoryClearSelection() {
    _selectedMainCategoriesInCategoryPage.clear();
    _selectedSubCategoriesInCategoryPage.clear();
    notifyListeners();
  }

  // location tap clear
  void locationClearSelection() {
    _selectedProvinceInAreaPage = '';
    _selectedDistrictInAreaPage = '';
    _selectedProvinceNotifier.value = '';
    _selectedDistrictNotifier.value = '';
    notifyListeners();
  }

  // MARK: - all check
  bool get allCheckCompleted {
    return namingCompleted &&
        isCategorySelectionComplete &&
        isLocationSelectionComplete &&
        detailCompleted &&
        ageCompleted &&
        roomGenderRatio != null;
  }

  // MARK: - check bottomsheet
  bool _allAgreed = false;
  bool get allAgreed => _allAgreed;

  bool _individualAgreement1 = false;
  bool _individualAgreement2 = false;
  bool _individualAgreement3 = false;
  bool get individualAgreement1 => _individualAgreement1;
  bool get individualAgreement2 => _individualAgreement2;
  bool get individualAgreement3 => _individualAgreement3;

  void setAllAgreed(bool agreed) {
    _allAgreed = agreed;
    _individualAgreement1 = agreed;
    _individualAgreement2 = agreed;
    _individualAgreement3 = agreed;
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

  void setIndividualAgreement3(bool agreed) {
    _individualAgreement3 = agreed;
    _checkAllAgreed();
    notifyListeners();
  }

  void _checkAllAgreed() {
    if (_individualAgreement1 &&
        _individualAgreement2 &&
        _individualAgreement3) {
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
