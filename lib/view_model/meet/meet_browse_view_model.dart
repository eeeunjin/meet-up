import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

class MeetBrowseViewModel with ChangeNotifier {
  // Filter management
  List<String> selectedFilters = [];

  void clearSelectedFilters() {
    selectedFilters.clear();
    isFilterApplied = false;
    notifyListeners();
  }

  bool isFilterApplied = false;

  void setIsFilterApplied(bool isFilterApplied) {
    this.isFilterApplied = isFilterApplied;
    notifyListeners();
  }

  void addFilter({
    required List<String> selectedMainCategories,
    required List<String> selectedSubCategories,
    required String selectedProvince,
    required String selectedDistrict,
    required String selectedAge,
    required RoomGenderRatio? roomGenderRatio,
    required Map<String, bool?> selectedRules,
  }) {
    if (selectedMainCategories.isNotEmpty) {
      selectedFilters.add(selectedMainCategories.first);
    }
    if (selectedSubCategories.isNotEmpty) {
      selectedFilters.add(selectedSubCategories.first);
    }
    if (selectedProvince.isNotEmpty && selectedDistrict.isNotEmpty) {
      String combinedLocation = '$selectedProvince > $selectedDistrict';
      selectedFilters.add(combinedLocation);
    }
    if (selectedAge.isNotEmpty) selectedFilters.add(selectedAge);
    if (roomGenderRatio != null) {
      switch (roomGenderRatio.name) {
        case "womanOnly":
          selectedFilters.add("여성 4");
        case "mixed":
          selectedFilters.add("여성 2, 남성 2");
        case "manOnly":
          selectedFilters.add("남성 4");
      }
    }
    if (selectedRules.containsValue(true)) {
      {
        selectedFilters.add(
            "세부 규칙 ${selectedRules.values.where((element) => element == true).length}");
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

    String genderRatio =
        convertGenderRatio(genderRatio: roomModel.room_gender_ratio);

    RoomModel decodedRoomModel = roomModel;
    decodedRoomModel.room_category = mainCategory;
    decodedRoomModel.room_category_detail = subCategory;
    decodedRoomModel.room_age = roomAges;
    decodedRoomModel.room_gender_ratio = genderRatio;

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

  // MARK: - 성비를 한글로 변환하는 함수
  String convertGenderRatio({required String genderRatio}) {
    switch (genderRatio) {
      case "womanOnly":
        return "여성 4명";
      case "mixed":
        return "남성 2명 + 여성 2명";
      case "manOnly":
        return "남성 4명";
      default:
        return "Error";
    }
  }

  // MARK: - 다른 사람들 방 불러오는 함수
  Stream<QuerySnapshot<Object?>> getOthersRoomModel({required String myUid}) {
    return _roomRepository.readRoomCollectionStream(myUid: myUid);
  }

  // MARK: - 다른 사람들 방 불러오는 함수 (필터 적용)
  Stream<QuerySnapshot<Object?>> getOthersRoomModelByFilter({
    required String myUid,
    required FilterInfo filterInfo,
    int? limit,
  }) {
    RoomRepository roomRepository = RoomRepository();
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
}
