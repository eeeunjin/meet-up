import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/sign_up/sign_up_view_model.dart';
import 'package:provider/provider.dart';

class SignUpPhone extends StatefulWidget {
  const SignUpPhone({Key? key}) : super(key: key);

  @override
  _SignUpPhoneState createState() => _SignUpPhoneState();
}

class _SignUpPhoneState extends State<SignUpPhone> {
  bool _isTextFieldFocused = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(child: _body(context)),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final double keyboardOpen = MediaQuery.of(context).viewInsets.bottom;
    final double bottomPadding = keyboardOpen > 0 ? 30.0 : 80.0.h;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24.h, left: 9.w),
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
    );
  }

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
          '회원가입',
          style: TextStyle(fontSize: 22.sp),
        ),
      ],
    );
  }

  Widget _main(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 28.0.w),
              child: Text(
                '휴대폰 번호를 입력해주세요',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
              ),
            ),
            SizedBox(height: 32.h),
            Consumer<SignUpViewModel>(
              builder: (context, viewModel, child) => Center(
                child: SizedBox(
                  width: 339.w,
                  height: 74.h,
                  child: Stack(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          bool shouldFieldBeFocused =
                              value.isNotEmpty || _isTextFieldFocused;
                          if (_isTextFieldFocused != shouldFieldBeFocused) {
                            setState(() {
                              _isTextFieldFocused = shouldFieldBeFocused;
                            });
                          }
                          viewModel.checkPhoneNumber(value);
                        },
                        onTap: () {
                          setState(() {
                            _isTextFieldFocused = true;
                          });
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            _isTextFieldFocused = false;
                          });
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
                                  width: 2.5.w)),
                          hintText: _isTextFieldFocused ? '' : '휴대폰 번호',
                          hintStyle: TextStyle(
                              fontSize: 12.sp, color: const Color(0xFF8D8D8D)),
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

  Widget _bottom(BuildContext context) {
    return Consumer<SignUpViewModel>(
      builder: (context, viewModel, child) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
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
