import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/profile/profile_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class WithdrawalNext extends StatelessWidget {
  const WithdrawalNext({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 58.h,
            ),
            child: _header(context),
          ),
          Expanded(child: _main(context)),
        ],
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '탈퇴'),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            thickness: 0.3.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  Widget _main(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.only(left: 32.0.w),
          child: Text(
            '계정 탈퇴 시',
            style: AppTextStyles.PR_SB_18
                .copyWith(color: UsedColor.charcoal_black),
          ),
        ),
        SizedBox(height: 38.h),
        Padding(
          padding: EdgeInsets.only(left: 32.0.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4.0.h, right: 8.w),
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UsedColor.main,
                  ),
                ),
              ),
              Text(
                '회원이 생성한 계정과 관련된 모든 정보가 삭제됩니다.',
                style: AppTextStyles.PR_M_14.copyWith(color: UsedColor.text_3),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.only(left: 32.0.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4.0.h, right: 8.w),
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UsedColor.main,
                  ),
                ),
              ),
              Text(
                '탈퇴 시, 3일 동안 재가입이 불가합니다.',
                style: AppTextStyles.PR_M_14.copyWith(color: UsedColor.text_3),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.only(left: 32.0.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4.0.h, right: 8.w),
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UsedColor.main,
                  ),
                ),
              ),
              Text(
                '영구 정지로 인한 탈퇴 시, 영구히 재가입이 불가합니다.',
                style: AppTextStyles.PR_M_14.copyWith(color: UsedColor.text_3),
              ),
            ],
          ),
        ),
        const Spacer(),
        _check(context),
        Padding(
          padding: EdgeInsets.only(
              left: 33.0.w, right: 32.w, bottom: 56.h, top: 56.h),
          child: _nextbutton(context),
        ),
      ],
    );
  }

  // MARK: - 탈퇴하기
  Widget _nextbutton(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return NextButton(
      onTap: () async {
        // 탈퇴 로직
        await userViewModel.deleteUser();

        // 탈퇴 로직 & withdrawalDialog 띄우기
        withdrawalDialog(context, userViewModel);
      },
      height: 56.h,
      text: '탈퇴하기',
      enable: viewModel.isConfirmButtonPressed,
      textStyle: AppTextStyles.PR_SB_20.copyWith(color: Colors.white),
      backgroundColor: viewModel.isConfirmButtonPressed
          ? UsedColor.charcoal_black
          : UsedColor.text_5,
    );
  }

  Widget _check(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(left: 100.0.w),
      child: GestureDetector(
        onTap: () {
          viewModel.pressConfirmButton();
        },
        child: Row(
          children: [
            viewModel.isConfirmButtonPressed
                ? Image.asset(
                    ImagePath.checkBoxOn,
                    width: 24.w,
                    height: 24.h,
                  )
                : Image.asset(
                    ImagePath.checkBoxOff,
                    width: 24.w,
                    height: 24.h,
                  ),
            SizedBox(width: 20.w),
            Text('계정을 탈퇴하겠습니다.',
                style: AppTextStyles.PR_R_16.copyWith(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  // MARK: - 탈퇴 확인 다이얼로그
  void withdrawalDialog(BuildContext context, UserViewModel userViewModel) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // 외부 선택 시 닫기
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5), // 외부 색상
      transitionDuration:
          const Duration(milliseconds: 200), // 사라질 때 애니메이션 지속 시간
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            width: 245.w,
            height: 104.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0.h),
                  child: Text(
                    '탈퇴가 완료되었습니다.',
                    style: AppTextStyles.PR_M_13.copyWith(
                      color: UsedColor.charcoal_black,
                      decoration: TextDecoration.none, // 밑줄 제거
                    ),
                  ),
                ),
                Container(
                  height: 0.3.h,
                  width: 245.w,
                  color: UsedColor.b_line,
                ),
                Expanded(
                  child: SizedBox(
                    height: 35.h,
                    child: TextButton(
                      style: const ButtonStyle(
                          overlayColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        // 로그인 페이지로 이동
                        while (context.canPop()) {
                          context.pop();
                        }
                        userViewModel.logout();
                      },
                      child: Text(
                        '확인',
                        style: AppTextStyles.PR_M_14
                            .copyWith(color: UsedColor.charcoal_black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
