import 'dart:async';
import 'package:flutter/material.dart';

class SignUpViewModel with ChangeNotifier {
  int _remainingTime = 180; // 3분
  bool _canResendCode = true; // 재전송 가능 여부
  late Timer _timer;
  String _verificationCode = ''; // 인증번호 변수

  SignUpViewModel() {
    startTimer();
  }

  int get remainingTime => _remainingTime;
  bool get canResendCode => _canResendCode;

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_remainingTime <= 0) {
        timer.cancel();
        _canResendCode = true; // 타이머가 종료되면 재전송 가능 상태로 변경
        notifyListeners(); // UI에 변경 사항 알림
        notifyListeners();
      } else {
        _remainingTime--;
        notifyListeners(); // UI에 변경 사항 알림
        notifyListeners();
      }
    });
  }

  void resetTimer() {
    _remainingTime = 180; // 타이머 초기화
    _canResendCode = true; // 재전송 가능 상태로 변경
    notifyListeners();
  }

  void resendCode() {
    if (_canResendCode) {
      // 재전송 가능한 상태일 때만 재전송을 수행
      _remainingTime = 180; // 타이머 초기화
      _canResendCode = false; // 재전송 중으로 상태 변경
      startTimer(); // 타이머 재시작
      notifyListeners(); // UI에 변경 사항 알림
      notifyListeners();
    }
  }

  String get formattedRemainingTime => formatTime(_remainingTime);

  String formatTime(int seconds) {
    String minutesStr = (seconds ~/ 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesStr : $secondsStr';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool _isPhoneNumberValid = false;

  bool get isPhoneNumberValid => _isPhoneNumberValid;

  void checkPhoneNumber(String value) {
    _isPhoneNumberValid = value.length == 11;
    notifyListeners();
  }

  // 인증번호를 설정하고 버튼 색상 변경
  void setCode(String code) {
    _verificationCode = code;
    notifyListeners();
  }

  // 6자리 이상의 인증번호인지 확인
  bool get isCodeValid => _verificationCode.length >= 6;

  // 인증번호를 가져옴
  String get verificationCode => _verificationCode;
}
