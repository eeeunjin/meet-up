import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

class ChatViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final RoomRepository _roomRepository = RoomRepository();

  // MARK: - 내가 만든 방 불러오는 함수
  Stream<QuerySnapshot<Object?>> getMyRoomModel({required String myUid}) {
    return _userRepository.readMyRoomCollectionStream(uid: myUid);
  }

  // MARK: - 불러온 RoomModel 정보 한글로 변환
  RoomModel decodingRoomModel({required RoomModel roomModel}) {
    // 카테고리
    String mainCategory = convertCategoryToKor(
      isMainCategory: true,
      category: roomModel.room_category,
    );
    String subCategory = convertCategoryToKor(
      isMainCategory: false,
      category: roomModel.room_category_detail,
    );

    // 나이
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

    FilterInfo filterInfo = FilterInfo(
      room_category: RoomCategory.hobby.name,
      room_category_detail: Hobby.photography.name,
      room_region_province: "서울",
      room_region_district: "종로구",
      room_age: RoomAge.thirties.name,
      room_gender_ratio: RoomGenderRatio.mixed.name,
      room_rules: [false, false, false, false, false],
    );

    Stream<QuerySnapshot<Object?>> roomCollectionStream;
    if (limit == null) {
      roomCollectionStream = roomRepository.readRoomCollectionStream(
        filterInfo: filterInfo,
        myUid: myUid,
      );
    } else {
      roomCollectionStream = roomRepository.readRoomCollectionStream(
          limit: limit, filterInfo: filterInfo, myUid: myUid);
    }
    return roomCollectionStream;
  }

  // MARK: - 상세정보 불러오면서 참여자 정보 가져오는 함수
  Future<List<UserModel>> getParticipantInfo(
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
    return userModels;
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
