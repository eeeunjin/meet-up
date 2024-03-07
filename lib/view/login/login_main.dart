import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/util/color.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _loginButton(),
          SizedBox(
            // 여백
            height: 40.h,
          ),
          _signUpButton(),
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
        borderRadius: BorderRadiusDirectional.circular(16.r),
      ),
      child: const Center(child: Text('회원가입')),
    );
  }
}
