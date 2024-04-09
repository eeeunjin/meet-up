import 'package:go_router/go_router.dart';
import 'package:meet_up/view/login/login_main.dart';
import 'package:meet_up/view/login/login_phone_num.dart';
import 'package:meet_up/view/login/login_verification.dart';
import 'package:meet_up/view/meet/meet__manage_main.dart';
import 'package:meet_up/view/meet/meet_browse_main.dart';
import 'package:meet_up/view/meet/meet_category.dart';
import 'package:meet_up/view/meet/meet_create.dart';
import 'package:meet_up/view/meet/meet_filter.dart';
import 'package:meet_up/view/meet/meet_filter_area.dart';
import 'package:meet_up/view/meet/meet_keyword.dart';
import 'package:meet_up/view/meet/meet_main.dart';
import 'package:meet_up/view/meet/meet_search_main.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_one.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_five.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_four.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_three.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_two.dart';
import 'package:meet_up/view/sign_up/sign_up_verification.dart';
import 'package:meet_up/view/sign_up/sign_up_phone_num.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    // 초기 화면
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const LoginMain();
      },
      routes: [
        // Login
        GoRoute(
          path: 'loginPhoneNum',
          name: 'loginPhoneNum',
          builder: (context, state) {
            return const LoginPhoneNum();
          },
          routes: [
            GoRoute(
              path: 'loginVerification',
              name: 'loginVerification',
              builder: (context, state) {
                return const LoginVerification();
              },
            ),
          ],
        ),

        // SignUp
        GoRoute(
          path: 'signUpPhoneNum',
          name: 'signUpPhoneNum',
          builder: (context, state) {
            return const SignUpPhoneNum();
          },
          routes: [
            GoRoute(
              path: 'signUpVerification',
              name: 'signUpVerification',
              builder: (context, state) {
                return const SignUpVerification();
              },
              routes: [
                GoRoute(
                  path: 'signUpDetailOne',
                  name: 'signUpDetailOne',
                  builder: (context, state) {
                    return const SignUpDetailOne();
                  },
                  routes: [
                    GoRoute(
                      path: 'signUpDetailTwo',
                      name: 'signUpDetailTwo',
                      builder: (context, state) {
                        return const SignUpDetailTwo();
                      },
                      routes: [
                        GoRoute(
                          path: 'signUpDetailThree',
                          name: 'signUpDetailThree',
                          builder: (context, state) {
                            return const SignUpDetailThree();
                          },
                          routes: [
                            GoRoute(
                              path: 'signUpDetailFour',
                              name: 'signUpDetailFour',
                              builder: (context, state) {
                                return const SignUpDetailFour();
                              },
                              routes: [
                                GoRoute(
                                  path: 'signUpDetailFive',
                                  name: 'signUpDetailFive',
                                  builder: (context, state) {
                                    return const SignUpDetailFive();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // Meet
        GoRoute(
          path: 'meetMain',
          name: 'meetMain',
          builder: (context, state) {
            return const MeetMain();
          },
          routes: [
            GoRoute(
              path: 'meetManageMain',
              name: 'meetManageMain',
              builder: (context, state) {
                return const MeetManageMain();
              },
            ),
            GoRoute(
              path: 'meetSearchMain',
              name: 'meetSearchMain',
              builder: (context, state) {
                return const MeetSearchMain();
              },
            ),
            GoRoute(
              path: 'meetBrowseMain',
              name: 'meetBrowseMain',
              builder: (context, state) {
                return const MeetBrowseMain();
              },
            ),
            GoRoute(
              path: 'meetFilterMain',
              name: 'meetFilterMain',
              builder: (context, state) {
                return const MeetFilterMain();
              },
            ),
            GoRoute(
              path: 'meetFilterArea',
              name: 'meetFilterArea',
              builder: (context, state) {
                return const MeetFilterArea();
              },
            ),
            GoRoute(
              path: 'meetCreate',
              name: 'meetCreate',
              builder: (context, state) {
                return const MeetCreate();
              },
              routes: [
                GoRoute(
                  path: 'meetKeyWord',
                  name: 'meetKeyWord',
                  builder: (context, state) {
                    return const MeetKeyWord();
                  },
                ),
                GoRoute(
                  path: 'meetCategory',
                  name: 'meetCategory',
                  builder: (context, state) {
                    return const MeetCategory();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
