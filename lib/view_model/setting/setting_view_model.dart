import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier {
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 11) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7, 11)}';
    }
    return phoneNumber;
  }
}
