import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/province_district_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

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

  set selectedProvince(String province) {
    _selectedProvince = province;
    _selectedProvinceNotifier.value = province;
    notifyListeners();
    debugPrint('Selected province: $province');
  }

  set selectedDistrict(String district) {
    _selectedDistrict = district;
    _selectedDistrictNotifier.value = district;
    notifyListeners();
    debugPrint('Selected district: $district');
  }

  void clearSelection() {
    _selectedProvince = ''; // 선택된 시/도 초기화
    _selectedDistrict = ''; // 선택된 시/도/군 초기화
    _selectedProvinceNotifier.value = '';
    _selectedDistrictNotifier.value = '';
    notifyListeners();
  }

  List<String> getDistrictsByProvince(String province) {
    return ProvinceDistrict.entireDistricts[province] ?? [];
  }

  bool get isAreaSelectionComplete {
    return _selectedProvince.isNotEmpty && _selectedDistrict.isNotEmpty;
  }

  // MARK: - age
  String _selectedAge = '';

  String get selectedAge => _selectedAge;

  void selectAge(String age) {
    _selectedAge = age;
    debugPrint('Selected age: $_selectedAge');
    notifyListeners();
  }

  // MARK: - gender ratio
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

  // MARK: - detailedRules
  final Map<String, bool> _rulesQuestion = {
    '만남 시 대화 녹음': false,
    '만남 후 앱을 통해 연락처 공유': false,
    '아는 지인과 동반 신청': false,
    '첫 만남에 2차 이동': false,
    '귀가 시 동성과 동행': false,
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

// MARK: - bottom

  bool get allCheckCompleted {
    bool ruleSelected =
        _rulesQuestion.values.any((isSelected) => isSelected == true);

    bool categoriesCompleted =
        isSelectedCategory || isCategorySelectionComplete;

    bool areaCompleted = isAreaSelectionComplete;

    bool ageCompleted = selectedAge.isNotEmpty;

    bool genderRatioCompleted = (roomGenderRatio != null);
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
    return (_selectedMainCategories.isNotEmpty ||
            _selectedSubCategories.isNotEmpty ||
            _selectedProvince.isNotEmpty ||
            _selectedDistrict.isNotEmpty ||
            _selectedAge.isNotEmpty ||
            _roomGenderRatio != null ||
            numberOfSelectedRules > 0) &&
        isFilterApplied;
  }

  bool isFilterApplied = false;

  void setIsFilterApplied(bool isFilterApplied) {
    this.isFilterApplied = isFilterApplied;
    notifyListeners();
  }

// 필터 초기화
  void clearAllFilters() {
    _selectedMainCategories.clear();
    _selectedSubCategories.clear();
    _selectedProvince = '';
    _selectedDistrict = '';
    _selectedAge = '';
    _roomGenderRatio = null;
    _rulesQuestion.forEach((key, value) => _rulesQuestion[key] = false);
    selectedFilters.clear();
    setIsFilterApplied(false);
    notifyListeners();
  }

  // Filter management
  List<String> selectedFilters = [];

  void addFilter() {
    if (_selectedMainCategories.isNotEmpty) {
      selectedFilters.add(_selectedMainCategories.first);
    }
    if (_selectedSubCategories.isNotEmpty) {
      selectedFilters.add(_selectedSubCategories.first);
    }
    if (_selectedProvince.isNotEmpty && _selectedDistrict.isNotEmpty) {
      String combinedLocation = '$_selectedProvince > $_selectedDistrict';
      selectedFilters.add(combinedLocation);
    }
    if (_selectedAge.isNotEmpty) selectedFilters.add(_selectedAge);
    if (_roomGenderRatio != null) {
      switch (_roomGenderRatio!.name) {
        case "womanOnly":
          selectedFilters.add("여성 4");
        case "mixed":
          selectedFilters.add("여성 2, 남성 2");
        case "manOnly":
          selectedFilters.add("남성 4");
      }
    }
    if (_rulesQuestion.containsValue(true)) {
      {
        selectedFilters.add(
            "세부 규칙 ${_rulesQuestion.values.where((element) => element == true).length}");
      }
    }
    setIsFilterApplied(true);
    notifyListeners();
  }

  // MARK: - 방 이름 검색
  TextEditingController searchTextEditingControlller = TextEditingController();

  void submitSearchTextEditingControlller() {
    notifyListeners();
  }

  // MARK: - 방 만들기
  final UserRepository _userRepository = UserRepository();
  final RoomRepository _roomRepository = RoomRepository();

  // 내가 만든 방 불러오기
  Stream<List<RoomModel>> getMyRooms(String myUid) {
    return getMyRoomModel(myUid: myUid).map((snapshot) {
      return snapshot.docs.map((doc) {
        RoomModel room = RoomModel.fromJson(doc.data() as Map<String, dynamic>);
        return decodingRoomModel(roomModel: room); // 한글로 변환
      }).toList();
    });
  }

  // 내가 만든 방 스트림
  Stream<QuerySnapshot<Object?>> getMyRoomModel({required String myUid}) {
    return _userRepository.readMyRoomCollectionStream(uid: myUid);
  }

  // 방 정보를 한글로 변환
  RoomModel decodingRoomModel({required RoomModel roomModel}) {
    String mainCategory = convertCategoryToKor(
      isMainCategory: true,
      category: roomModel.room_category,
    );
    String subCategory = convertCategoryToKor(
      isMainCategory: false,
      category: roomModel.room_category_detail,
    );

    List<String> roomAges = convertAgeToKor(
      age: roomModel.room_age,
    );

    RoomModel decodedRoomModel = roomModel;
    decodedRoomModel.room_category = mainCategory;
    decodedRoomModel.room_category_detail = subCategory;
    decodedRoomModel.room_age = roomAges;

    return decodedRoomModel;
  }

// MARK: - 카테고리를 한글로 변환하는 함수
  String convertCategoryToKor({
    required bool isMainCategory,
    required String category,
  }) {
    if (isMainCategory) {
      switch (category) {
        case "hobby":
          return "취미";
        case "exercise":
          return "운동";
        case "study":
          return "공부/학업";
        case "socializing":
          return "휴식/친목";
        case "etc":
          return "기타";
      }
    } else {
      switch (category) {
        case "travel":
          return "여행";
        case "foodie":
          return "맛집";
        case "celebrity":
          return "연예인";
        case "photography":
          return "사진";
        case "movies":
          return "영화";
        case "gaming":
          return "게임";

        case "soccer":
          return "축구";
        case "baseball":
          return "야구";
        case "basketball":
          return "농구";
        case "tennis":
          return "테니스";
        case "yoga":
          return "요가";
        case "fitness":
          return "헬스";
        case "pingpong":
          return "탁구";
        case "jogging":
          return "조깅";
        case "badminton":
          return "배드민턴";

        case "employment":
          return "취업";
        case "reading":
          return "독서";
        case "university":
          return "대학";
        case "miracleMorning":
          return "미라클 모닝";
        case "certification":
          return "자격증";
        case "partTimeJob":
          return "아르바이트";

        case "cafe":
          return "카페";
        case "walking":
          return "산책";
        case "dinner":
          return "저녁 식사";
      }
    }
    return "";
  }

  // MARK: - 나이를 한글로 변환하는 함수
  List<String> convertAgeToKor({required List<dynamic> age}) {
    List<String> roomAge = age.map((string) {
      switch (string) {
        case "twenties":
          return "20대";
        case "thirties":
          return "30대";
        case "fourties":
          return "40대";
        case "fifties":
          return "50대";
        default:
          return "Error";
      }
    }).toList();

    return roomAge;
  }

  // MARK: - 다른 사람들 방 불러오는 함수
  Stream<QuerySnapshot<Object?>> getOthersRoomModel({required String myUid}) {
    return _roomRepository.readRoomCollectionStream(myUid: myUid);
  }

  // MARK: - 다른 사람들 방 불러오는 함수 (필터 적용)
  Stream<QuerySnapshot<Object?>> getOthersRoomModelByFilter({
    required String myUid,
    int? limit,
  }) {
    RoomRepository roomRepository = RoomRepository();
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

    Stream<QuerySnapshot<Object?>> roomCollectionStream;
    if (limit == null) {
      roomCollectionStream = roomRepository.readRoomCollectionStream(
        filterInfo: filterInfo,
        myUid: myUid,
      );
    } else {
      roomCollectionStream = roomRepository.readRoomCollectionStream(
        limit: limit,
        filterInfo: filterInfo,
        myUid: myUid,
      );
    }
    return roomCollectionStream;
  }

  // MARK: -  카테고리를 한글에서 영어로 바꿔주는 함수
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

  // MARK: - 상세정보 불러오면서 참여자 정보 가져오는 함수
  Future<void> getParticipantInfo(
      {required List<DocumentReference> docRefs}) async {
    List<UserModel> userModels = List.empty(growable: true);
    for (DocumentReference docRef in docRefs) {
      userModels
          .add(await _userRepository.readUserDocumentByDocRef(docRef: docRef));
    }
    for (UserModel userModel in userModels) {
      debugPrint(userModel.nickname);
      debugPrint(userModel.gender);
    }
  }

  // MARK: - 입장 요청을 보내는 함수
  Future<void> sendRoomEnterRequest({
    required String myUid,
    required RoomModel roomModel,
    required String roomId,
  }) async {
    debugPrint("입장 요청 보내기 ($myUid) (${roomModel.room_name} $roomId)");
    // 현재 시간
    Timestamp now = Timestamp.now();

    // DateTime으로 변환
    DateTime nowDateTime = now.toDate();

    // 현재 시간으로부터 24시간 뒤의 시간을 계산
    DateTime twentyFourHoursLaterDateTime =
        nowDateTime.add(const Duration(hours: 24));

    // DateTime을 Timestamp로 다시 변환하여 Firestore에 저장할 수 있도록 함
    Timestamp twentyFourHoursLater =
        Timestamp.fromDate(twentyFourHoursLaterDateTime);

    // 방 정보에 추가 되는 입장 요청 정보
    EnterRequestModel erModel = EnterRequestModel(
      end_date_time: twentyFourHoursLater,
      requester_uid: myUid,
      isAccepted: false,
    );

    // 내 계정에 저장되는 입장 요청 정보
    MyEnterRequestModel myEnterRequestModel = MyEnterRequestModel(
      isAccepted: false,
      room_id: roomId,
    );

    debugPrint("-------------------------");

    // 해당 room document의 roomEnterRequest 정보를 추가
    String requestID = await _roomRepository.createEnterRequestDocument(
      roomId: roomId,
      data: erModel,
    );

    debugPrint("입장 요청 완료 (방 정보에 추가)");

    // 해당 user document의 myEnterReuqest 정보를 추가
    await _userRepository.createMyEnterRequestDocument(
      data: myEnterRequestModel,
      uid: myUid,
      myEnterRequestId: requestID,
    );

    debugPrint("입장 요청 완료 (유저 정보에 추가)");

    debugPrint("-------------------------");
  }
}
