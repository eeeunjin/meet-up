import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/sign_up/sign_up_detail/sign_up_detail_six.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:provider/provider.dart';

class SignUpDetailFive extends StatelessWidget {
  const SignUpDetailFive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 58.h,
            ),
            child: _header(context),
          ),
          SizedBox(height: 17.h),
          _progressBar(),
          _main(context),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(left: 32.w, right: 33.w, bottom: 56.h),
            child: _bottom(context),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return header(back: _back(context), title: "프로필 입력");
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

  Widget _progressBar() {
    return Column(
      children: [
        Image.asset(ImagePath.signUpProgressBar_5,
            width: 393.w, fit: BoxFit.cover),
        SizedBox(height: 17.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '5',
              style: TextStyle(
                  color: const Color(0xFF170F64),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.0.h),
              child: Text(
                '/5',
                style: TextStyle(fontSize: 14.sp),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _main(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48.h,
        ),
        _purpose(context),
      ],
    );
  }

  Widget _bottom(BuildContext context) {
    return Consumer<SignUpDetailViewModel>(
        builder: (context, viewModel, child) {
      return NextButton(
        onTap: () async {
          if (!viewModel.isSectionsCompletedPageFive) return;
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SignUpDetailSix(context);
            },
          );
        },
        text: '다음',
        height: 56.h,
        fontSize: 20.sp,
        enable: viewModel.isSectionsCompletedPageFive,
        backgroundColor: viewModel.isSectionsCompletedPageFive
            ? UsedColor.button
            : UsedColor.grey1,
        textStyle: TextStyle(
          color: viewModel.isSectionsCompletedPageFive
              ? Colors.white
              : Colors.black,
          fontSize: 18.sp,
        ),
      );
    });
  }

  Widget _purpose(BuildContext context) {
    final viewModel = Provider.of<SignUpDetailViewModel>(context, listen: true);
    List<String> options = [
      "친목",
      "자기성찰",
      "기록",
      "취미 공유",
      "자기계발",
      "새로운 경험",
      "독서 모임",
      "여럿이 운동",
      "취업 스터디",
      "맛집 탐방",
      "기타",
    ];

    return Padding(
      padding: EdgeInsets.only(left: 25.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "만남 목적을 선택해주세요.",
            style: AppTextStyles.PR_B_22.copyWith(color: Colors.black),
          ),
          SizedBox(height: 8.h),
          Text(
            "1~3가지를 선택해주세요.",
            style: AppTextStyles.SU_R_12.copyWith(color: UsedColor.text_4),
          ),
          SizedBox(height: 24.h),
          // 12개 중 3개 선택
          Wrap(
            spacing: 7.w,
            runSpacing: 7.h,
            children: options.map((option) {
              bool isSelected =
                  viewModel.selectedPurposeKeywords.contains(option);
              return GestureDetector(
                onTap: () {
                  viewModel.selectPurposeKeyword(option);
                },
                child: Container(
                  width: 110.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: isSelected ? UsedColor.button : Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isSelected ? UsedColor.button : UsedColor.b_line,
                      width: 2.5.w,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: AppTextStyles.PR_SB_15.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
