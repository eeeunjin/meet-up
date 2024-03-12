import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/login/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginPhoneNum extends StatefulWidget {
  const LoginPhoneNum({Key? key}) : super(key: key);

  @override
  _LoginPhoneNumState createState() => _LoginPhoneNumState();
}

class _LoginPhoneNumState extends State<LoginPhoneNum> {
  bool _isTextFieldFocused = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        resizeToAvoidBottomInset: true, // 키보드 오버플로우 해결
        body: SafeArea(child: _body(context)),
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
          child: _header(context),
        ),
        SizedBox(
          height: 30.h,
        ),
        _main(),
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
            '휴대폰 번호를 입력해주세요',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
          ),
        ),
        SizedBox(
          height: 32.h,
        ),
        Consumer<LoginViewModel>(
          builder: (context, viewModel, child) => Center(
            child: SizedBox(
              width: 339.w,
              height: 74.h,
              child: Stack(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (!_isTextFieldFocused) {
                          setState(() {
                            _isTextFieldFocused = true;
                          });
                        }
                      } else {
                        if (_isTextFieldFocused) {
                          setState(() {
                            _isTextFieldFocused = false;
                          });
                        }
                      }
                    },
                    onTap: () {
                      if (!_isTextFieldFocused) {
                        setState(() {
                          _isTextFieldFocused = true;
                        });
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        _isTextFieldFocused = true;
                      });
                    },
                    controller: viewModel.controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      // 11자 + 010으로 시작하는지
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                              color: viewModel.controller.text.isNotEmpty
                                  ? (viewModel.isPhoneNumberValid
                                      ? Colors.green
                                      : Colors.red)
                                  : const Color(0xFFD2D8F8),
                              width: 2.5.w)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                              color: viewModel.isPhoneNumberValid
                                  ? Colors.green
                                  : Colors.red,
                              width: 2.5.w)),
                    ),
                  ),
                  if (!_isTextFieldFocused)
                    Positioned(
                      top: 13.h,
                      left: 18.w,
                      child: Text(
                        "휴대폰 번호",
                        style: TextStyle(
                            fontSize: 12.sp, color: const Color(0xFF8D8D8D)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottom(BuildContext context) {
    return Consumer<LoginViewModel>(
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
          textStyle: TextStyle(
            color: viewModel.isPhoneNumberValid ? Colors.white : Colors.black,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
