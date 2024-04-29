import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';

const storage = FlutterSecureStorage();

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 163.h,
            ),
            Center(
              child: Icon(
                Icons.cloud_outlined,
                color: UsedColor.Button_01,
                size: 190.h,
              ),
            ),
            SizedBox(height: 220.h - 80.h - 80.h // testView,meetView
                ),
            // <----- meet test view ------> // 80.h
            GestureDetector(
                onTap: () {
                  context.push('/meetMain');
                },
                child: _meetTestButton()),
            SizedBox(
              // 여백
              height: 10.h,
            ),
            // <----- test view ------> // 80.h
            GestureDetector(
                onTap: () {
                  context.goNamed('signUpDetailTwo');
                },
                child: _detailSettingButton()),
            SizedBox(
              // 여백
              height: 10.h,
            ),
            // <----- test view ------> //
            GestureDetector(
                onTap: () {
                  context.goNamed('loginPhoneNum');
                },
                child: _loginButton()),
            SizedBox(
              height: 1.h,
            ),
            Text(
              "또는",
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff9D9D9D),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            GestureDetector(
                onTap: () {
                  context.goNamed('signUpPhoneNum');
                },
                child: _signUpButton()),
            SizedBox(
              // 여백
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      width: 286.w,
      height: 56.64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(19.r),
        color: UsedColor.Button_01,
      ),
      child: const Center(
        child: Text(
          '로그인',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return Container(
      width: 286.w,
      height: 56.64.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.circular(19.r),
        border: Border.all(
          color: const Color(0xff9798F1), // 테두리 색상
          width: 2.5, // 테두리 굵기
        ),
      ),
      child: const Center(
        child: Text(
          '회원가입',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xff7A6AF7),
          ),
        ),
      ),
    );
  }

  Widget _detailSettingButton() {
    return Container(
      width: 286.w,
      height: 56.64.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.circular(19.r),
        border: Border.all(
          color: const Color(0xff9798F1), // 테두리 색상
          width: 2.5, // 테두리 굵기
        ),
      ),
      child: const Center(
        child: Text(
          '회원가입 상세 테스트 뷰',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xff7A6AF7),
          ),
        ),
      ),
    );
  }

  Widget _meetTestButton() {
    return Container(
      width: 286.w,
      height: 56.64.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.circular(19.r),
        border: Border.all(
          color: const Color(0xff9798F1), // 테두리 색상
          width: 2.5, // 테두리 굵기
        ),
      ),
      child: const Center(
        child: Text(
          '만남 테스트 뷰',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xff7A6AF7),
          ),
        ),
      ),
    );
  }

  Future<String?> autoLogin({required BuildContext context}) async {
    String? uid = await storage.read(key: 'uid');
    if (uid != null) {
      return uid;
    } else {
      return null;
    }
  }
}
