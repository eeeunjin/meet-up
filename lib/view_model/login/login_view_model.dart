import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  bool _isTextFieldFocused = false;

  bool get isTextFieldFocused => _isTextFieldFocused;

  LoginViewModel() {
    controller.addListener(_handleTextChange);
  }

  void updateFocusState(bool isFocused) {
    _isTextFieldFocused = isFocused;
    notifyListeners();
  }

  void _handleTextChange() {
    notifyListeners();
  }

  bool get isPhoneNumberValid {
    String text = controller.text;
    // 번호가 '010'으로 시작하고 길이가 11자인지 확인합니다.
    return text.startsWith('010') && text.length == 11;
  }

  @override
  void dispose() {
    controller.removeListener(_handleTextChange);
    controller.dispose();
    super.dispose();
  }
}
