import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

class UserRepository {
  final FirebaseCRUD _firebaseService = FirebaseCRUD();
  final FirebaseRefs _firebaseRefs = FirebaseRefs();
  final FirebaseAUTH _firebaseAUTH = FirebaseAUTH();

  // MARK: - UserModel CRUD
  Future<bool> createUserDocument(
      {required UserModel data, required String uid}) async {
    return await _firebaseService.createDocument<UserModel>(
      docRef: _firebaseRefs.colRefUser.doc(uid),
      data: data,
    );
  }

  Future<List<UserModel>> readUserCollection() async {
    return await _firebaseService.readCollection<UserModel>(
        colRef: _firebaseRefs.colRefUser);
  }

  Stream<QuerySnapshot<Object?>> readUserCollectionStream() {
    return _firebaseService.readCollectionStream<UserModel>(
        colRef: _firebaseRefs.colRefUser);
  }

  Future<UserModel> readUserDocument({required String uid}) async {
    return await _firebaseService.readDocument<UserModel>(
        docRef: _firebaseRefs.colRefUser.doc(uid));
  }

  Future<UserModel> readUserDocumentByDocRef(
      {required DocumentReference docRef}) async {
    return await _firebaseService.readDocument<UserModel>(docRef: docRef);
  }

  Future<bool> updateUserDocument({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    return await _firebaseService.updateDocument(
      docRef: _firebaseRefs.colRefUser.doc(uid),
      data: data,
    );
  }

  Future<bool> deleteUserData({required String uid}) async {
    try {
      // 나의 방 정보 삭제
      await _firebaseService.deleteCollection(
          colRef: _firebaseRefs.colRefUser.doc(uid).collection("myRooms"));
      // 유저 정보 삭제
      await _firebaseService.deleteDocument(
          docRef: _firebaseRefs.colRefUser.doc(uid));
      return true;
    } catch (e) {
      logger.d("deleteUserData Error: $e");
      return false;
    }
  }

  // MARK:- MyRoomModel CRUD
  Future<bool> createMyRoomDocument({
    required MyRoomModel data,
    required String uid,
    required String roomId,
  }) async {
    DocumentReference myRoomDocumentReference =
        _firebaseRefs.colRefUser.doc(uid).collection("myRooms").doc(roomId);
    return await _firebaseService.createDocument<MyRoomModel>(
      docRef: myRoomDocumentReference,
      data: data,
    );
  }

  Future<List<MyRoomModel>> readMyRoomCollection({required String uid}) async {
    CollectionReference myRoomCollectionReference =
        _firebaseRefs.colRefUser.doc(uid).collection("myRooms");
    return await _firebaseService.readCollection<MyRoomModel>(
        colRef: myRoomCollectionReference);
  }

  Stream<QuerySnapshot<Object?>> readMyRoomCollectionStream({
    required String uid,
    required bool findAll,
  }) {
    return _firebaseService.readCollectionStreamByQuery<MyRoomModel>(
      uid: uid,
      findAll: findAll,
    );
  }

  Future<MyRoomModel> readMyRoomDocument({
    required String uid,
    required roomId,
  }) async {
    DocumentReference myRoomDocumentReference =
        _firebaseRefs.colRefUser.doc(uid).collection("myRooms").doc(roomId);
    return await _firebaseService.readDocument<MyRoomModel>(
        docRef: myRoomDocumentReference);
  }

  Future<bool> updateMyRoomDocument({
    required String uid,
    required Map<String, dynamic> data,
    required String roomId,
  }) async {
    DocumentReference myRoomDocumentReference =
        _firebaseRefs.colRefUser.doc(uid).collection("myRooms").doc(roomId);
    return await _firebaseService.updateDocument(
      docRef: myRoomDocumentReference,
      data: data,
    );
  }

  Future<bool> deleteMyRoomData({
    required String uid,
    required String roomId,
  }) async {
    DocumentReference myRoomDocumentReference =
        _firebaseRefs.colRefUser.doc(uid).collection("myRooms").doc(roomId);
    return _firebaseService.deleteDocument(docRef: myRoomDocumentReference);
  }

  // MARK: - MyTicketModel CRUD
  Future<DocumentReference> createMyTicketDocument({
    required MyTicketModel data,
    required String uid,
  }) async {
    DocumentReference myTicketDocumentReference =
        _firebaseRefs.colRefUser.doc(uid).collection("myTickets").doc();

    await _firebaseService.createDocument<MyTicketModel>(
      docRef: myTicketDocumentReference,
      data: data,
    );

    return myTicketDocumentReference;
  }

  // MARK: - MeetingReviewModel CRUD
  Future<bool> createMeetingReviewDocument({
    required MeetingReviewModel data,
    required String uid,
  }) async {
    return await _firebaseService.createDocument<MeetingReviewModel>(
      docRef:
          _firebaseRefs.colRefUser.doc(uid).collection("meetingReviews").doc(),
      data: data,
    );
  }

  Future<List<MeetingReviewModel>> readMeetingReviewCollection(
      {required String uid}) async {
    return await _firebaseService.readCollection<MeetingReviewModel>(
        colRef: _firebaseRefs.colRefUser.doc(uid).collection("meetingReviews"));
  }

  Stream<QuerySnapshot<Object?>> readMeetingReviewCollectionStream(
      {required String uid}) {
    return _firebaseService.readCollectionStream<MeetingReviewModel>(
        colRef: _firebaseRefs.colRefUser.doc(uid).collection("meetingReviews"));
  }

  Future<MeetingReviewModel> readMeetingReviewDocument({
    required String uid,
    required String meetingReviewId,
  }) async {
    return await _firebaseService.readDocument<MeetingReviewModel>(
        docRef: _firebaseRefs.colRefUser
            .doc(uid)
            .collection("meetingReviews")
            .doc(meetingReviewId));
  }

  // MARK: - MySchedule CRUD
  Future<bool> createMyScheduleDocument({
    required RoomModel data,
    required String uid,
  }) async {
    final title = data.room_schedule!["title"] as String;
    final date = data.room_schedule!["date"] as Timestamp;
    final docId = title + date.toDate().toString();

    return await _firebaseService.createDocument<RoomModel>(
      docRef:
          _firebaseRefs.colRefUser.doc(uid).collection("mySchedule").doc(docId),
      data: data,
    );
  }

  Stream<QuerySnapshot<Object?>> readMyScheduleCollectionStream(
      {required String uid}) {
    return _firebaseService.readCollectionStream<RoomModel>(
      colRef: _firebaseRefs.colRefUser.doc(uid).collection("mySchedule"),
    );
  }

  Future<bool> deleteMyScheduleData({
    required String uid,
    required String scheduleId,
  }) async {
    DocumentReference myScheduleDocumentReference = _firebaseRefs.colRefUser
        .doc(uid)
        .collection("mySchedule")
        .doc(scheduleId);
    return _firebaseService.deleteDocument(docRef: myScheduleDocumentReference);
  }

  // MARK: - Auth Functions
  /// 전화번호 인증을 위한 메서드
  Future<bool> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _firebaseAUTH.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      return true;
    } catch (e) {
      logger.e("verifyPhoneNumber Error: $e");
      return false;
    }
  }

  /// 해당 전화 번호와 smsCode를 확인하여 만들어진 credential을 전송하여 로그인 및 회원 가입하는 메서드
  Future<UserCredential> signInWithCredential(
      PhoneAuthCredential credential) async {
    return _firebaseAUTH.signInWithCredential(credential);
  }

  /// 탈퇴하는 메서드
  Future<bool> deleteUser({required String uid}) async {
    try {
      // FirebaseAuth 정보 삭제
      await _firebaseAUTH.deleteUser();
      // 유저 정보 삭제
      await deleteUserData(uid: uid);

      return true;
    } catch (e) {
      logger.d("deleteUser Error: $e");
      return false;
    }
  }
}
