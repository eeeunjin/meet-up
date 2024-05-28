import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/profile/profile_view_model.dart';
import 'package:provider/provider.dart';

class Withdrawal extends StatelessWidget {
  const Withdrawal({super.key});

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
            '탈퇴 사유를 알려주시면\n개선을 위해 노력하겠습니다.',
            style: AppTextStyles.PR_SB_18
                .copyWith(color: UsedColor.charcoal_black),
          ),
        ),
        SizedBox(height: 28.h),
        Padding(
          padding: EdgeInsets.only(left: 32.0.w),
          child: Text(
            '복수 선택 가능',
            style: AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
          ),
        ),
        SizedBox(height: 16.h),
        _withdrawalCheckList(context),
        // 선택 리스트
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(left: 33.0.w, right: 32.w, bottom: 56.h),
          child: _nextbutton(context),
        ),
      ],
    );
  }

  Widget _nextbutton(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    final bool isAnyChecked = viewModel.selectedReasons.isNotEmpty;

    return NextButton(
      onTap: () {},
      height: 56.h,
      text: '다음',
      enable: isAnyChecked,
      textStyle: AppTextStyles.PR_SB_20.copyWith(color: Colors.white),
      backgroundColor: isAnyChecked ? UsedColor.button : UsedColor.text_5,
    );
  }

  //MARK: - 체크 리스트
  Widget _withdrawalCheckList(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    final options = [
      '이용자 수가 적어 만남 인원이 모이지 않음',
      '불친절하고 이상한 유저들이 존재함',
      '만남 프로세스가 복잡함',
      '성찰 서비스가 불편함',
      '만남이 성찰에 크게 도움이 되지 않음',
      '기타',
    ];

    return Padding(
      padding: EdgeInsets.only(left: 32.w),
      child: Column(
        children: options.map((option) {
          bool isSelected = viewModel.selectedReasons.contains(option);
          return Padding(
            padding: EdgeInsets.only(bottom: 11.0.h),
            child: GestureDetector(
              onTap: () {
                viewModel.toggleReason(option);
              },
              child: Row(
                children: [
                  Image.asset(
                    isSelected ? ImagePath.checkBoxOn : ImagePath.checkBoxOff,
                    width: 24.w,
                    height: 24.h,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    option,
                    style: AppTextStyles.PR_M_14.copyWith(
                        color: isSelected
                            ? UsedColor.charcoal_black
                            : UsedColor.text_3),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
