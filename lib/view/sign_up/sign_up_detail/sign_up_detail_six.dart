import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/loginFunc.dart';
import 'package:meet_up/model/policy_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/view_model/login/login_phone_num_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_phone_num_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

Widget SignUpDetailSix(BuildContext context) {
  final signUpDetailViewModel = Provider.of<SignUpDetailViewModel>(context);
  final signUpPhoneNumViewModel = Provider.of<SignUpPhoneNumViewModel>(
    context,
    listen: false,
  );
  final loginPhoneNumViewModel = Provider.of<LoginPhoneNumViewModel>(
    context,
    listen: false,
  );
  final userViewModel = Provider.of<UserViewModel>(
    context,
    listen: false,
  );

  return Container(
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white),
    height: 495.h,
    width: MediaQuery.of(context).size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 23.h,
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFCDCDCD),
              borderRadius: BorderRadius.all(
                Radius.circular(18.28.r),
              ),
            ),
            height: 3.35.h,
            width: 40.22.w,
          ),
        ),
        SizedBox(
          height: 26.55.h,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 32.h,
            right: 32.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 250.w,
                child: Text("밋업 사용을 위해\n필수 항목에 동의해주세요!",
                    style: AppTextStyles.PR_B_18.copyWith(color: Colors.black)),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  signUpDetailViewModel.toggleAllAccpetPlicies();
                },
                icon: Icon(
                  Icons.check_box,
                  size: 26.82.h,
                  color: UsedColor.grey1,
                ),
                selectedIcon: Icon(
                  Icons.check_box,
                  size: 26.82.h,
                  color: UsedColor.violet,
                ),
                isSelected: signUpDetailViewModel.acceptedPolicies[7],
              )
            ],
          ),
        ),
        SizedBox(
          height: 17.12.h,
        ),
        SizedBox(
          height: 228.63.h,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              right: 36.w,
            ),
            itemCount: PolicyModel.policy.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 34.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        debugPrint("개별 약관 동의");
                        signUpDetailViewModel.toggleAcceptPolicies(
                            index: index);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32.w,
                          ),
                          Icon(
                            Icons.check,
                            color: signUpDetailViewModel.acceptedPolicies[index]
                                ? UsedColor.violet
                                : UsedColor.text_5,
                            size: 20.w,
                          ),
                          SizedBox(
                            width: 17.47.w,
                          ),
                          Text(PolicyModel.policy[index + 1]!,
                              style: AppTextStyles.PR_R_16.copyWith(
                                  color: signUpDetailViewModel
                                          .acceptedPolicies[index]
                                      ? UsedColor.text_1
                                      : UsedColor.text_5)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        debugPrint("약관 내용 표시");
                      },
                      child: Icon(
                        Icons.chevron_right,
                        size: 20.h,
                        color: signUpDetailViewModel.acceptedPolicies[index]
                            ? Colors.black
                            : UsedColor.text_5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 34.12.h,
        ),
        Center(
          child: GestureDetector(
            onTap: () async {
              if (signUpDetailViewModel.isAcceptionValid) {
                // DB에 User 정보 전달하고 User data 넘기기
                debugPrint("동의하고 시작하기");

                // 회원가입으로 넘어온 경우
                if (signUpPhoneNumViewModel.uid != "") {
                  await signUpDetailViewModel.updateNewUser(
                      uid: signUpPhoneNumViewModel.uid);
                  // Firebase secure storage에 uid 값 저장
                  await userViewModel.login(uid: signUpPhoneNumViewModel.uid);

                  if (LoginFunc.isLogined) {
                    while (context.canPop()) {
                      context.pop();
                    }
                    // 유저 모델 불러오기
                    await userViewModel.loadUserModel();
                  }
                }
                // 로그인으로 넘어온 경우
                else {
                  await signUpDetailViewModel.updateNewUser(
                      uid: loginPhoneNumViewModel.uid);
                  // Firebase secure storage에 uid 값 저장
                  await userViewModel.login(uid: loginPhoneNumViewModel.uid);

                  if (LoginFunc.isLogined) {
                    while (context.canPop()) {
                      context.pop();
                    }
                    // 유저 모델 불러오기
                    await userViewModel.loadUserModel();
                  }
                }
              } else {
                debugPrint("필수 항목이 체크되지 않아 시작 불가");
              }
            },
            child: Container(
              width: 327.w,
              height: 56.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: signUpDetailViewModel.isAcceptionValid
                    ? UsedColor.button
                    : UsedColor.grey1,
                borderRadius: BorderRadiusDirectional.circular(16.r),
              ),
              child: Text("동의하고 시작하기",
                  style: AppTextStyles.PR_SB_20.copyWith(
                    color: signUpDetailViewModel.isAcceptionValid
                        ? Colors.white
                        : UsedColor.text_2,
                  )),
            ),
          ),
        ),
      ],
    ),
  );
}
