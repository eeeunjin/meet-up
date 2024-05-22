import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/user_repository.dart';

class SignUpPhoneNumViewModel with ChangeNotifier {
  //
  // MARK: - Properties
  //
  final UserRepository _userRepository = UserRepository();

  TextEditingController controller = TextEditingController();
  bool _isTextFieldFocused = false;
  bool get isTextFieldFocused => _isTextFieldFocused;

  // 핸드폰 번호 유효성
  bool _isPhoneNumberValid = false;
  bool get isPhoneNumberValid => _isPhoneNumberValid;

  // 문자가 전송됬는지 확인
  bool _codeSent = false;
  bool get codeSent => _codeSent;

  // credential = smsCode + verificationID
  String _verificationId = '';
  String get verificationId => _verificationId;

  // 가입한 유저의 uid string
  String _uid = '';
  String get uid => _uid;

  // 기존 유저의 userInfo
  UserModel? _userInfo;
  UserModel get userInfo => _userInfo!;

  //
  // MARK: - Methods
  //
  /// _isPhoneNumberValid set 함수
  void setIsPhoneNumberValid(String value) {
    _isPhoneNumberValid = value.startsWith('010') && value.length == 11;
    notifyListeners();
  }

  /// _isTextFieldFocused set 함수
  void setIsTextFieldFocusd({required bool isTextFieldFocused}) {
    _isTextFieldFocused = isTextFieldFocused;
    notifyListeners();
  }

  /// _codeSent set 함수
  set codeSent(bool value) {
    _codeSent = value;
    notifyListeners();
  }

  /// _userInfo set 함수
  set userInfo(UserModel value) {
    _userInfo = value;
    notifyListeners();
  }

  // 코드 재전송 함수
  void resendCode(BuildContext context) {
    signInWithPhoneNumber(context);
  }

  /// _verificationID set 함수
  set verificationId(String value) {
    _verificationId = value;
    notifyListeners();
  }

  /// 핸드폰 번호로 sign 하는 함수
  Future<bool> signInWithPhoneNumber(BuildContext context) async {
    try {
      // 전화 번호 인증 관련 메소드 호출
      return _userRepository.verifyPhoneNumber(
        // 전화 번호 전달
        phoneNumber: "+82 ${controller.text}",
        // 사용자가 이미 이전에 인증을 완료한 적이 있는 경우 실행
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _userRepository.signInWithCredential(credential);
        },
        // 인증 문자 전송 실패
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            debugPrint("The provided phone number is not valid.");
          }
        },
        // 코드 인증 시, verificationID를 저장하여 넘겨주는 역할을 함
        codeSent: (String verificationId, int? forceResendingToken) {
          _verificationId = verificationId;
          _codeSent = true;
          context.goNamed('signUpVerification');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint("handling code auto retrieval timeout");
        },
      );
    } catch (e) {
      return false;
    }
  }

  /// 전송된 문자의 smsCode를 입력하여 sign 하는 함수
  Future<UserCredential> signInWithSmsCode(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );
    return await _userRepository.signInWithCredential(credential);
  }

  // 로그인 또는 회원가입 시, uid를 저장하는 함수
  void getUID(String uid) {
    this.uid = uid;
  }

  // _uid set 함수
  set uid(String value) {
    _uid = value;
  }

  /// Firebase cloudStore에 유저 정보 저장하는 함수 (UID + 휴대전화 번호)
  Future<bool> createUserDocument({required String uid}) async {
    // 유저의 uid 정보 저장
    _uid = uid;

    // 새로운 유저 모델
    UserModel newUser = UserModel(
      nickname: "",
      profile_icon: "",
      birthday: DateTime.now(),
      gender: "",
      region: {"-1": "-1"},
      job: "",
      personality_relationship: [],
      personality_self: [],
      interest: [],
      purpose: [],
      phone_number: controller.text,
      accepted_policies: [false, false],
      coin: 0,
      ticket: 0,
      isFixedTicket: false,
      fixed_ticket_end_date: Timestamp.now(),
      rank: 'Novice',
    );

    // Cloud Firestore에 유저 정보 저장
    return await _userRepository.createUserDocument(
      data: newUser,
      uid: uid,
    );
  }

  /// Firebase cloudStore에 유저 정보 읽어오는 함수
  Future<void> readUserDocument({required String uid}) async {
    // 유저 정보 전달
    userInfo = await _userRepository.readUserDocument(uid: uid);
  }

  void resetState() {
    _isTextFieldFocused = false;
    _isPhoneNumberValid = false;
    _codeSent = false;
  }
}
