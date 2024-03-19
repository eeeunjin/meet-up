import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/sign_up/sign_up_verification_view_model.dart';
import 'package:provider/provider.dart';

class SignUpVerification extends StatelessWidget {
  const SignUpVerification({super.key});

  // build
  @override
  Widget build(BuildContext context) {
    // 키패드 올라왔을 때
    final double keyboardOpen = MediaQuery.of(context).viewInsets.bottom;
    // 키보드 올라왔으면 패딩 30, 내려갔으면 80
    final double bottomPadding = keyboardOpen > 0 ? 30.0 : 80.0.h;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24.h, left: 9.w),
              child: _header(context),
            ),
            SizedBox(
              height: 30.h,
            ),
            _main(context),
            const Spacer(),
            Padding(
              // Apply the padding dynamically based on the keyboard state
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
          '회원 가입',
          style: TextStyle(fontSize: 22.sp),
        ),
      ],
    );
  }

  // main
  Widget _verificationCodeInputField(BuildContext context) {
    final viewModel = Provider.of<SignUpVerificationViewModel>(context);
    return Stack(
      children: [
        TextFormField(
          onChanged: (value) {
            bool shouldFieldBeFocused =
                value.isNotEmpty || viewModel.isTextFieldFocused;
            if (viewModel.isTextFieldFocused != shouldFieldBeFocused) {
              viewModel.setIsTextFieldFocusd(
                  isTextFieldFocused: shouldFieldBeFocused);
            }
          },
          onTap: () {
            viewModel.setIsTextFieldFocusd(isTextFieldFocused: true);
          },
          onFieldSubmitted: (value) {
            viewModel.setIsTextFieldFocusd(isTextFieldFocused: false);
          },
          controller: viewModel.controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide:
                    BorderSide(color: const Color(0xFFD2D8F8), width: 2.5.w)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide:
                    BorderSide(color: const Color(0xFFD2D8F8), width: 2.5.w)),
          ),
        ),
        if (!viewModel.isTextFieldFocused && viewModel.controller.text.isEmpty)
          Positioned(
            top: 13.h,
            left: 18.w,
            child: Text(
              "인증 번호",
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF8D8D8D)),
            ),
          ),
        Positioned(
          top: 12.h,
          right: 15.w,
          child: Text(
            viewModel.formattedRemainingTime,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _resendCode(BuildContext context) {
    final viewModel = Provider.of<SignUpVerificationViewModel>(context);
    return Row(
      children: [
        GestureDetector(
          onTap: viewModel.resendCode,
          child: Text(
            viewModel.canResendCode ? '인증번호 재전송' : '인증번호가 재전송되었습니다',
            style: TextStyle(
              fontSize: 13,
              decoration: viewModel.canResendCode
                  ? TextDecoration.underline
                  : TextDecoration.none,
              color: viewModel.canResendCode ? Colors.grey : Colors.grey,
            ),
          ),
        ),
        if (!viewModel.canResendCode) ...[
          const SizedBox(width: 8.0),
          Text(
            viewModel.formattedRemainingTime,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _main(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32.0.w),
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
            child: _verificationCodeInputField(context),
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 38.0.w),
          child: _resendCode(context),
        ),
      ],
    );
  }

  // bottom
  Widget _confirmButton(BuildContext context) {
    final viewModel = Provider.of<SignUpVerificationViewModel>(context);
    return GestureDetector(
      onTap: () {
        viewModel.setVerificationCode();
        if (viewModel.isVerificationCodeCorrect()) {
          context.push('/signUpDetail');
        } else {
          viewModel.setShowErrorMessage(true);
          viewModel.controller.clear();
        }
      },
      child: Container(
        width: double.infinity,
        height: 60.h,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: const Color(0xFFE6E6E6),
          shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.r,
                color: const Color(0xFFE6E6E6),
              ),
              borderRadius: BorderRadius.circular(19.r)),
        ),
        child: Text(
          "인증번호 확인",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            // fontFamily: '',
          ),
        ),
      ),
    );
  }

  Widget _bottom(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: _confirmButton(context));
  }
}
