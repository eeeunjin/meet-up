import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_one_contents.dart';
import 'package:meet_up/view/widget/header_widget.dart';

class SignUpDetailOne extends StatelessWidget {
  const SignUpDetailOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Platform.isIOS)
              _header(context)
            else if (Platform.isAndroid)
              Padding(
                padding: EdgeInsets.only(
                  top: 15.h,
                ),
                child: _header(context),
              ),
            SizedBox(height: 17.h),
            _progressBar(),
            _main(context),
          ],
        ),
      ),
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

  Widget _header(BuildContext context) {
    return header(back: null, title: '프로필 입력');
  }

  Widget _progressBar() {
    return Column(
      children: [
        Image.asset(ImagePath.signUpProgressBar_1,
            width: 393.w, fit: BoxFit.cover),
        SizedBox(height: 17.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '1',
              style: TextStyle(
                  color: const Color(0xFF170F64),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.0.h),
              child: const Text('/5'),
            )
          ],
        )
      ],
    );
  }

  Widget _main(BuildContext context) {
    return const Expanded(
      child: SingleChildScrollView(
        child: SignUpDetailOneContents(),
      ),
    );
  }
}
