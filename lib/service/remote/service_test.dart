import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

// collection 정보 한 번 읽어오는 함수 테스트
Future<void> collectionReadTest() async {
  UserRepository userRepository = UserRepository();
  List<UserModel> users = await userRepository.readUserCollection();
  for (var user in users) {
    debugPrint(user.nickname);
  }
}

// collection 스트림 정보 읽어오는 함수 테스트
Future<void> collectionStreamReadTest() async {
  UserRepository userRepository = UserRepository();

  final userCollectionStream = userRepository.readUserCollectionStream();

  // 스트림을 구독
  userCollectionStream.listen(
    (QuerySnapshot<Object?> snapshot) {
      // 스트림에서 받은 데이터 처리
      for (DocumentChange<Object?> change in snapshot.docChanges) {
        // 변경 유형에 따라 데이터 처리
        if (change.type == DocumentChangeType.added) {
          // 문서 추가
          debugPrint('Added document: ${change.doc.data()}');
        } else if (change.type == DocumentChangeType.modified) {
          // 문서 수정
          debugPrint('Modified document: ${change.doc.data()}');
        } else if (change.type == DocumentChangeType.removed) {
          // 문서 삭제
          debugPrint('Removed document: ${change.doc.data()}');
        }
      }
    },
  );
}

// document 정보 추가하는 함수 테스트
Future<void> documentCreateTest() async {
  UserRepository userRepository = UserRepository();

  // 새로운 User 정보를 생성하여 새로운 docRef에 저장
  // 지역 정보
  Map<String, dynamic> region = {
    "province": "부산",
    "district": "서면",
  };

  // 새로운 유저 모델 정보
  UserModel newUser = UserModel(
    nickname: "minsu",
    profile_icon: '',
    birthday: DateTime.now(),
    gender: "man",
    region: region,
    job: "student",
    personality_relationship: ["사교적인", "친절한", "자신감있는"],
    personality_self: ["계획적인", "안정적인", "열정적인"],
    interest: ["운동", "음악", "독서"],
    purpose: ["친목", "자기성찰", "기록"],
    phone_number: "01012341234",
    accepted_policies: [false, false],
    coin: 0,
    ticket: 0,
    isFixedTicket: false,
    fixed_ticket_end_date: Timestamp.now(),
  );

  // 새로운 유저 정보를 새로운 docRef 주소에 전달하여 생성
  await userRepository.createUserDocument(data: newUser, uid: "TestUID");
}

// document 정보 읽는 함수 테스트
Future<void> documentReadTest() async {
  UserRepository userRepository = UserRepository();

  // 읽고 싶은 docRef의 주소를 전달하여 user 정보 불러오기
  UserModel? user = await userRepository.readUserDocument(uid: "testUID");
  debugPrint(user.nickname);
}

// document 정보 업데이트 하는 함수 테스트
Future<void> documentUpdateTest() async {
  UserRepository userRepository = UserRepository();

  // 원하는 변경 데이터 json 파일 형식으로 지정
  Map<String, dynamic> myMap = {
    'nickname': 'imnotamingu',
  };

  // 변경을 원하는 docRef 주소와 변경을 원하는 data를 전달
  await userRepository.updateUserDocument(
    uid: "testUID",
    data: myMap,
  );
}

// document 정보 지우는 함수 테스트
Future<void> documentDeleteTest() async {
  UserRepository userRepository = UserRepository();

  // 제거를 원하는 docRef의 주소를 전달
  await userRepository.deleteUserData(uid: "kMCp0M25JblNhWGsYGg8");
}

