import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  final TextEditingController controller = TextEditingController();

  LoginViewModel() {
    controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    String text = controller.text;
    bool isValid = text.startsWith('010') && text.length == 11;
    if (isValid != _isPhoneNumberValid) {
      _isPhoneNumberValid = isValid;
      notifyListeners();
    }
  }

  bool get isPhoneNumberValid => _isPhoneNumberValid;
  bool _isPhoneNumberValid = false;

  @override
  void dispose() {
    controller.removeListener(_handleTextChange);
    controller.dispose();
    super.dispose();
  }
}
