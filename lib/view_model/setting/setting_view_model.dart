import 'package:flutter/material.dart';

class SettingViewModel extends ChangeNotifier {
  // 전화번호 포멧
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 11) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7, 11)}';
    }
    return phoneNumber;
  }

  // MARK: - 푸쉬 알림 토글
  bool isNotificationEnabled = false;

  void toggleNotification(bool value) {
    isNotificationEnabled = value;
    notifyListeners();
  }
}
