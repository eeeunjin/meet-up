import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/loginFunc.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view_model/login/login_phone_num_view_model.dart';
import 'package:meet_up/view_model/login/login_verification_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class LoginVerification extends StatelessWidget {
  const LoginVerification({super.key});

  // build
  @override
  Widget build(BuildContext context) {
    // 키패드 올라왔을 때
    final double keyboardOpen = MediaQuery.of(context).viewInsets.bottom;
    // 키보드 올라왔으면 패딩 30, 내려갔으면 80
    final double bottomPadding = keyboardOpen > 0 ? 30.0 : 80.0.h;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 58.h,
              ),
              child: _header(context),
            ),
            SizedBox(
              height: 73.h,
            ),
            _main(context),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: _bottom(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return header(
      back: null,
      title: "로그인",
    );
  }

  // main
  Widget _verificationCodeInputField(BuildContext context) {
    final viewModel = Provider.of<LoginVerificationViewModel>(context);
    return Stack(
      children: [
        TextFormField(
          cursorHeight: 24.0.h,
          onChanged: (value) {
            bool shouldFieldBeFocused =
                value.isNotEmpty || viewModel.isTextFieldFocused;
            if (viewModel.isTextFieldFocused != shouldFieldBeFocused) {
              viewModel.setIsTextFieldFocusd(
                  isTextFieldFocused: shouldFieldBeFocused);
            }
            // 6자가 되면 유효성 bool 변수 true로 만들기
            if (value.length == 6) {
              viewModel.setTextFieldHasSixWord(textFieldHasSixWord: true);
            } else {
              viewModel.setTextFieldHasSixWord(textFieldHasSixWord: false);
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
                borderSide: BorderSide(color: UsedColor.b_line, width: 2.5.w)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: UsedColor.b_line, width: 2.5.w)),
            contentPadding:
                EdgeInsets.only(top: 15.h, bottom: 15.h, left: 21.h),
          ),
          style: AppTextStyles.PR_SB_26.copyWith(
            color: UsedColor.charcoal_black,
            height: 1.3.h,
          ),
        ),
        if (!viewModel.isTextFieldFocused && viewModel.controller.text.isEmpty)
          Positioned(
            top: 13.h,
            left: 18.w,
            child: Text("인증 번호",
                style: AppTextStyles.SU_L_12.copyWith(color: UsedColor.text_4)),
          ),
        Positioned(
          top: 13.h,
          right: 15.w,
          child: Text(viewModel.formattedRemainingTime,
              style: AppTextStyles.PR_SB_12.copyWith(color: UsedColor.text_3)),
        ),
      ],
    );
  }

  Widget _resendCode(BuildContext context) {
    final loginVerificationViewModel =
        Provider.of<LoginVerificationViewModel>(context);
    final loginPhoneNumViewModel = Provider.of<LoginPhoneNumViewModel>(context);
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (loginVerificationViewModel.remainingTime <= 0) {
              loginVerificationViewModel.resendCode();
              loginPhoneNumViewModel.resendCode(context);
            } else {
              showAlert(null,
                  context: context,
                  title: "재전송 제한",
                  message: "3분이 지난 후에 재전송이 가능합니다.");
              return;
            }
          },
          child: Text(
            loginVerificationViewModel.canResendCode
                ? '인증번호 재전송'
                : '인증번호가 재전송되었습니다',
            style: AppTextStyles.SU_L_12.copyWith(
              decoration: loginVerificationViewModel.canResendCode
                  ? TextDecoration.underline
                  : TextDecoration.none,
              color: UsedColor.text_4,
            ),
          ),
        ),
        if (!loginVerificationViewModel.canResendCode) ...[
          SizedBox(width: 8.0.w),
          Text(
            loginVerificationViewModel.formattedRemainingTime,
            style: AppTextStyles.PR_SB_10.copyWith(color: UsedColor.text_4),
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
            style: AppTextStyles.PR_SB_24,
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
    Function()? onTap, {
    required BuildContext context,
    required String title,
    required String message,
  }) {
    if (onTap == null) {
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
                  style:
                      TextStyle(fontSize: 17.5.sp, fontFamily: "Pretendard-M"),
                ),
                content: Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(message, style: AppTextStyles.PR_R_12),
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
                    },
                  )
                ],
              ),
            ],
          );
        },
      );
    } else {
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
                      onPressed: onTap,
                      child: const Text(
                        "확인",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      )),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text(
                      "취소",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Widget _confirmButton(BuildContext context) {
    final phoneNumViewModel = Provider.of<LoginPhoneNumViewModel>(context);
    final verificationViewModel =
        Provider.of<LoginVerificationViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        if (!verificationViewModel.textFieldHasSixWord) {
          return;
        }

        // 시간이 만료된 경우
        if (verificationViewModel.remainingTime == 0) {
          // 인증 만료 alert 띄우기
          showAlert(
            null,
            context: context,
            title: "인증 시간 만료",
            message: "인증 번호를 재전송 해주세요",
          );
          return;
        }

        try {
          // smsCode가 동일한 경우 다음 화면으로 넘어감
          UserCredential credential = await phoneNumViewModel
              .signInWithSmsCode(verificationViewModel.controller.text);
          // DB에 유저 정보를 저장 (UID + 휴대전화 번호)
          if (credential.user != null) {
            if (credential.additionalUserInfo!.isNewUser) {
              if (context.mounted) {
                showAlert(
                  () async {
                    // 유저 정보 생성
                    await phoneNumViewModel.createUserDocument(
                        uid: credential.user!.uid);
                    if (context.mounted) {
                      context.goNamed('signUpDetailOne');
                    }
                  },
                  context: context,
                  title: "가입된 회원 정보가 없습니다.",
                  message: "회원가입 하시겠습니까?",
                );
              }
            } else {
              // uid 저장
              phoneNumViewModel.uid = credential.user!.uid;
              debugPrint(phoneNumViewModel.uid);

              // 기존 유저의 정보 불러오기
              await phoneNumViewModel.readUserDocument(
                  uid: phoneNumViewModel.uid);

              // 기본 프로필 정보가 전부 있는 경우
              if (phoneNumViewModel.userInfo.gender != "") {
                // Firebase secure storage에 uid 값 저장
                await userViewModel.login(uid: phoneNumViewModel.uid);

                if (LoginFunc.isLogined) {
                  while (context.canPop()) {
                    context.pop();
                  }
                  // 유저 모델 불러오기
                  await userViewModel.loadUserModel();
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              }
              // 전화 번호만 있는 경우
              else {
                if (context.mounted) {
                  showAlert(
                    () async {
                      // 유저 정보 생성
                      await phoneNumViewModel.createUserDocument(
                          uid: credential.user!.uid);
                      if (context.mounted) {
                        context.goNamed('signUpDetailOne');
                      }
                    },
                    context: context,
                    title: "가입된 회원 정보가 없습니다.",
                    message: "회원가입 하시겠습니까?",
                  );
                }
              }
            }
          } else {
            debugPrint("유저 정보 생성 중 오류 발생");
          }
        } catch (e) {
          // smsCode가 동일하지 않은 경우 alert 출력
          logger.e("Error message : $e \n Error type: ${e.runtimeType}");
          if (e.runtimeType == FirebaseAuthException) {
            if (context.mounted) {
              showAlert(
                null,
                context: context,
                title: "인증번호가 일치하지 않습니다.",
                message: "인증번호를 다시 입력해 주십시오.",
              );
            }
          } else {
            if (context.mounted) {
              UserCredential credential = await phoneNumViewModel
                  .signInWithSmsCode(verificationViewModel.controller.text);
              showAlert(
                () async {
                  // 유저 정보 생성
                  await phoneNumViewModel.createUserDocument(
                      uid: credential.user!.uid);
                  if (context.mounted) {
                    context.goNamed('signUpDetailOne');
                  }
                },
                context: context,
                title: "가입된 회원 정보가 없습니다.",
                message: "회원가입 하시겠습니까?",
              );
            }
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 60.h,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: verificationViewModel.textFieldHasSixWord
              ? UsedColor.button
              : UsedColor.grey1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19.r),
          ),
        ),
        child: Text(
          "인증번호 확인",
          style: AppTextStyles.PR_SB_20.copyWith(
            color: verificationViewModel.textFieldHasSixWord
                ? Colors.white
                : UsedColor.text_2,
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
