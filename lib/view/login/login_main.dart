import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                context.push('/phoneNum');
              },
              child: _loginButton()),
          SizedBox(
            // 여백
            height: 40.h,
          ),
          GestureDetector(
              onTap: () {
                context.push('/signUpPhoneNum');
              },
              child: _signUpButton()),
          SizedBox(
            // 여백
            height: 40.h,
          ),
          GestureDetector(
              onTap: () {
                context.push('/signUpDetail');
              },
              child: _detailSettingButton()),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      width: 286.w,
      height: 56.64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(16.r),
        color: UsedColor.Button_01,
      ),
      child: const Center(child: Text('로그인')),
    );
  }

  Widget _signUpButton() {
    return Container(
      width: 286.w,
      height: 56.64.h,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadiusDirectional.circular(16.r),
      ),
      child: const Center(child: Text('회원가입')),
    );
  }

  Widget _detailSettingButton() {
    return Container(
      width: 286.w,
      height: 56.64.h,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadiusDirectional.circular(16.r),
      ),
      child: const Center(child: Text('회원가입 세부설정')),
    );
  }
}
