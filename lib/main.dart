import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_up/loginFunc.dart';
import 'package:meet_up/router.dart';
import 'package:meet_up/service/remote/firebase_options.dart';
import 'package:meet_up/view_model/bot_nav_view_model.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:meet_up/view_model/coin/coin_buy_view_model.dart';
import 'package:meet_up/view_model/login/login_phone_num_view_model.dart';
import 'package:meet_up/view_model/login/login_verification_view_model.dart';
import 'package:meet_up/view_model/meet/meet_browse_view_model.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:meet_up/view_model/meet/meet_detail_room_view_model.dart';
import 'package:meet_up/view_model/meet/meet_filter_view_model.dart';
import 'package:meet_up/view_model/meet/meet_keyword_view_model.dart';
import 'package:meet_up/view_model/meet/meet_manage_view_model.dart';
import 'package:meet_up/view_model/meet/meet_user_info_view_model.dart';
import 'package:meet_up/view_model/profile/profile_view_model.dart';
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
  await initializeFirebase();
  await LoginFunc.autoLogin();

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
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => ChatViewModel()),
        ChangeNotifierProvider(create: (context) => MeetUserInfoViewModel()),
        ChangeNotifierProvider(create: (context) => CoinBuyViewModel()),
        ChangeNotifierProvider(create: (context) => SettingViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
      ],
      child: const MyApp(),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserViewModel>(context, listen: false);
    // 자동 로그인 된 경우
    if (LoginFunc.isLogined) {
      logger.d('자동 로그인 되었습니다');
      userModel.uid = LoginFunc.uid;
      return FutureBuilder<void>(
        future: userModel.loadUserModel(),
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
      logger.d('직접 로그인');
      return Consumer<UserViewModel>(
        builder: (context, value, child) {
          return FutureBuilder<void>(
            future: value.loadUserModel(),
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
        },
      );
    }
  }
}
