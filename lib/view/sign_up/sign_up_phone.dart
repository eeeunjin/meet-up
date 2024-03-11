import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/sign_up/sign_up_view_model.dart';
import 'package:provider/provider.dart';

class SignUpPhone extends StatelessWidget {
  const SignUpPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: _body(context)),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.h, left: 9.w),
          child: _header(context),
        ),
        SizedBox(height: 30.h),
        _main(),
        SizedBox(height: 520.h),
        _bottom(context),
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
        SizedBox(width: 119.w),
        Text(
          '회원가입',
          style: TextStyle(fontSize: 22.sp),
        ),
      ],
    );
  }

  Widget _main() {
    return Column(
      children: [
        Text(
          '휴대폰 번호를 입력해주세요',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
        ),
        Consumer<SignUpViewModel>(
          builder: (context, viewModel, child) => TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(11),
            ],
            decoration: InputDecoration(
              labelText: '휴대폰 번호',
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      viewModel.isPhoneNumberValid ? Colors.green : Colors.red,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (value) {
              viewModel.checkPhoneNumber(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _bottom(BuildContext context) {
    return Consumer<SignUpViewModel>(
      builder: (context, viewModel, child) => Container(
        width: double.infinity,
        height: 60.h,
        decoration: BoxDecoration(
          color: viewModel.isPhoneNumberValid
              ? Colors.green
              : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: NextButton(
          onTap: () {
            if (viewModel.isPhoneNumberValid) {
              context.push('/signUpVerification');
            }
          },
          text: '다음',
          height: 60.h,
          fontSize: 18.sp,
          enable: viewModel.isPhoneNumberValid,
          textStyle: TextStyle(
            color: viewModel.isPhoneNumberValid ? Colors.white : Colors.black,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
