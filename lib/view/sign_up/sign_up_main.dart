import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/view_model/sign_up/sign_up_view_model.dart';
import 'package:provider/provider.dart';

class SignUpMain extends StatelessWidget {
  const SignUpMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('회원가입'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                const Text(
                  '인증번호를 입력해주세요',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                _VerificationCodeInputField(),
                const SizedBox(height: 12.0),
                _ResendCodeButton(),
                const SizedBox(height: 20.0),
                _ConfirmButton(),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerificationCodeInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpViewModel>(context);
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            // 입력이 6자리인 경우 버튼 색 변경
            viewModel.setCode(value);
          },
          decoration: const InputDecoration(
            labelText: '인증번호',
            border: OutlineInputBorder(),
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: Text(
            viewModel.formattedRemainingTime,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _ResendCodeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpViewModel>(context);
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
            viewModel.formattedRemainingTime,
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
    final viewModel = Provider.of<SignUpViewModel>(context);
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: viewModel.isCodeValid ? () {} : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              foregroundColor: Colors.black,
              backgroundColor:
                  viewModel.isCodeValid ? Colors.green : Colors.grey[300],
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
