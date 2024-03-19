import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/login/login_phone_num_view_model.dart';
import 'package:provider/provider.dart';

class LoginPhoneNum extends StatelessWidget {
  const LoginPhoneNum({super.key});

  // build
  @override
  Widget build(BuildContext context) {
    final double keyboardOpen = MediaQuery.of(context).viewInsets.bottom;
    final double bottomPadding = keyboardOpen > 0 ? 30.0 : 80.0.h;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 9.w),
              child: _header(context),
            ),
            SizedBox(height: 30.h),
            _main(context),
            Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: _bottom(context),
            ),
          ],
        ),
      ),
    );
  }

  // header
  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
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
        SizedBox(width: 119.w),
        Text(
          '로그인',
          style: TextStyle(fontSize: 22.sp),
        ),
      ],
    );
  }

  // main
  Widget _main(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 32.0.w),
              child: Text(
                '휴대폰 번호를 입력해주세요',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
              ),
            ),
            SizedBox(height: 32.h),
            Consumer<LoginPhoneNumViewModel>(
              builder: (context, viewModel, child) => Center(
                child: SizedBox(
                  width: 339.w,
                  height: 74.h,
                  child: Stack(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          bool shouldFieldBeFocused =
                              value.isNotEmpty || viewModel.isTextFieldFocused;
                          if (viewModel.isTextFieldFocused !=
                              shouldFieldBeFocused) {
                            viewModel.setIsTextFieldFocusd(
                                isTextFieldFocused: shouldFieldBeFocused);
                          }
                          viewModel.setIsPhoneNumberValid(value);
                        },
                        onTap: () {
                          viewModel.setIsTextFieldFocusd(
                              isTextFieldFocused: true);
                        },
                        onFieldSubmitted: (value) {
                          viewModel.setIsTextFieldFocusd(
                              isTextFieldFocused: false);
                        },
                        controller: viewModel.controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                                color: viewModel.controller.text.isNotEmpty
                                    ? (viewModel.isPhoneNumberValid
                                        ? Colors.green
                                        : Colors.red)
                                    : const Color(0xFFD2D8F8),
                                width: 2.5.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                                color: viewModel.isPhoneNumberValid
                                    ? Colors.green
                                    : Colors.red,
                                width: 2.5.w),
                          ),
                        ),
                      ),
                      if (!viewModel.isTextFieldFocused &&
                          viewModel.controller.text.isEmpty)
                        Positioned(
                          top: 13.h,
                          left: 18.w,
                          child: Text(
                            "휴대폰 번호",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF8D8D8D)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // bottom
  Widget _bottom(BuildContext context) {
    return Consumer<LoginPhoneNumViewModel>(
      builder: (context, viewModel, child) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: NextButton(
          onTap: () {
            // phoneNum 유효성 검사 실패 시, return
            if (viewModel.isPhoneNumberValid) return;


            // Auth 관련 동작 - viewModel에서 진행
            

            // sms 전달 완료 시, loginVerification view로 이동
            context.push('/loginVerification');
            
          },
          text: '다음',
          height: 60.h,
          fontSize: 18.sp,
          enable: viewModel.isPhoneNumberValid,
          backgroundColor: viewModel.isPhoneNumberValid
              ? Colors.green
              : const Color(0xFFD9D9D9),
          textStyle: TextStyle(
            color: viewModel.isPhoneNumberValid ? Colors.white : Colors.black,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
