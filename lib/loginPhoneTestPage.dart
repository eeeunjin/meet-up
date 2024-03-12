import 'package:flutter/material.dart';
import 'package:meet_up/loginPhoneTestPage_view_model.dart';
import 'package:provider/provider.dart';

class LoginPhonePage extends StatelessWidget {
  const LoginPhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase App")),
      body: ChangeNotifierProvider(
        create: (context) => AuthViewModel(),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  // form에 속한 모든 위젯의 유효성 검사를 위한 변수이다.
  // 예를 들어, textField의 유효성 검사(validator)가 false라면 form의 _key 변수도 currentState.validate 가 false가 된다.
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Form(
          key: _key,
          child: Consumer<AuthViewModel>(
            builder: (context, authViewModel, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!authViewModel.codeSent)
                    TextFormField(
                      controller: _phoneController,
                      autofocus: true,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'The input is empty.';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Input your phone number.',
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 15),

                  if (!authViewModel.codeSent)
                    ElevatedButton(
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          await authViewModel.signInWithPhoneNumber(
                              "+82 ${_phoneController.text}");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: const Text(
                          "Send SMS Code",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 15),

                  // 인증 코드가 전송되었음을 확인한 후, smsCode 입력 controller가 보이도록 함
                  authViewModel.codeSent
                      ? TextFormField(
                          controller: _smsCodeController,
                          autofocus: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'The input is empty.';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Input your sms code.',
                            labelText: 'SMS Code',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),

                  const SizedBox(height: 15),

                  // 인증 코드가 전송되었음을 확인한 후, smsCode verify 버튼이 보이도록 함
                  authViewModel.codeSent
                      ? ElevatedButton(
                          onPressed: () async {
                            await authViewModel
                                .signInWithSmsCode(_smsCodeController.text);
                            // 현재 buildContext에서 가장 첫번째 화면을 push 하도록 함
                            // 예상 동작: verify가 성공적으로 된 경우, 원래 페이지가 한번 더 만들어져서 다음 화면으로 push 된다.
                            Navigator.pushNamed(context, "/");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: const Text(
                              "Verify",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
