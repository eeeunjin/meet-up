import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/login/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginVerification extends StatelessWidget {
  const LoginVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        resizeToAvoidBottomInset: true, // 키보드 오버플로우 해결
        body: SafeArea(
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    // 키패드 올라왔을 때
    final double keyboardOpen = MediaQuery.of(context).viewInsets.bottom;
    // 키보드 올라왔으면 패딩 30, 내려갔으면 80
    final double bottomPadding = keyboardOpen > 0 ? 30.0 : 80.0.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.h, left: 9.w),
          child:
              // header
              _header(context),
        ),
        SizedBox(
          height: 30.h,
        ),
        _main(),
        _verification(),
        // 빈공간
        const Spacer(),
        Padding(
          // Apply the padding dynamically based on the keyboard state
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: _bottom(context),
        ),
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
          '로그인',
          style: TextStyle(fontSize: 22.sp),
        ),
      ],
    );
  }

  Widget _main() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 28.0.w),
          child: Text(
            '인증번호를 입력해주세요',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
          ),
        ),
        SizedBox(
          height: 32.h,
        ),
        Center(
          child: SizedBox(
            width: 339.w,
            height: 74.h,
            child: TextField(
              decoration: InputDecoration(
                hintText: '인증번호',
                hintStyle: TextStyle(fontSize: 12.sp),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: const Color(0xffD2D8F8),
                    width: 2.5.w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: const Color(0xffD2D8F8),
                    width: 2.5.w,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _verification() {
    return Padding(
      padding: EdgeInsets.only(left: 40.0.w, top: 25.h),
      child: Stack(
        children: [
          Column(
            children: [
              Text(
                '인증번호 재전송',
                style: TextStyle(fontSize: 12.sp),
              ),
              SizedBox(
                height: 3.h,
              ),
            ],
          ),
          // 간격을 위한 텍스트 밑줄 대용
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: NextButton(
        onTap: () {
          // 인증번호 일치하면 다음 화면으로 넘어감
        },
        text: '인증번호 확인',
        fontSize: 18.sp,
        height: 60.h,
      ),
    );
  }
}
