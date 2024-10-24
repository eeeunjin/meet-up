import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:meet_up/loginFunc.dart';
import 'package:meet_up/model/good_history_model.dart';
import 'package:meet_up/router.dart';
import 'package:meet_up/service/remote/firebase_options.dart';
import 'package:meet_up/view_model/bot_nav_view_model.dart';
import 'package:meet_up/view_model/chat/chat_room_meeting_review_view_model.dart';
import 'package:meet_up/view_model/chat/chat_room_schedule_register_view_model.dart';
import 'package:meet_up/view_model/chat/chat_room_view_model.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:meet_up/view_model/coin/coin_buy_view_model.dart';
import 'package:meet_up/view_model/coin/coin_ticket_purchase_history_view_model.dart';
import 'package:meet_up/view_model/coin/ticket_buy_view_model.dart';
import 'package:meet_up/view_model/login/login_phone_num_view_model.dart';
import 'package:meet_up/view_model/login/login_verification_view_model.dart';
import 'package:meet_up/view_model/meet/meet_browse_view_model.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:meet_up/view_model/meet/meet_detail_room_view_model.dart';
import 'package:meet_up/view_model/meet/meet_filter_view_model.dart';
import 'package:meet_up/view_model/meet/meet_keyword_view_model.dart';
import 'package:meet_up/view_model/meet/meet_manage_view_model.dart';
import 'package:meet_up/view_model/meet/meet_user_info_view_model.dart';
import 'package:meet_up/view_model/profile/profile_review_view_model.dart';
import 'package:meet_up/view_model/profile/profile_view_model.dart';
import 'package:meet_up/view_model/reflect/reflect_record_view_model.dart';
import 'package:meet_up/view_model/reflect/reflect_view_model.dart';
import 'package:meet_up/view_model/reflect/reflect_write_diary_view_model.dart';
import 'package:meet_up/view_model/schedule/schedule_add_member_view_model.dart';
import 'package:meet_up/view_model/schedule/schedule_add_personal_schdule_view_model.dart';
import 'package:meet_up/view_model/schedule/schedule_main_view_model.dart';
import 'package:meet_up/view_model/setting/setting_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_phone_num_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_verification_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await initializeFirebase();
  await LoginFunc.autoLogin();
  await initializeDateFormatting('ko_KR', null);

  DateTime currentDate = DateTime.now();
  DateTime birthDate19YearsAgo =
      DateTime(currentDate.year - 19, currentDate.month, currentDate.day);
  if (!isDateValid(birthDate19YearsAgo)) {
    // 유효하지 않으면 1일 전의 날짜를 다시 계산
    birthDate19YearsAgo =
        DateTime(currentDate.year - 19, currentDate.month, currentDate.day - 1);
  }
  DateTime birthDate60YearsAgo =
      DateTime(currentDate.year - 60, currentDate.month, currentDate.day);
  if (!isDateValid(birthDate60YearsAgo)) {
    // 유효하지 않으면 1일 전의 날짜를 다시 계산
    birthDate60YearsAgo =
        DateTime(currentDate.year - 60, currentDate.month, currentDate.day - 1);
  }
  DateTime oneMonthAgo = currentDate.subtract(const Duration(days: 30));
  DateTime twoYearsLater =
      DateTime(currentDate.year + 2, currentDate.month, currentDate.day);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => BottomNavigationBarViewModel()),
        ChangeNotifierProvider(create: (context) => SignUpPhoneNumViewModel()),
        ChangeNotifierProvider(
            create: (context) => SignUpVerificationViewModel()),
        ChangeNotifierProvider(
            create: (context) => LoginVerificationViewModel()),
        ChangeNotifierProvider(create: (context) => LoginPhoneNumViewModel()),
        ChangeNotifierProvider(
          create: (context) => SignUpDetailViewModel(
            init: DateTime.now().subtract(const Duration(days: 365 * 20)),
            start: birthDate60YearsAgo,
            end: birthDate19YearsAgo,
          ),
        ),
        ChangeNotifierProvider(create: (context) => MeetCreateViewModel()),
        ChangeNotifierProvider(create: (context) => MeetKeywordViewModel()),
        ChangeNotifierProvider(create: (context) => MeetManageViewModel()),
        ChangeNotifierProvider(create: (context) => MeetDetailRoomViewModel()),
        ChangeNotifierProvider(create: (context) => MeetBrowseViewModel()),
        ChangeNotifierProvider(create: (context) => MeetFilterViewModel()),
        ChangeNotifierProvider(create: (context) => ScheduleMainViewModel()),
        ChangeNotifierProvider(
          create: (context) => ScheduleAddPersonalScheduleViewModel(
            init: DateTime.now(),
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 14)),
          ),
        ),
        ChangeNotifierProvider(
            create: (create) => ScheduleAddMemberViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => ChatRoomViewModel()),
        ChangeNotifierProvider(
            create: (context) => ChatRoomSchduleRegisterViewModel(
                  init: currentDate,
                  start: oneMonthAgo,
                  end: twoYearsLater,
                )),
        ChangeNotifierProvider(
            create: ((context) => ChatRoomMeetingReviewViewModel())),
        ChangeNotifierProvider(create: (context) => MeetUserInfoViewModel()),
        ChangeNotifierProvider(create: (context) => CoinBuyViewModel()),
        ChangeNotifierProvider(create: (context) => TicketBuyViewModel()),
        ChangeNotifierProvider(
            create: (context) => CoinTicketPurchaseHistoryViewModel()),
        ChangeNotifierProvider(create: (context) => SettingViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileReviewViewModel()),
        ChangeNotifierProvider(
          create: (context) => ChatViewModel(
            init: DateTime.now(),
            start: DateTime(2020, 1, 1),
            end: DateTime(2025, 12, 31),
          ),
        ),
        ChangeNotifierProvider(create: (context) => ReflectViewModel()),
        ChangeNotifierProvider(create: (context) => ReflectRecordViewModel()),
        ChangeNotifierProvider(
            create: (context) => ReflectWriteDiaryViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

bool isDateValid(DateTime date) {
  // 유효한 날짜인지 확인하는 코드
  try {
    // DateTime 객체를 생성하면서 예외가 발생하지 않으면 유효한 날짜
    DateTime(date.year, date.month, date.day);
    return true;
  } catch (e) {
    // 예외가 발생하면 유효하지 않은 날짜
    return false;
  }
}

Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList, BuildContext context) async {
  final userViewModel = Provider.of<UserViewModel>(context, listen: false);
  final coinBuyViewModel =
      Provider.of<CoinBuyViewModel>(context, listen: false);

  for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
    logger.d("purchaseDetails: ${purchaseDetails.productID}");
    if (purchaseDetails.status == PurchaseStatus.pending) {
      logger.d('Purchase pending');
      coinBuyViewModel.setPurchaseStatus('pending');
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        logger.e('Purchase error');
        coinBuyViewModel.setPurchaseStatus('error');
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        logger.d('Purchase purchased');
        await InAppPurchase.instance.completePurchase(purchaseDetails);

        // 사용자 데이터 업데이트
        int userCoin = userViewModel.userModel?.coin ?? -1;
        int purchaseCoin =
            int.parse(purchaseDetails.productID.split('_')[0].substring(4));
        int resultCoin = userCoin + purchaseCoin;

        await userViewModel.updateUserInfo(data: {
          'coin': resultCoin,
        });

        // 상품 구매 정보(영수증) 데이터베이스에 저장
        GoodHistoryModel ghm = GoodHistoryModel(
          gh_type: GoodHistoryType.coin.name,
          gh_type_transaction: GoodHistoryTypeOfTransaction.purchase.name,
          gh_uid: userViewModel.uid!,
          gh_result_coin: resultCoin,
          gh_result_ticket: userViewModel.userModel?.ticket ?? -1,
          gh_change_coin_amount: purchaseCoin,
          gh_change_ticket_amount: 0,
          gh_product_id: purchaseDetails.productID,
          gh_change_date: Timestamp.now(),
        );

        await coinBuyViewModel.createGoodHistory(goodHistoryModel: ghm);
        coinBuyViewModel.setPurchaseStatus('purchased');
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        logger.d('Purchase canceld');

        await InAppPurchase.instance.completePurchase(purchaseDetails);
        coinBuyViewModel.setPurchaseStatus('canceled');
      }
    }
  }
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // InAppPurchase 초기화
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList, context);
    }, onDone: () {
      logger.d("Subscription done");
      _subscription.cancel();
    }, onError: (Object error) {
      logger.e("Purchase error: $error");
    });

    return Selector<UserViewModel, bool>(
        builder: (context, value, child) {
          logger.d("[main.dart] rebuilded");
          logger.d("[main.dart] isLogined: ${LoginFunc.isLogined}");
          // 자동 로그인 된 경우
          final userViewModel =
              Provider.of<UserViewModel>(context, listen: false);
          if (LoginFunc.isLogined) {
            userViewModel.uid = LoginFunc.uid;
            return FutureBuilder<void>(
              future: userViewModel.loadUserModel(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ScreenUtilInit(
                    designSize: const Size(393, 852), // 화면 크기 설정
                    minTextAdapt: true,
                    builder: (_, context) => MaterialApp.router(
                      // Go Router 설정
                      routerConfig: router,
                      // routeInformationParser: router.routeInformationParser,
                      // routerDelegate: router.routerDelegate,
                      theme: ThemeData(
                        // themedata 설정
                        scaffoldBackgroundColor: Colors.white,
                      ),
                      debugShowCheckedModeBanner: false, // Debug 배너 없애기
                    ),
                  );
                }
              },
            );
          }
          // 자동 로그인 안된 경우
          else {
            return ScreenUtilInit(
              designSize: const Size(393, 852), // 화면 크기 설정
              // minTextAdapt: true,
              builder: (_, context) => MaterialApp.router(
                // Go Router 설정
                routerConfig: router,
                // routeInformationParser: router.routeInformationParser,
                // routerDelegate: router.routerDelegate,
                theme: ThemeData(
                  // themedata 설정
                  scaffoldBackgroundColor: Colors.white,
                ),
                debugShowCheckedModeBanner: false, // Debug 배너 없애기
              ),
            );
          }
        },
        selector: (_, userViewModel) => userViewModel.rebuild);
  }
}
