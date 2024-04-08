import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/router.dart';
import 'package:meet_up/service/remote/firebase_options.dart';
import 'package:meet_up/view_model/login/login_phone_num_view_model.dart';
import 'package:meet_up/view_model/login/login_verification_view_model.dart';
import 'package:meet_up/view_model/meet/meet_browse_view_model.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_phone_num_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_verification_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeFirebase();
  runApp(
    MultiProvider(
      providers: [
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
        ChangeNotifierProvider(create: (context) => MeetBrowseViewModel()),
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
    return ScreenUtilInit(
      designSize: const Size(393, 852), // 화면 크기 설정
      builder: (_, context) => MaterialApp.router(
        // Go Router 설정
        routerConfig: router,
        theme: ThemeData(
          // themedata 설정
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false, // Debug 배너 없애기
      ),
    );
  }
}
