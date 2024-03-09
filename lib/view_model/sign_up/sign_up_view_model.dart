import 'dart:async';
import 'package:flutter/material.dart';

class VerificationCodeViewModel with ChangeNotifier {
  int _remainingTime = 180; // 3분
  bool _canResendCode = true; // 재전송 가능 여부
  late Timer _timer;

  VerificationCodeViewModel() {
    _startTimer();
  }

  int get remainingTime => _remainingTime;
  bool get canResendCode => _canResendCode;

  void _startTimer() {
    if (_timer.isActive) {
      _timer.cancel(); // 이전 타이머가 동작 중이면 취소
    }
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_remainingTime <= 0) {
        _timer.cancel();
        _canResendCode = true; // 타이머가 종료되면 재전송 가능 상태로 변경
        notifyListeners(); // UI에 변경 사항 알림
      } else {
        _remainingTime--;
        notifyListeners(); // UI에 변경 사항 알림
      }
    });
  }

  void resendCode() {
    if (_canResendCode) {
      // 재전송 가능한 상태일 때만 재전송을 수행
      _remainingTime = 180; // 타이머 초기화
      _canResendCode = false; // 재전송 중으로 상태 변경
      _startTimer(); // 타이머 재시작
      notifyListeners(); // UI에 변경 사항 알림
    }
  }

  String get formattedRemainingTime => _formatTime(_remainingTime);

  String _formatTime(int seconds) {
    String minutesStr = (seconds ~/ 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesStr : $secondsStr';
  }
}
