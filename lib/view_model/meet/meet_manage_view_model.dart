import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/repository/user_repository.dart';

class MeetManageViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // MARK - 내가 만든 방 불러오는 함수
  Stream<QuerySnapshot<Object?>> getMyRoomModel({required String myUid}) {
    return _userRepository.readMyRoomCollectionStream(
      uid: myUid,
      findAll: false,
    );
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

    // 성비
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

  // MARK: - Rules
  List<String> get rulesDescriptions => [
        '만남 시 대화 녹음',
        '만남 후 앱을 통해 연락처 공유',
        '아는 지인과 동반 신청',
        '첫 만남에 2차 이동',
        '귀가 시 동성과 동행',
      ];
}
