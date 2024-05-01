import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginFunc {
  // Secure storage 접근 지정자
  static const storage = FlutterSecureStorage();

  // 이전에 로그인 되어있는지 확인하는 대한 전역 변수
  static bool isLogined = false;

  static String? uid;

  static Future<void> autoLogin() async {
    // firebase secure storage 에서 key 값을 불러옴
    uid = await LoginFunc.storage.read(key: 'uid');

    if (uid != null) {
      LoginFunc.isLogined = true;
    } else {
      LoginFunc.isLogined = false;
    }
  }
}
