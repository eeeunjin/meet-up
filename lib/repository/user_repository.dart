import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

class UserRepository {
  final FirebaseCRUD _firebaseService = FirebaseCRUD();
  final FirebaseRefs _firebaseRefs = FirebaseRefs();
  final FirebaseAUTH _firebaseAUTH = FirebaseAUTH();

  // < ---------- CRUD 관련 함수 ---------- >

  /// 유저 콜렉션 안에 있는 docs 들의 모든 정보를 List<User> 형식으로 반환하는 함수
  Future<List<UserModel>> readUserCollection() async {
    return await _firebaseService.readCollection(
        colRef: _firebaseRefs.colRefUser);
  }

  /// 유저 콜렉션의 stream을 반환하는 함수
  Stream<QuerySnapshot<Object?>> readUserCollectionStream() {
    return _firebaseService.readCollectionStream(
        colRef: _firebaseRefs.colRefUser);
  }

  /// 유저 정보를 생성하는 함수
  Future<bool> createUserDocument({required UserModel data}) async {
    return await _firebaseService.createDocument(
      docRef: _firebaseRefs.colRefUser.doc(),
      data: data,
    );
  }

  /// 유저 정보를 읽어오는 함수
  Future<UserModel> readUserDocument({required String docID}) async {
    return await _firebaseService.readDocument<UserModel>(
        docRef: _firebaseRefs.colRefUser.doc(docID));
  }

  /// 유저 정보를 업데이트 하는 함수
  Future<bool> updateUserDocument({
    required String docID,
    required Map<String, dynamic> data,
  }) async {
    return await _firebaseService.updateDocument(
      docRef: _firebaseRefs.colRefUser.doc(docID),
      data: data,
    );
  }

  /// 유저 정보를 지우는 함수
  Future<bool> deleteUserData({required String docID}) async {
    return _firebaseService.deleteDocument(
        docRef: _firebaseRefs.colRefUser.doc(docID));
  }


  // < ---------- Auth 관련 함수 ---------- >

  /// 전화번호 인증을 위한 메서드
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await _firebaseAUTH.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  /// 해당 전화 번호와 smsCode를 확인하여 만들어진 credential을 전송하여 로그인 및 회원 가입하는 메서드
  Future<void> signInWithCredential(PhoneAuthCredential credential) async {
    await _firebaseAUTH.signInWithCredential(credential);
  }
}
