import 'dart:async';

import 'package:flutter/material.dart';

class SignUpVerificationViewModel with ChangeNotifier {
  //
  // MARK: - Properties
  //
  late Timer _timer; // 인증 타이머

  int _remainingTime = 180; // 남은 시간 3분
  int get remainingTime => _remainingTime; // 남은 시간
  String get formattedRemainingTime => formatTime(_remainingTime);

  bool _canResendCode = true; // 재전송 가능 여부
  bool get canResendCode => _canResendCode; // 재전송 가능 여부

  String _verificationCode = ''; // 인증번호 변수
  String get verificationCode => _verificationCode; // 인증번호

  bool _showErrorMessage = false;
  bool get showErrorMessage => _showErrorMessage;

  TextEditingController controller = TextEditingController();
  bool _isTextFieldFocused = false;
  bool get isTextFieldFocused => _isTextFieldFocused;

  //
  // MARK: - Constructor & Distructor
  //
  SignUpVerificationViewModel() {
    startTimer(); // 타이머 시작
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머 중지
    super.dispose();
  }

  //
  // MARK: - Methods
  //
  /// 타이머를 시작 설정 함수
  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSecond,
      (timer) {
        if (_remainingTime <= 0) {
          timer.cancel(); // 타이머 중지
          _canResendCode = true; // 타이머가 종료되면 재전송 가능 상태로 변경
          notifyListeners();
        } else {
          _remainingTime--; // 남은 시간 감소
          notifyListeners();
        }
      },
    );
  }

  /// 타이머를 초기화 하는 함수
  void resetTimer() {
    _remainingTime = 180; // 타이머 초기화
    _canResendCode = true; // 재전송 가능 상태로 변경
    notifyListeners();
  }

  /// 인증번호 재전송 함수
  void resendCode() {
    if (_canResendCode) {
      _remainingTime = 180; // 타이머 초기화
      _canResendCode = false; // 재전송 중으로 상태 변경
      startTimer(); // 타이머 재시작
      notifyListeners();
    }
  }

  /// '분:초' 형식으로 변환하는 함수
  String formatTime(int seconds) {
    String minutesStr = (seconds ~/ 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesStr : $secondsStr';
  }

  /// _verificationCode 확인 함수
  bool isVerificationCodeCorrect() {
    return _verificationCode == "123456";
  }

  /// _verficationCode set 함수
  void setVerificationCode() {
    _verificationCode = controller.text;
    notifyListeners();
  }

  /// _showErrorMessage set 함수
  void setShowErrorMessage(bool value) {
    _showErrorMessage = value;
    notifyListeners();
  }

  /// _isTextFieldFocused set 함수
  void setIsTextFieldFocusd({required bool isTextFieldFocused}) {
    _isTextFieldFocused = isTextFieldFocused;
    notifyListeners();
  }
}
