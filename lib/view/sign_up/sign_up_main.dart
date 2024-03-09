import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/sign_up/sign_up_view_model.dart';

class SignUpMain extends StatelessWidget {
  final VerificationCodeViewModel viewModel = VerificationCodeViewModel();

  SignUpMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // header
        _header(context),
        // 내용
        const SizedBox(height: 20.0),
        const Text(
          '인증번호를 입력해주세요',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20.0),
        _VerificationCodeInputField(viewModel: viewModel),
        const SizedBox(height: 12.0),
        _ResendCodeButton(viewModel: viewModel),
        const SizedBox(height: 20.0),
        _ConfirmButton(),
        const SizedBox(height: 20.0),
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
}

class _VerificationCodeInputField extends StatelessWidget {
  final VerificationCodeViewModel viewModel;

  const _VerificationCodeInputField({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '인증번호',
            border: OutlineInputBorder(),
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: Text(
            viewModel.remainingTime.toString(),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _ResendCodeButton extends StatelessWidget {
  final VerificationCodeViewModel viewModel;

  const _ResendCodeButton({Key? key, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(width: 10.0),
          Text(
            viewModel.remainingTime.toString(),
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ],
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // 인증번호 확인 다음 화면
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              '인증번호 확인',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
