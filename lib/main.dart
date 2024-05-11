import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/loginFunc.dart';
import 'package:meet_up/notificationHandler.dart';
import 'package:meet_up/router.dart';
import 'package:meet_up/service/remote/firebase_options.dart';
import 'package:meet_up/view_model/bot_nav_view_model.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:meet_up/view_model/login/login_phone_num_view_model.dart';
import 'package:meet_up/view_model/login/login_verification_view_model.dart';
import 'package:meet_up/view_model/meet/meet_browse_view_model.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:meet_up/view_model/meet/meet_manage_view_model.dart';
import 'package:meet_up/view_model/schedule/schedule_main_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_phone_num_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_verification_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  await LoginFunc.autoLogin();

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
            init: DateTime.now().subtract(const Duration(days: 365 * 19)),
            start: DateTime.now().subtract(const Duration(days: 365 * 60)),
            end: DateTime.now().subtract(const Duration(days: 365 * 19)),
          ),
        ),
        ChangeNotifierProvider(create: (context) => MeetCreateViewModel()),
        ChangeNotifierProvider(create: (context) => MeetManageViewModel()),
        ChangeNotifierProvider(create: (context) => MeetBrowseViewModel()),
        ChangeNotifierProvider(create: (context) => ScheduleMainViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => ChatViewModel()),
      ],
      child: const MyApp(),
    ),
  );
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
    final userModel = Provider.of<UserViewModel>(context);

    // 자동 로그인 된 경우
    if (LoginFunc.isLogined) {
      userModel.uid = LoginFunc.uid;
      return FutureBuilder<void>(
        future: userModel.loadUserModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error Occur"),
            );
          } else {
            return ScreenUtilInit(
              designSize: const Size(393, 852), // 화면 크기 설정
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
  }
}
