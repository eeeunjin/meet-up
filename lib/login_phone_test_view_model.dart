import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_up/repository/user_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // 문자가 전송됬는지 확인하는 코드
  bool _codeSent = false;
  // Credential을 만들기 위한 verificationID
  // -> "Credential = smsCode + verificationID"
  // -> codeSent가 반환될 때, 같이 받아올 수 있음
  String _verificationId = '';

  bool get codeSent => _codeSent;

  // Code가 전송되고 난 이후에 listen view에 notify 전달
  set codeSent(bool value) {
    _codeSent = value;
    notifyListeners();
  }

  String get verificationId => _verificationId;

  set verificationId(String value) {
    _verificationId = value;
    notifyListeners();
  }

  /// 핸드폰 번호로 Sign 하는 메서드
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    // 전화 번호 인증 관련 메소드 호출
    await _userRepository.verifyPhoneNumber(
      // 전화 번호 전달
      phoneNumber: phoneNumber,
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
        codeSent = true;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint("handling code auto retrieval timeout");
      },
    );
  }

  /// 전송된 문자의 smsCode를 입력하여 sign-in 하는 메서드
  Future<void> signInWithSmsCode(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );
    await _userRepository.signInWithCredential(credential);
  }
}
