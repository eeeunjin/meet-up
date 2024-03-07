import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/view/login/login_main.dart';

void main() async {
  await initializeFirebase();
  runApp(const MyApp());
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
      builder: (_, context) => MaterialApp(
        theme: ThemeData(
            // themedata 설정
            ),
        debugShowCheckedModeBanner: false, // Debug 배너 없애기
        home: const LoginMain(), // login_main화면을 홈으로 설정
      ),
    );
  }
}
