import 'package:go_router/go_router.dart';
import 'package:meet_up/view/login/login_main.dart';
import 'package:meet_up/view/login/login_phone_num.dart';

final router = GoRouter(routes: [
  // 초기 화면
  GoRoute(
    path: '/',
    builder: (context, state) {
      return const LoginMain();
    },
  ),
  // Login
  GoRoute(
    path: '/phoneNum',
    builder: (context, state) {
      return const LoginPhoneNum();
    },
  ),
]);
