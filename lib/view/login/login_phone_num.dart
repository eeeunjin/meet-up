import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';

class LoginPhoneNum extends StatelessWidget {
  const LoginPhoneNum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.h, left: 9.w),
          child: Row(
            children: [
              _back(context),
              SizedBox(
                // 여백
                width: 119.w,
              ),
              Text(
                '로그인',
                style: TextStyle(fontSize: 22.sp),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(), // 뒤로가기
      child: Image.asset(
        ImagePath.back,
        width: 40.w,
        height: 40.h,
      ),
    );
  }
}
