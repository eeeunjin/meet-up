import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/sign_up/sign_up_phone_num_view_model.dart';
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
            if (Platform.isIOS)
              _header(context)
            else if (Platform.isAndroid)
              Padding(
                padding: EdgeInsets.only(
                  top: 15.h,
                ),
                child: _header(context),
              ),
            SizedBox(
              height: 73.h,
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
    final viewModel =
        Provider.of<SignUpVerificationViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        context.pop();
        viewModel.resetState();
      }, // 뒤로가기
      child: Image.asset(
        ImagePath.back,
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 가로로 가운데 정렬
      children: [
        _back(context),
        Expanded(
          child: Center(
            child: Text(
              "회원가입",
              style: TextStyle(fontSize: 20.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(width: 48.w), // 여백 조절
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
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
          ],
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
          onTap: () {
            if (viewModel.remainingTime <= 0) {
              viewModel.resendCode();
            } else {
              showAlert(
                  context: context,
                  title: "재전송 제한",
                  message: "3분이 지난 후에 재전송이 가능합니다.");
              return;
            }
          },
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
  void showAlert(
      {required BuildContext context,
      required String title,
      required String message}) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.46),
            ),
            CupertinoAlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              actions: [
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text(
                      "확인",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _confirmButton(BuildContext context) {
    final phoneNumviewModel = Provider.of<SignUpPhoneNumViewModel>(context);
    final verificationViewModel =
        Provider.of<SignUpVerificationViewModel>(context);
    return GestureDetector(
      onTap: () async {
        // 시간이 만료된 경우
        if (verificationViewModel.remainingTime == 0) {
          // 인증 만료 alert 띄우기
          showAlert(
            context: context,
            title: "인증 시간 만료",
            message: "인증 번호를 재전송 해주세요",
          );
          return;
        }

        try {
          // smsCode가 동일한 경우 다음 화면으로 넘어감
          await phoneNumviewModel
              .signInWithSmsCode(verificationViewModel.controller.text);
          context.goNamed('signUpDetail');
        } catch (e) {
          // smsCode가 동일하지 않은 경우 alert 출력
          showAlert(
            context: context,
            title: "인증번호가 일치하지 않습니다.",
            message: "인증번호를 다시 입력해 주십시오.",
          );
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
