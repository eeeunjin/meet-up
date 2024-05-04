import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/loginFunc.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/view/chat/chat_main.dart';
import 'package:meet_up/view/coin/coin_main.dart';
import 'package:meet_up/view/login/login_main.dart';
import 'package:meet_up/view/login/login_phone_num.dart';
import 'package:meet_up/view/login/login_verification.dart';
import 'package:meet_up/view/meet/meet_location.dart';
import 'package:meet_up/view/meet/meet_manage_main.dart';
import 'package:meet_up/view/meet/meet_browse_main.dart';
import 'package:meet_up/view/meet/meet_category.dart';
import 'package:meet_up/view/meet/meet_create.dart';
import 'package:meet_up/view/meet/meet_filter.dart';
import 'package:meet_up/view/meet/meet_filter_area.dart';
import 'package:meet_up/view/meet/meet_keyword.dart';
import 'package:meet_up/view/meet/meet_main.dart';
import 'package:meet_up/view/meet/meet_room_detail.dart';
import 'package:meet_up/view/meet/meet_search_main.dart';
import 'package:meet_up/view/profile/profile_edit.dart';
import 'package:meet_up/view/profile/profile_main.dart';
import 'package:meet_up/view/profile/profile_notification.dart';
import 'package:meet_up/view/reflect/reflect_main.dart';
import 'package:meet_up/view/schedule/add_personal_schedule.dart';
import 'package:meet_up/view/schedule/schedule_main.dart';
import 'package:meet_up/view/setting/setting_main.dart';
import 'package:meet_up/view/setting/setting_notification.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_one.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_five.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_four.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_three.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_two.dart';
import 'package:meet_up/view/sign_up/sign_up_verification.dart';
import 'package:meet_up/view/sign_up/sign_up_phone_num.dart';
import 'package:meet_up/view/widget/bot_nav_bar.dart';

final GlobalKey<NavigatorState> rootNavkey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavkey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavkey,
  initialLocation: '/',
  routes: <RouteBase>[
    // ShellRoute
    ShellRoute(
      navigatorKey: shellNavkey,
      builder: (context, state, child) => Scaffold(
        body: child,
        bottomNavigationBar: const BotNavBar(),
      ),
      routes: [
        // Meet
        GoRoute(
          // path: '.', // ShellRoute에서 현재 경로 나타낼 때 . 을 사용
          path: '/meetMain',
          name: 'meetMain',
          builder: (context, state) => const MeetMain(),
        ),
        // Chat
        GoRoute(
          path: '/chatMain',
          builder: (context, state) => const ChatMain(),
        ),
        // Schedule
        GoRoute(
          path: '/scheduleMain',
          builder: (context, state) => const ScheduleMain(),
        ),
        // Reflect
        GoRoute(
          path: '/ReflectMain',
          builder: (context, state) => const ReflectMain(),
        ),
        // Profile
        GoRoute(
          path: '/profileMain',
          builder: (context, state) => const ProfileMain(),
        ),
      ],
    ),

    // 초기 화면
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        if (LoginFunc.isLogined) {
          return const NoTransitionPage(child: BotNavBar());
        } else {
          return const NoTransitionPage(child: LoginMain());
        }
      },
      routes: [
        //MARK: - Login
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

        //MARK: - SignUp
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

        //MARK: - Meet
        GoRoute(
          path: 'meetManageMain',
          name: 'meetManageMain',
          builder: (context, state) => const Scaffold(
            body: MeetManageMain(), // meetMain에서만 바텀 네비게이션 표시
          ),
          routes: [
            GoRoute(
              path: 'meetManageMain/coinMain',
              name: 'coinMainFromMeetManageMain',
              builder: (context, state) {
                return const CoinMain(fromRoute: 'meetManageMain');
              },
            ),
            GoRoute(
              path: 'roomDetail',
              name: 'roomDetail',
              builder: (context, state) {
                final roomModel = state.extra as RoomModel;
                return RoomDetail(roomModel: roomModel);
              },
            ),
          ],
        ),
        GoRoute(
          path: 'meetSearchMain',
          name: 'meetSearchMain',
          builder: (context, state) {
            return const Scaffold(body: MeetSearchMain());
          },
        ),
        GoRoute(
          path: 'meetBrowseMain',
          name: 'meetBrowseMain',
          builder: (context, state) {
            return const Scaffold(body: MeetBrowseMain());
          },
        ),
        GoRoute(
          path: 'meetFilterMain',
          name: 'meetFilterMain',
          builder: (context, state) {
            return const Scaffold(body: MeetFilterMain());
          },
          routes: [
            GoRoute(
              path: 'meetFilterArea',
              name: 'meetFilterArea',
              builder: (context, state) {
                return const Scaffold(body: MeetFilterArea());
              },
            ),
          ],
        ),
        GoRoute(
          path: 'coinMain',
          name: 'coinMainFromMeetMain',
          builder: (context, state) {
            return const Scaffold(body: CoinMain(fromRoute: 'meetMain'));
          },
        ),
        GoRoute(
          path: 'meetCreate',
          name: 'meetCreate',
          builder: (context, state) {
            return const Scaffold(body: MeetCreate());
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
            GoRoute(
              path: 'meetLocation',
              name: 'meetLocation',
              builder: (context, state) {
                return const MeetLocation();
              },
            ),
          ],
        ),

        //MARK: - Schedule
        GoRoute(
          path: 'addPersonalSchedule',
          builder: (context, state) {
            return const AddPersonalSchedule();
          },
        ),

        //MARK: - Profile
        GoRoute(
          path: 'profileEdit',
          builder: (context, state) {
            return const ProfileEdit();
          },
        ),
        GoRoute(
          path: 'profileNoticationMain',
          builder: (context, state) {
            return const ProfileNotification();
          },
        ),
        // Setting
        GoRoute(
          path: 'settingMain',
          builder: (context, state) {
            return const SettingMain();
          },
          routes: [
            GoRoute(
              path: 'settingNotification',
              name: 'settingNotification',
              builder: (context, state) {
                return const SettingNotification();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
