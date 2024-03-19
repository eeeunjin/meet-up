import 'package:flutter/material.dart';

class SignUpPhoneNumViewModel with ChangeNotifier {
  //
  // MARK: - Properties
  //
  TextEditingController controller = TextEditingController();
  bool _isTextFieldFocused = false;
  bool get isTextFieldFocused => _isTextFieldFocused;

  bool _isPhoneNumberValid = false; // 핸드폰 번호 유효성 검사 여부
  bool get isPhoneNumberValid => _isPhoneNumberValid; // 핸드폰 번호 유효성 검사

  //
  // MARK: - Methods
  //
  // _isPhoneNumberValid set 함수
  void setIsPhoneNumberValid(String value) {
    _isPhoneNumberValid = value.startsWith('010') && value.length == 11;
    notifyListeners();
  }

  // _isTextFieldFocused set 함수
  void setIsTextFieldFocusd({required bool isTextFieldFocused}) {
    _isTextFieldFocused = isTextFieldFocused;
    notifyListeners();
  }
}
