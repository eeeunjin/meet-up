import 'dart:async';

import 'package:flutter/material.dart';

class SignUpViewModel with ChangeNotifier {
  int _remainingTime = 180; // 3분
  bool _canResendCode = true; // 재전송 가능 여부
  late Timer _timer;

  SignUpViewModel() {
    _startTimer();
  }

  int get remainingTime => _remainingTime;
  bool get canResendCode => _canResendCode;

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_remainingTime <= 0) {
        _timer.cancel();
        _canResendCode = true; // 타이머가 종료되면 재전송 가능 상태로 변경
      } else {
        _remainingTime--;
      }
      notifyListeners();
    });
  }

  void resendCode() {
    if (_canResendCode) {
      // 재전송 가능한 상태일 때만 재전송을 수행
      _remainingTime = 180; // 타이머 초기화
      _canResendCode = false; // 재전송 중으로 상태 변경
      _startTimer(); // 타이머 재시작
    }
  }

  String _formatTime(int seconds) {
    String minutesStr = (seconds ~/ 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesStr : $secondsStr';
  }
}