// Room 정보 만드는 함수 테스트
Future<void> roomDocumentCreationTest() async {
  UserRepository userRepository = UserRepository();
  RoomRepository roomRepository = RoomRepository();
  FirebaseRefs firebaseRefs = FirebaseRefs();

  // rooms collection에 데이터 추가
  // RoomModel roomModel = RoomModel(
  //   room_name: "같이 여행 갈 사람 ~",
  //   room_category: RoomCategory.hobby.name,
  //   room_category_detail: Hobby.travel.name,
  //   room_region_province: "서울",
  //   room_region_district: "양천구",
  //   room_keyword: ["서울 여행", "같이 갈 사람"],
  //   room_description: "같이 여행에 대해 이야기 나눠보고 맘에 드는 사람이 있다면 같이 여행 가봐요 :)",
  //   room_age: [RoomAge.thirties.name, RoomAge.fifties.name],
  //   room_gender_ratio: RoomGenderRatio.manOnly.name,
  //   room_rules: [true, false, true, true, true],
  //   room_creation_date: Timestamp.now(),
  //   room_owner_reference:
  //       firebaseRefs.colRefUser.doc("j9YUl33nHTdtVLZMSuKXYaUQL7d2"),
  //   room_participant_reference: [],
  // );

  // RoomModel roomModel = RoomModel(
  //   room_name: "운동 할 사람",
  //   room_category: RoomCategory.exercise.name,
  //   room_category_detail: Exercise.soccer.name,
  //   room_region_province: "인천",
  //   room_region_district: "사하구",
  //   room_keyword: ["축구", "풋살", "축구동호회"],
  //   room_description: "축구 좋아하는 사람들의 모임입니다.",
  //   room_age: [RoomAge.twenties.name, RoomAge.thirties.name],
  //   room_gender_ratio: RoomGenderRatio.mixed.name,
  //   room_rules: [true, false, true, true, true],
  //   room_creation_date: Timestamp.now(),
  //   room_owner_reference:
  //       firebaseRefs.colRefUser.doc("j9YUl33nHTdtVLZMSuKXYaUQL7d2"),
  //   room_participant_reference: [],
  // );

  RoomModel roomModel = RoomModel(
    room_name: "조기 축구 (토요일)",
    room_category: RoomCategory.exercise.name,
    room_category_detail: Exercise.soccer.name,
    room_region_province: "부산",
    room_region_district: "사하구",
    room_keyword: ["조축", "축구", "풋살"],
    room_description: "매주 토요일 아침 간단하게 축구 하실 분 구해요 ~",
    room_age: [RoomAge.twenties.name],
    room_gender_ratio: RoomGenderRatio.manOnly.name,
    room_rules: [true, true, true, true, true],
    room_creation_date: Timestamp.now(),
    room_owner_reference:
        firebaseRefs.colRefUser.doc("7qYDqcx4YqbgGxikqdRHJldbR3w1"),
    room_participant_reference: [],
  );

  // 해당 유저의 rooms collection에 데이터 추가
  final docRef = await roomRepository.createRoomDocument(data: roomModel);

  final myRoomModel = MyRoomModel(
    isMyRoom: true,
    room_reference: docRef,
  );

  userRepository.createMyRoomDocument(
    data: myRoomModel,
    uid: "7qYDqcx4YqbgGxikqdRHJldbR3w1",
    roomId: docRef.path.split('/').last,
  );
}

// Room 정보 읽어오는 함수 테스트
Future<void> roomCollectionReadTest({
  int? limit,
  FilterInfo? filterInfo,
}) async {
  RoomRepository roomRepository = RoomRepository();

  List<RoomModel> roomModelList;

  if (limit == null) {
    if (filterInfo == null) {
      roomModelList = await roomRepository.readRoomCollection();
    } else {
      roomModelList =
          await roomRepository.readRoomCollection(filterInfo: filterInfo);
    }
  } else {
    if (filterInfo == null) {
      roomModelList = await roomRepository.readRoomCollection(limit: limit);
    } else {
      roomModelList = await roomRepository.readRoomCollection(
        limit: limit,
        filterInfo: filterInfo,
      );
    }
  }

  for (RoomModel roomModel in roomModelList) {
    if (kDebugMode) {
      print(roomModel.room_category);
      print(roomModel.room_category_detail);
      print(roomModel.room_description);
      print(roomModel.room_gender_ratio);
      print(roomModel.room_name);
      print(roomModel.room_region_district);
      print(roomModel.room_region_province);
      print(roomModel.room_age);
      print(roomModel.room_creation_date);
      print(roomModel.room_owner_reference);
      print(roomModel.room_participant_reference);
      print(roomModel.room_rules);
      print(roomModel.room_keyword);
      print("--------------------------------------------------");
    }
  }
}

