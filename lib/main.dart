import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
import 'package:meet_up/service/remote/firebase_options.dart';
=======
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/firebase_options.dart';
>>>>>>> 2f95f12e871bb6d04cad1db5fddfd7dab70253ef
import 'package:flutter/material.dart';
import 'package:meet_up/router.dart';

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
