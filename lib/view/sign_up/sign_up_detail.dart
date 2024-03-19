import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/sign_up/sign_up_detail_contents.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:provider/provider.dart';

class SignUpDetail extends StatelessWidget {
  const SignUpDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpDetailViewModel>(
      create: (_) => SignUpDetailViewModel(),
      child: Scaffold(
        body: SafeArea(child: _body(context)),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 9.w),
          child: _header(context),
        ),
        SizedBox(height: 17.h),
        _progressBar(),
        SizedBox(
          height: 47.h,
        ),
        _main(),
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

  Widget _header(BuildContext context) {
    return Row(
      children: [
        _back(context),
        SizedBox(
          // 여백
          width: 119.w,
        ),
        Text(
          '회원가입',
          style: TextStyle(fontSize: 22.sp),
        ),
      ],
    );
  }

  Widget _progressBar() {
    return Column(
      children: [
        Image.asset(ImagePath.signUpProgressBar_1),
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

  Widget _main() {
    return const Expanded(
      child: SingleChildScrollView(
        child: SignUpDetailContents(),
      ),
    );
  }
}
