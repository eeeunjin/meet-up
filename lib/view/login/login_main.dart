import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';

const storage = FlutterSecureStorage();

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 163.h,
            ),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 190.w,
                height: 190.h,
              ),
            ),
            SizedBox(
              height: 210.h,
            ),
            GestureDetector(
              onTap: () {
                context.goNamed('loginPhoneNum');
              },
              child: _loginButton(),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "또는",
              style: AppTextStyles.SU_M_17.copyWith(
                color: UsedColor.text_5,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            GestureDetector(
                onTap: () {
                  context.goNamed('signUpPhoneNum');
                },
                child: _signUpButton()),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      width: 287.w,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(19.r),
        color: UsedColor.button,
      ),
      child: Center(
        child: Text(
          '로그인',
          style: AppTextStyles.PR_B_18.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return Container(
      width: 287.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.circular(19.r),
        border: Border.all(
          color: UsedColor.progress_bar, // 테두리 색상
          width: 2.5, // 테두리 굵기
        ),
      ),
      child: Center(
        child: Text(
          '회원가입',
          style: AppTextStyles.PR_B_18.copyWith(color: UsedColor.violet),
        ),
      ),
    );
  }
}
