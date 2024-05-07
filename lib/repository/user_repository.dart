import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

class UserRepository {
  final FirebaseCRUD _firebaseService = FirebaseCRUD();
  final FirebaseRefs _firebaseRefs = FirebaseRefs();
  final FirebaseAUTH _firebaseAUTH = FirebaseAUTH();

  // < ---------- UserModel CRUD ---------- >

  Future<List<UserModel>> readUserCollection() async {
    return await _firebaseService.readCollection<UserModel>(
        colRef: _firebaseRefs.colRefUser);
  }

  Stream<QuerySnapshot<Object?>> readUserCollectionStream() {
    return _firebaseService.readCollectionStream<UserModel>(
        colRef: _firebaseRefs.colRefUser);
  }

  Future<bool> createUserDocument(
      {required UserModel data, required String uid}) async {
    return await _firebaseService.createDocument<UserModel>(
      docRef: _firebaseRefs.colRefUser.doc(uid),
      data: data,
    );
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
    return _firebaseService.deleteDocument(
        docRef: _firebaseRefs.colRefUser.doc(uid));
  }

  // < ---------- MyRoomModel CRUD ---------- >

  Future<List<MyRoomModel>> readMyRoomCollection({required String uid}) async {
    CollectionReference myRoomCollectionReference =
        _firebaseRefs.colRefUser.doc(uid).collection("myRooms");
    return await _firebaseService.readCollection<MyRoomModel>(
        colRef: myRoomCollectionReference);
  }

  Stream<QuerySnapshot<Object?>> readMyRoomCollectionStream(
      {required String uid}) {
    return _firebaseService.readCollectionStreamByQuery<MyRoomModel>(uid: uid);
  }

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

  // < ---------- MyEnterRequestModel CRUD ---------- >

  Future<List<MyEnterRequestModel>> readMyEnterRequestCollection(
      {required String uid}) async {
    CollectionReference myEnterRequestCollectionReference =
        _firebaseRefs.colRefUser.doc(uid).collection("myEnterRequests");
    return await _firebaseService.readCollection<MyEnterRequestModel>(
        colRef: myEnterRequestCollectionReference);
  }

  Stream<QuerySnapshot<Object?>> readMyEnterRequestCollectionStream(
      {required String uid}) {
    CollectionReference myEnterRequestCollectionReference =
        _firebaseRefs.colRefUser.doc(uid).collection("myEnterRequests");
    return _firebaseService.readCollectionStream<MyEnterRequestModel>(
        colRef: myEnterRequestCollectionReference);
  }

  Future<bool> createMyEnterRequestDocument({
    required MyEnterRequestModel data,
    required String uid,
    required String myEnterRequestId,
  }) async {
    DocumentReference myEnterRequestDocumentReference = _firebaseRefs.colRefUser
        .doc(uid)
        .collection("myEnterRequests")
        .doc(myEnterRequestId);
    return await _firebaseService.createDocument<MyEnterRequestModel>(
      docRef: myEnterRequestDocumentReference,
      data: data,
    );
  }

  Future<MyEnterRequestModel> readMyEnterRequestDocument({
    required String uid,
    required myEnterRequestId,
  }) async {
    DocumentReference myRoomDocumentReference = _firebaseRefs.colRefUser
        .doc(uid)
        .collection("myEnterRequests")
        .doc(myEnterRequestId);
    return await _firebaseService.readDocument<MyEnterRequestModel>(
        docRef: myRoomDocumentReference);
  }

  Future<bool> updateMyEnterRequestDocument({
    required String uid,
    required Map<String, dynamic> data,
    required String myEnterRequestId,
  }) async {
    DocumentReference myRoomDocumentReference = _firebaseRefs.colRefUser
        .doc(uid)
        .collection("myEnterRequests")
        .doc(myEnterRequestId);
    return await _firebaseService.updateDocument(
      docRef: myRoomDocumentReference,
      data: data,
    );
  }

  Future<bool> deleteMyEnterRequestData({
    required String uid,
    required String myEnterRequestId,
  }) async {
    DocumentReference myRoomDocumentReference = _firebaseRefs.colRefUser
        .doc(uid)
        .collection("myEnterRequests")
        .doc(myEnterRequestId);
    return _firebaseService.deleteDocument(docRef: myRoomDocumentReference);
  }

  // < ---------- Auth ---------- >

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
      return false;
    }
  }

  /// 해당 전화 번호와 smsCode를 확인하여 만들어진 credential을 전송하여 로그인 및 회원 가입하는 메서드
  Future<UserCredential> signInWithCredential(
      PhoneAuthCredential credential) async {
    return _firebaseAUTH.signInWithCredential(credential);
  }
}
