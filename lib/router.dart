import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/loginFunc.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/view/chat/chat_main.dart';
import 'package:meet_up/view/chat/chat_meeting_review.dart';
import 'package:meet_up/view/chat/chat_notification_onboarding.dart';
import 'package:meet_up/view/chat/chat_room.dart';
import 'package:meet_up/view/chat/chat_schedule_register.dart';
import 'package:meet_up/view/chat/chat_schedule_check.dart';
import 'package:meet_up/view/coin/coin_buy.dart';
import 'package:meet_up/view/coin/coin_buy_success.dart';
import 'package:meet_up/view/coin/coin_main.dart';
import 'package:meet_up/view/coin/coin_purchase_history.dart';
import 'package:meet_up/view/coin/ticket_buy.dart';
import 'package:meet_up/view/coin/ticket_buy_success.dart';
import 'package:meet_up/view/coin/ticket_purchase_history.dart';
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
import 'package:meet_up/view/meet/meet_detail_room.dart';
import 'package:meet_up/view/meet/meet_user_info.dart';
import 'package:meet_up/view/profile/profile_edit.dart';
import 'package:meet_up/view/profile/profile_main.dart';
import 'package:meet_up/view/profile/profile_meeting_review.dart';
import 'package:meet_up/view/profile/profile_notification.dart';
import 'package:meet_up/view/profile/rank_main.dart';
import 'package:meet_up/view/reflect/reflect_write_diary.dart';
import 'package:meet_up/view/reflect/reflect_diary_more.dart';
import 'package:meet_up/view/reflect/reflect_diary_view.dart';
import 'package:meet_up/view/reflect/reflect_main.dart';
import 'package:meet_up/view/reflect/reflect_record_more.dart';
import 'package:meet_up/view/reflect/reflect_select_diary_question.dart';
import 'package:meet_up/view/schedule/add_member_personal.dart';
import 'package:meet_up/view/schedule/add_personal_schedule.dart';
import 'package:meet_up/view/schedule/edit_personal_schedule.dart';
import 'package:meet_up/view/schedule/schedule_main.dart';
import 'package:meet_up/view/setting/noticed.dart';
import 'package:meet_up/view/setting/open_source_license.dart';
import 'package:meet_up/view/setting/privacy_policy.dart';
import 'package:meet_up/view/setting/question.dart';
import 'package:meet_up/view/setting/service_usage_details.dart';
import 'package:meet_up/view/setting/setting_main.dart';
import 'package:meet_up/view/setting/setting_notification.dart';
import 'package:meet_up/view/setting/user_info.dart';
import 'package:meet_up/view/setting/withdrawal.dart';
import 'package:meet_up/view/setting/withdrawal_next.dart';
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
    // botNavBar에 포함되는 화면
    ShellRoute(
      navigatorKey: shellNavkey,
      builder: (context, state, child) => Scaffold(
        body: child,
        bottomNavigationBar: const BotNavBar(),
      ),
      routes: [
        // MARK: - Meet
        GoRoute(
          // path: '.', // ShellRoute에서 현재 경로 나타낼 때 . 을 사용
          path: '/meetMain',
          parentNavigatorKey: shellNavkey,
          builder: (context, state) => const MeetMain(),
          routes: [
            GoRoute(
              path: 'coinMain',
              name: 'coinMainFromMeetMain',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const CoinMain(from: 'MeetMain'),
              routes: [
                GoRoute(
                  path: 'coinBuy',
                  name: 'coinBuyFromMeetMain',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const CoinBuy(from: 'MeetMain'),
                  routes: [
                    GoRoute(
                      path: 'coinBuySuccess',
                      name: 'coinBuySuccessFromMeetMain',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) =>
                          const CoinBuySuccess(from: 'MeetMain'),
                    )
                  ],
                ),
                GoRoute(
                  path: 'ticketBuy',
                  name: 'ticketBuyFromMeetMain',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) =>
                      const TicketBuy(from: 'MeetMain'),
                  routes: [
                    GoRoute(
                      path: 'ticketBuySuccess',
                      name: 'ticketBuySuccessFromMeetMain',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) =>
                          const TicketBuySuccess(from: 'MeetMain'),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'coinPurchaseHistory',
                  name: 'coinPurchaseHistoryFromMeetMain',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const CoinPurchaseHistory(),
                ),
                GoRoute(
                  path: 'ticketPurchaseHistory',
                  name: 'ticketPurchaseHistoryFromMeetMain',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const TicketPurchaseHistory(),
                ),
              ],
            ),
            GoRoute(
              path: 'meetManageMain',
              name: 'meetManageMain',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const Scaffold(
                body: MeetManageMain(), // meetMain에서만 바텀 네비게이션 표시
              ),
              routes: [
                GoRoute(
                  path: 'coinMain',
                  name: 'coinMainFromMeetManageMain',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) {
                    return const CoinMain(from: "MeetManageMain");
                  },
                  routes: [
                    GoRoute(
                      path: 'coinBuy',
                      name: 'coinBuyFromMeetManageMain',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) {
                        return const CoinBuy(from: "MeetManageMain");
                      },
                      routes: [
                        GoRoute(
                          path: 'coinBuySuccess',
                          name: 'coinBuySuccessFromMeetManageMain',
                          parentNavigatorKey: rootNavkey,
                          builder: (context, state) {
                            return const CoinBuySuccess(from: 'MeetManageMain');
                          },
                        )
                      ],
                    ),
                    GoRoute(
                      path: 'ticketBuy',
                      name: 'ticketBuyFromMeetManageMain',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) {
                        return const TicketBuy(from: 'MeetManageMain');
                      },
                      routes: [
                        GoRoute(
                          path: 'ticketBuySuccess',
                          name: 'ticketBuySuccessFromMeetManageMain',
                          parentNavigatorKey: rootNavkey,
                          builder: (context, state) {
                            return const TicketBuySuccess(
                                from: 'MeetManageMain');
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      path: 'coinPurchaseHistory',
                      name: 'coinPurchaseHistoryFromMeetManageMain',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) => const CoinPurchaseHistory(),
                    ),
                    GoRoute(
                      path: 'ticketPurchaseHistory',
                      name: 'ticketPurchaseHistoryFromMeetManageMain',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) =>
                          const TicketPurchaseHistory(),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'meetDetailRoom_manage',
                  name: 'meetDetailRoom_manage',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) {
                    return const MeetDetailRoom();
                  },
                  routes: [
                    GoRoute(
                      path: 'meetUserInfo_manage',
                      name: 'meetUserInfo_manage',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) {
                        return const Scaffold(body: MeetUserInfo());
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'meetBrowseMain',
              name: 'meetBrowseMain',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) {
                return const Scaffold(
                  body: MeetBrowseMain(),
                );
              },
              routes: [
                GoRoute(
                  path: 'meetDetailRoom_browse',
                  name: 'meetDetailRoom_browse',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) {
                    return const Scaffold(body: MeetDetailRoom());
                  },
                  routes: [
                    GoRoute(
                      path: 'meetUserInfo_browse',
                      name: 'meetUserInfo_browse',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) {
                        return const Scaffold(body: MeetUserInfo());
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'meetFilterMain',
                  name: 'meetFilterMain',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) {
                    return const Scaffold(body: MeetFilterMain());
                  },
                  routes: [
                    GoRoute(
                      path: 'meetFilterArea',
                      name: 'meetFilterArea',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) {
                        return const Scaffold(body: MeetFilterArea());
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'meetCreate',
              name: 'meetCreate',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) {
                return const Scaffold(body: MeetCreate());
              },
              routes: [
                GoRoute(
                  path: 'meetKeyWord',
                  name: 'meetKeyWord',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) {
                    return const MeetKeyWord();
                  },
                ),
                GoRoute(
                  path: 'meetCategory',
                  name: 'meetCategory',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) {
                    return const MeetCategory();
                  },
                ),
                GoRoute(
                  path: 'meetLocation',
                  name: 'meetLocation',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) {
                    return const MeetLocation();
                  },
                ),
              ],
            ),
          ],
        ),
        // MARK: - Chat
        GoRoute(
          path: '/chatMain',
          builder: (context, state) => const ChatMain(),
          parentNavigatorKey: shellNavkey,
          routes: [
            GoRoute(
              path: 'chatNotificationOnboarding',
              name: 'first_enter_onboarding',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const ChatNotification(),
            ),
            GoRoute(
              path: 'chatRoom',
              name: 'chatRoom',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const ChatRoom(),
              routes: [
                GoRoute(
                  path: 'chatNotificationOnboarding',
                  name: 'chat_room_onboarding',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const ChatNotification(),
                ),
                GoRoute(
                  path: 'chatRoomDetail',
                  name: 'chatRoomDetail',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const MeetDetailRoom(),
                  routes: [
                    GoRoute(
                      path: 'meetUserInfo_chat',
                      name: 'meetUserInfo_chat',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) => const MeetUserInfo(),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'chatScheduleRegister',
                  name: 'chatScheduleRegister',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const ChatScheduleRegister(),
                ),
                GoRoute(
                  path: 'chatScheduleCheck',
                  name: 'chatScheduleCheck',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const ChatScheduleCheck(),
                ),
                GoRoute(
                  path: 'chatMeetingReview',
                  name: 'chatMeetingReview',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => ChatMeetingReview(),
                )
              ],
            ),
          ],
        ),
        // MARK: - Schedule
        GoRoute(
          path: '/scheduleMain',
          builder: (context, state) => const ScheduleMain(),
          parentNavigatorKey: shellNavkey,
          routes: [
            GoRoute(
                path: 'addPersonalSchedule',
                name: 'addPersonalSchedule',
                parentNavigatorKey: rootNavkey,
                builder: (context, state) => const AddPersonalSchedule(),
                routes: [
                  GoRoute(
                    path: 'addMemberPersonal',
                    name: 'addMemberPersonal',
                    parentNavigatorKey: rootNavkey,
                    builder: (context, state) => const AddMemberPersonal(),
                  )
                ]),
            GoRoute(
              path: 'editPersonalSchedule',
              name: 'editPersonalSchedule',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const EditPersonalSchedule(),
              routes: [
                GoRoute(
                  path: 'editMemberPersonal',
                  name: 'editMemberPersonal',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const AddMemberPersonal(),
                ),
              ],
            )
          ],
        ),
        // MARK: - Reflect
        GoRoute(
          path: '/reflectMain',
          name: 'reflectMain',
          builder: (context, state) => const ReflectMain(),
          parentNavigatorKey: shellNavkey,
          routes: [
            GoRoute(
              path: 'reflectRecordMore',
              name: 'reflectRecordMore',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const ReflectRecordMore(),
            ),
            GoRoute(
              path: 'reflectDiaryMore',
              name: 'reflectDiaryMore',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const ReflectDiaryMore(),
            ),
            GoRoute(
              path: 'reflectDiaryDetails',
              name: 'reflectDiaryDetails',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const ReflectDiaryDetails(),
            ),
            GoRoute(
              path: 'reflectSelectDiaryQuestion',
              name: 'reflectSelectDiaryQuestion',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const ReflectSelectDiaryQuestion(),
              routes: [
                GoRoute(
                  path: 'reflectWriteDiary',
                  name: 'reflectWriteDiary',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const ReflectWriteDiary(),
                ),
              ],
            ),
          ],
        ),
        // MARK: - Profile
        GoRoute(
          path: '/profileMain',
          builder: (context, state) => const ProfileMain(),
          parentNavigatorKey: shellNavkey,
          routes: [
            GoRoute(
              path: 'profileEdit',
              name: 'profileEdit',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const ProfileEdit(),
            ),
            GoRoute(
              path: 'profileNoticationMain',
              name: 'profileNoticationMain',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const ProfileNotification(),
            ),
            GoRoute(
              path: 'profileMeetingReview',
              name: 'profileMeetingReview',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const ProfileMeetingReview(),
            ),
            GoRoute(
              path: 'settingMain',
              name: 'settingMain',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const SettingMain(),
              routes: [
                // 회원 정보
                GoRoute(
                  path: 'userInfo',
                  name: 'userInfo',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const UserInfo(),
                  routes: [
                    // 회원 탈퇴
                    GoRoute(
                      path: 'withdrawal',
                      name: 'withdrawal',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) => const Withdrawal(),
                      routes: [
                        GoRoute(
                          path: 'withdrawalNext',
                          name: 'withdrawalNext',
                          parentNavigatorKey: rootNavkey,
                          builder: (context, state) => const WithdrawalNext(),
                        )
                      ],
                    ),
                  ],
                ),
                // 알림 설정
                GoRoute(
                  path: 'settingNotification',
                  name: 'settingNotification',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const SettingNotification(),
                ),
                // 자주 묻는 질문
                GoRoute(
                  path: 'question',
                  name: 'question',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const Question(),
                ),
                // 공지사항
                GoRoute(
                  path: 'noticed',
                  name: 'noticed',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const Noticed(),
                ),
                // 개인정보처리방침
                GoRoute(
                  path: 'privacyPolicy',
                  name: 'privacyPolicy',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const PrivacyPolicy(),
                ),
                // 서비스 이용약관
                GoRoute(
                  path: 'accessTerms',
                  name: 'accessTerms',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const AccessTerms(),
                ),
                // 오픈소스라이센스
                GoRoute(
                  path: 'openSourceLicense',
                  name: 'openSourceLicense',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const OpenSourceLicense(),
                ),
              ],
            ),
            GoRoute(
              path: 'rankMain',
              name: 'rankMain',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const RankMain(),
            ),
            GoRoute(
              path: 'coinMain',
              name: 'coinMainFromProfileMain',
              builder: (context, state) => const CoinMain(from: "ProfileMain"),
              parentNavigatorKey: rootNavkey,
              routes: [
                GoRoute(
                  path: 'coinBuy',
                  name: 'coinBuyFromProfileMain',
                  builder: (context, state) =>
                      const CoinBuy(from: "ProfileMain"),
                  parentNavigatorKey: rootNavkey,
                  routes: [
                    GoRoute(
                      path: 'coinBuySuccess',
                      name: 'coinBuySuccessFromProfileMain',
                      builder: (context, state) =>
                          const CoinBuySuccess(from: 'ProfileMain'),
                      parentNavigatorKey: rootNavkey,
                    )
                  ],
                ),
                GoRoute(
                  path: 'ticketBuy',
                  name: 'ticketBuyFromProfileMain',
                  builder: (context, state) =>
                      const TicketBuy(from: 'ProfileMain'),
                  parentNavigatorKey: rootNavkey,
                  routes: [
                    GoRoute(
                      path: 'ticketBuySuccess',
                      name: 'ticketBuySuccessFromProfileMain',
                      builder: (context, state) =>
                          const TicketBuySuccess(from: 'ProfileMain'),
                      parentNavigatorKey: rootNavkey,
                    )
                  ],
                ),
                GoRoute(
                  path: 'coinPurchaseHistory',
                  name: 'coinPurchaseHistoryFromProfileMain',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const CoinPurchaseHistory(),
                ),
                GoRoute(
                  path: 'ticketPurchaseHistory',
                  name: 'ticketPurchaseHistoryFromProfileMain',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const TicketPurchaseHistory(),
                ),
              ],
            )
          ],
        ),
      ],
    ),

    // 초기 화면 (botNavBar에 포함되지 않는 화면)
    GoRoute(
      path: '/',
      parentNavigatorKey: rootNavkey,
      pageBuilder: (context, state) {
        // logger.d("GoRoute Path Location: ${state.fullPath}");
        if (LoginFunc.isLogined) {
          // logger.d("로그인 상태 확인: 로그인 상태입니다.");
          return const NoTransitionPage(child: BotNavBar());
        } else {
          // logger.d("로그인 상태 확인: 로그인 상태가 아닙니다.");
          return const NoTransitionPage(child: LoginMain());
        }
      },
      routes: [
        //MARK: - Login
        GoRoute(
          path: 'loginPhoneNum',
          name: 'loginPhoneNum',
          parentNavigatorKey: rootNavkey,
          builder: (context, state) => const LoginPhoneNum(),
          routes: [
            GoRoute(
              path: 'loginVerification',
              name: 'loginVerification',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const LoginVerification(),
            ),
          ],
        ),

        //MARK: - SignUp
        GoRoute(
          path: 'signUpPhoneNum',
          name: 'signUpPhoneNum',
          parentNavigatorKey: rootNavkey,
          builder: (context, state) => const SignUpPhoneNum(),
          routes: [
            GoRoute(
              path: 'signUpVerification',
              name: 'signUpVerification',
              parentNavigatorKey: rootNavkey,
              builder: (context, state) => const SignUpVerification(),
              routes: [
                GoRoute(
                  path: 'signUpDetailOne',
                  name: 'signUpDetailOne',
                  parentNavigatorKey: rootNavkey,
                  builder: (context, state) => const SignUpDetailOne(),
                  routes: [
                    GoRoute(
                      path: 'signUpDetailTwo',
                      name: 'signUpDetailTwo',
                      parentNavigatorKey: rootNavkey,
                      builder: (context, state) => const SignUpDetailTwo(),
                      routes: [
                        GoRoute(
                          path: 'signUpDetailThree',
                          name: 'signUpDetailThree',
                          parentNavigatorKey: rootNavkey,
                          builder: (context, state) =>
                              const SignUpDetailThree(),
                          routes: [
                            GoRoute(
                              path: 'signUpDetailFour',
                              name: 'signUpDetailFour',
                              parentNavigatorKey: rootNavkey,
                              builder: (context, state) =>
                                  const SignUpDetailFour(),
                              routes: [
                                GoRoute(
                                  path: 'signUpDetailFive',
                                  name: 'signUpDetailFive',
                                  parentNavigatorKey: rootNavkey,
                                  builder: (context, state) =>
                                      const SignUpDetailFive(),
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

      ],
    ),
  ],
);
