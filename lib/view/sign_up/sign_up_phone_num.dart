import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/sign_up/sign_up_phone_num_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_verification_view_model.dart';
import 'package:provider/provider.dart';

class SignUpPhoneNum extends StatelessWidget {
  const SignUpPhoneNum({super.key});

  // build
  @override
  Widget build(BuildContext context) {
    final double keyboardOpen = MediaQuery.of(context).viewInsets.bottom;
    final double bottomPadding = keyboardOpen > 0 ? 30.0 : 80.0.h;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 58.h,
            ),
            child: _header(context),
          ),
          SizedBox(height: 73.h),
          _main(context),
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: _bottom(context),
          ),
        ],
      ),
    );
  }

  // header
  Widget _back(BuildContext context) {
    final viewModel =
        Provider.of<SignUpPhoneNumViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        viewModel.resetState();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  Widget _header(BuildContext context) {
    return header(
      back: _back(context),
      title: "회원가입",
    );
  }

  // main
  Widget _main(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 32.0.w),
            child: Text(
              '휴대폰 번호를 입력해주세요',
              style: AppTextStyles.PR_SB_24,
            ),
          ),
          SizedBox(height: 32.h),
          Consumer<SignUpPhoneNumViewModel>(
            builder: (context, viewModel, child) => Center(
              child: SizedBox(
                width: 339.w,
                height: 74.h,
                child: Stack(
                  children: [
                    TextFormField(
                      cursorHeight: 24.0.h,
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
                                      ? UsedColor.b_line
                                      : UsedColor.red)
                                  : UsedColor.b_line,
                              width: 2.5.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                              color: viewModel.isPhoneNumberValid
                                  ? UsedColor.b_line
                                  : UsedColor.red,
                              width: 2.5.w),
                        ),
                        contentPadding: EdgeInsets.only(
                          top: 20.h,
                          bottom: 20.h,
                          left: 21.w,
                        ),
                      ),
                      style: AppTextStyles.SU_L_24
                          .copyWith(height: 1.1.h, color: UsedColor.text_2),
                    ),
                    if (!viewModel.isTextFieldFocused &&
                        viewModel.controller.text.isEmpty)
                      Positioned(
                        top: 13.h,
                        left: 18.w,
                        child: Text("휴대폰 번호",
                            style: AppTextStyles.SU_L_12
                                .copyWith(color: UsedColor.text_4)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // bottom
  Widget _bottom(BuildContext context) {
    final signUpVerificationViewModel =
        Provider.of<SignUpVerificationViewModel>(context, listen: false);
    return Consumer<SignUpPhoneNumViewModel>(
      builder: (context, viewModel, child) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: NextButton(
            onTap: () async {
              // phoneNum 유효성 검사 실패 시, return
              if (!viewModel.isPhoneNumberValid) return;

              // Auth 관련 동작 - viewModel에서 진행
              final isSigned = await viewModel.signInWithPhoneNumber(context);

              // 다양한 이유로 코드가 전달되지 않은 경우
              if (!isSigned) {
                debugPrint("코드 전달 실패.");
              } else {
                signUpVerificationViewModel.startTimer();
              }
            },
            text: '다음',
            height: 60.h,
            fontSize: 18.sp,
            enable: viewModel.isPhoneNumberValid,
            backgroundColor: viewModel.isPhoneNumberValid
                ? UsedColor.button
                : UsedColor.grey1,
            textStyle: AppTextStyles.PR_SB_20.copyWith(
              color: viewModel.isPhoneNumberValid ? Colors.white : Colors.black,
            )),
      ),
    );
  }
}
