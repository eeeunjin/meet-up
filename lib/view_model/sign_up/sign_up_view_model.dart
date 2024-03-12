import 'dart:async';
import 'package:flutter/material.dart';

class SignUpViewModel with ChangeNotifier {
  int _remainingTime = 180; // 남은 시간 3분
  bool _canResendCode = true; // 재전송 가능 여부
  late Timer _timer;
  String _verificationCode = ''; // 인증번호 변수

  SignUpViewModel() {
    startTimer(); // 타이머 시작
  }

  // 남은 시간
  int get remainingTime => _remainingTime;

  // 재전송 가능 여부
  bool get canResendCode => _canResendCode;

  TextEditingController controller = TextEditingController();

  // 타이머 초기화
  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_remainingTime <= 0) {
        timer.cancel(); // 타이머 중지
        _canResendCode = true; // 타이머가 종료되면 재전송 가능 상태로 변경
        notifyListeners();
      } else {
        _remainingTime--; // 남은 시간 감소
        notifyListeners();
      }
    });
  }

  // 타이머 재설정
  void resetTimer() {
    _remainingTime = 180; // 타이머 초기화
    _canResendCode = true; // 재전송 가능 상태로 변경
    notifyListeners();
  }

  // 인증번호 재전송
  void resendCode() {
    if (_canResendCode) {
      // 재전송 가능한 상태일 때만 재전송
      _remainingTime = 180; // 타이머 초기화
      _canResendCode = false; // 재전송 중으로 상태 변경
      startTimer(); // 타이머 재시작
      notifyListeners();
    }
  }

  // '분:초' 형식으로 변환
  String get formattedRemainingTime => formatTime(_remainingTime);

  String formatTime(int seconds) {
    String minutesStr = (seconds ~/ 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesStr : $secondsStr';
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머 중지
    super.dispose();
  }

  // 핸드폰 번호 유효성 검사 여부
  bool _isPhoneNumberValid = false;

  // 핸드폰 번호 유효성 검사
  bool get isPhoneNumberValid => _isPhoneNumberValid;

  // 핸드폰 번호 유효성 검사
  void checkPhoneNumber(String value) {
    _isPhoneNumberValid = value.startsWith('010') && value.length == 11;
    notifyListeners();
  }

  // 인증번호를 설정, 버튼 색상 변경
  void setCode(String code) {
    _verificationCode = code;
    notifyListeners();
  }

  // 6자리 이상의 인증번호인지 확인
  bool get isCodeValid => _verificationCode.length >= 6;

  // 인증번호를 가져옴
  String get verificationCode => _verificationCode;
}
