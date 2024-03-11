import 'package:go_router/go_router.dart';
import 'package:meet_up/view/login/login_main.dart';
import 'package:meet_up/view/login/login_phone_num.dart';
import 'package:meet_up/view/login/login_verification.dart';
import 'package:meet_up/view/sign_up/sign_up_main.dart';
import 'package:meet_up/view/sign_up/sign_up_phone.dart';

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
  GoRoute(
    path: '/loginVerification',
    builder: (context, state) {
      return const LoginVerification();
    },
  ),
  // SignUp
  GoRoute(
    path: '/signUpVerification',
    builder: (context, state) {
      return const SignUpMain();
    },
  ),
  GoRoute(
    path: '/signUpPhone',
    builder: (context, state) {
      return const SignUpPhone();
    },
  ),
]);
