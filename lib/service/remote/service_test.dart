import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/user_repository.dart';

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
    "siDo": "부산",
    "siGunGu": "서면",
  };
  // 새로운 유저 모델 정보
  UserModel newUser = UserModel(
      nickname: "minsu",
      profileIcon: 2,
      birthday: Timestamp.now(),
      gender: "man",
      region: region,
      job: "student",
      personalityRelationship: ["사교적인", "친절한", "자신감있는"],
      personalitySelf: ["계획적인", "안정적인", "열정적인"],
      interest: ["운동", "음악", "독서"],
      purpose: ["친목", "자기성찰", "기록"],
      phoneNumber: "01012341234");

  // 새로운 유저 정보를 새로운 docRef 주소에 전달하여 생성
  await userRepository.createUserDocument(data: newUser);
}

// document 정보 읽는 함수 테스트
Future<void> documentReadTest() async {
  UserRepository userRepository = UserRepository();

  // 읽고 싶은 docRef의 주소를 전달하여 user 정보 불러오기
  UserModel? user = await userRepository.readUserDocument(docID: "testUID");
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
    docID: "testUID",
    data: myMap,
  );
}

// document 정보 지우는 함수 테스트
Future<void> documentDeleteTest() async {
  UserRepository userRepository = UserRepository();

  // 제거를 원하는 docRef의 주소를 전달
  await userRepository.deleteUserData(docID: "kMCp0M25JblNhWGsYGg8");
}
