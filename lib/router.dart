import 'package:go_router/go_router.dart';
import 'package:meet_up/view/login/login_main.dart';
import 'package:meet_up/view/login/login_phone_num.dart';
import 'package:meet_up/view/login/login_verification.dart';
import 'package:meet_up/view/sign_up/sign_up_detail.dart';
import 'package:meet_up/view/sign_up/sign_up_verification.dart';
import 'package:meet_up/view/sign_up/sign_up_phone_num.dart';
import 'package:meet_up/view_model/login/login_phone_num_view_model.dart';
import 'package:meet_up/view_model/login/login_verification_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_phone_num_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_verification_view_model.dart';
import 'package:provider/provider.dart';

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
    path: '/loginPhoneNum',
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (context) => LoginPhoneNumViewModel(),
        child: const LoginPhoneNum(),
      );
    },
  ),
  GoRoute(
    path: '/loginVerification',
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (context) => LoginVerificationViewModel(),
        child: const LoginVerification(),
      );
    },
  ),
  // SignUp
  GoRoute(
    path: '/signUpVerification',
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (context) => SignUpVerificationViewModel(),
        child: const SignUpVerification(),
      );
    },
  ),
  GoRoute(
    path: '/signUpPhoneNum',
    builder: (context, state) {
      return ChangeNotifierProvider(
        create: (context) => SignUpPhoneNumViewModel(),
        child: const SignUpPhoneNum(),
      );
    },
  ),
  GoRoute(
    path: '/signUpDetail',
    builder: (context, state) {
      return const SignUpDetail();
    },
  ),
]);
