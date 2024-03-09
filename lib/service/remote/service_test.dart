import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

// collection 정보 한 번 읽어오는 함수 테스트
Future<void> collectionReadTest() async {
  FirebaseRefs firebaseRefs = FirebaseRefs();
  FirebaseCRUD firebaseCRUD = FirebaseCRUD();

  // 유저들의 docRef 정보들을 List 형식으로 불러오도록 함
  List<User> users =
      await firebaseCRUD.readCollection(colRef: firebaseRefs.colRefUser);
  for (var user in users) {
    debugPrint(user.nickname);
  }
}

// collection 스트림 정보 읽어오는 함수 테스트
Future<void> collectionStreamReadTest() async {
  FirebaseRefs firebaseRefs = FirebaseRefs();
  FirebaseCRUD firebaseCRUD = FirebaseCRUD();

  final userCollectionStream =
      firebaseCRUD.readCollectionStream(colRef: firebaseRefs.colRefUser);

  // 스트림을 구독
  userCollectionStream.listen((QuerySnapshot<Object?> snapshot) {
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
  });
}

// document 정보 추가하는 함수 테스트
Future<void> documentCreateTest() async {
  FirebaseRefs firebaseRefs = FirebaseRefs();
  FirebaseCRUD firebaseCRUD = FirebaseCRUD();

  // 새로운 User 정보를 생성하여 새로운 docRef에 저장
  // 지역 정보
  Map<String, dynamic> region = {
    "siDo": "부산",
    "siGunGu": "서면",
  };
  // 새로운 유저 모델 정보
  User newUser = User(
      nickname: "minsu",
      profileIcon: 2,
      birthday: Timestamp.now(),
      gender: "male",
      region: region,
      job: "student",
      personalityRelationship: ["1", "2", "3"],
      personalitySelf: ["1", "2", "3"],
      interest: ["1", "2", "3"],
      purpose: ["1", "2", "3"],
      phoneNumber: "123123");

  // 새로운 유저 정보를 새로운 docRef 주소에 전달하여 생성
  await firebaseCRUD.createDocument<User>(
    docRef: firebaseRefs.colRefUser.doc(), // doc() 메서드를 통해 UID Auto Generate
    data: newUser,
  );
}

// document 정보 읽는 함수 테스트
Future<void> documentReadTest() async {
  FirebaseRefs firebaseRefs = FirebaseRefs();
  FirebaseCRUD firebaseCRUD = FirebaseCRUD();

  // 읽고 싶은 docRef의 주소를 전달하여 user 정보 불러오기
  User? user = await firebaseCRUD.readDocument<User>(
      docRef: firebaseRefs.colRefUser.doc("testUID"));
  print(user!.nickname);
}

// document 정보 업데이트 하는 함수 테스트
Future<void> documentUpdateTest() async {
  FirebaseRefs firebaseRefs = FirebaseRefs();
  FirebaseCRUD firebaseCRUD = FirebaseCRUD();

  // 원하는 변경 데이터 json 파일 형식으로 지정
  Map<String, dynamic> myMap = {
    'nickname': 'mingu',
    'job': 'student',
  };

  // 변경을 원하는 docRef 주소와 변경을 원하는 data를 전달
  await firebaseCRUD.updateDocument(
      docRef: firebaseRefs.colRefUser.doc("testUID"), data: myMap);
}

// document 정보 지우는 함수 테스트
Future<void> documentDeleteTest() async {
  FirebaseRefs firebaseRefs = FirebaseRefs();
  FirebaseCRUD firebaseCRUD = FirebaseCRUD();

  // 제거를 원하는 docRef의 주소를 전달
  await firebaseCRUD.deleteDocument(
      docRef: firebaseRefs.colRefUser.doc("NxUMhojToi89SvRFOzoB"));
}