// collection 스트림 정보 읽어오는 함수 테스트
Future<void> roomCollectionStreamReadTest({
  int? limit,
  FilterInfo? filterInfo,
}) async {
  RoomRepository roomRepository = RoomRepository();

  Stream<QuerySnapshot<Object?>> roomCollectionStream;
  if (limit == null) {
    if (filterInfo == null) {
      roomCollectionStream = roomRepository.readRoomCollectionStream();
    } else {
      roomCollectionStream =
          roomRepository.readRoomCollectionStream(filterInfo: filterInfo);
    }
  } else {
    if (filterInfo == null) {
      roomCollectionStream =
          roomRepository.readRoomCollectionStream(limit: limit);
    } else {
      roomCollectionStream = roomRepository.readRoomCollectionStream(
        limit: limit,
        filterInfo: filterInfo,
      );
    }
  }

  // 스트림을 구독
  roomCollectionStream.listen(
    (QuerySnapshot<Object?> snapshot) {
      // 스트림에서 받은 데이터 처리
      for (DocumentChange<Object?> change in snapshot.docChanges) {
        // 변경 유형에 따라 데이터 처리
        if (change.type == DocumentChangeType.added) {
          // 문서 추가
          RoomModel roomModel =
              RoomModel.fromJson(change.doc.data() as Map<String, dynamic>);
          if (kDebugMode) {
            print(roomModel.room_category);
            print(roomModel.room_category_detail);
            print(roomModel.room_description);
            print(roomModel.room_gender_ratio);
            print(roomModel.room_name);
            print(roomModel.room_region_district);
            print(roomModel.room_region_province);
            print(roomModel.room_age);
            print(roomModel.room_creation_date);
            print(roomModel.room_owner_reference);
            print(roomModel.room_participant_reference);
            print(roomModel.room_rules);
            print(roomModel.room_keyword);
            print("------------------------- 추가 -----------------------");
          }
        } else if (change.type == DocumentChangeType.modified) {
          // 문서 수정
          RoomModel roomModel =
              RoomModel.fromJson(change.doc.data() as Map<String, dynamic>);
          if (kDebugMode) {
            print(roomModel.room_category);
            print(roomModel.room_category_detail);
            print(roomModel.room_description);
            print(roomModel.room_gender_ratio);
            print(roomModel.room_name);
            print(roomModel.room_region_district);
            print(roomModel.room_region_province);
            print(roomModel.room_age);
            print(roomModel.room_creation_date);
            print(roomModel.room_owner_reference);
            print(roomModel.room_participant_reference);
            print(roomModel.room_rules);
            print(roomModel.room_keyword);
            print("------------------------- 수정 -----------------------");
          }
        } else if (change.type == DocumentChangeType.removed) {
          // 문서 삭제
          RoomModel roomModel =
              RoomModel.fromJson(change.doc.data() as Map<String, dynamic>);
          if (kDebugMode) {
            print(roomModel.room_category);
            print(roomModel.room_category_detail);
            print(roomModel.room_description);
            print(roomModel.room_gender_ratio);
            print(roomModel.room_name);
            print(roomModel.room_region_district);
            print(roomModel.room_region_province);
            print(roomModel.room_age);
            print(roomModel.room_creation_date);
            print(roomModel.room_owner_reference);
            print(roomModel.room_participant_reference);
            print(roomModel.room_rules);
            print(roomModel.room_keyword);
            print("------------------------- 삭제 -----------------------");
          }
        }
      }
    },
  );
}
