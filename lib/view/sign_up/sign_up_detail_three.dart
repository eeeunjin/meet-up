import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:provider/provider.dart';

class SignUpDetailThree extends StatelessWidget {
  const SignUpDetailThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Platform.isIOS)
              _header(context)
            else if (Platform.isAndroid)
              Padding(
                padding: EdgeInsets.only(
                  top: 15.h,
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
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  Widget _progressBar() {
    return Column(
      children: [
        Image.asset(ImagePath.signUpProgressBar_3),
        SizedBox(height: 17.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '3',
              style: TextStyle(
                  color: const Color(0xFF170F64),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1.0.h),
              child: const Text('/5'),
            )
          ],
        )
      ],
    );
  }

  Widget _main(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 48.h),
        _relationship(context),
        SizedBox(height: 55.h),
        _lifestyle(context),
      ],
    );
  }

  Widget _relationship(BuildContext context) {
    final viewModel = Provider.of<SignUpDetailViewModel>(context, listen: true);
    List<String> options = ["사교적인", "소극적인", "유머러스한", "조용한", "친절한", "자신감 있는"];

    return Padding(
      padding: EdgeInsets.only(left: 25.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "대인관계 속 성격을 선택해주세요.",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            "나를 가장 잘 표현하는 키워드 3가지를 선택해주세요.",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF868686)),
          ),
          SizedBox(height: 24.h),
          // 6개 중 3개 선택
          Wrap(
            spacing: 7.w,
            runSpacing: 7.h,
            children: options.map((option) {
              bool isSelected =
                  viewModel.selectedRelationshipKeywords.contains(option);
              return GestureDetector(
                onTap: () {
                  viewModel.selectRelationshipKeyword(option);
                },
                child: Container(
                  width: 110.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF7C4DFF) : Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF7C4DFF)
                          : const Color(0xFFD2D8F8),
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

  Widget _lifestyle(BuildContext context) {
    final viewModel = Provider.of<SignUpDetailViewModel>(context, listen: true);
    List<String> options = ["계획적인", "즉흥적인", "창의적인", "안정적인", "낙관적인", "열정적인"];

    return Padding(
      padding: EdgeInsets.only(left: 25.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "스스로의 삶 속 성격을 선택해주세요.",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            "나를 가장 잘 표현하는 키워드 3가지를 선택해주세요.",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF868686)),
          ),
          SizedBox(height: 24.h),
          // 6개 중 3개 선택
          Wrap(
            spacing: 7.w,
            runSpacing: 7.h,
            children: options.map((option) {
              bool isSelected =
                  viewModel.selectedLifestyleKeywords.contains(option);
              return GestureDetector(
                onTap: () {
                  viewModel.selectLifestyleKeyword(option);
                },
                child: Container(
                  width: 110.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF7C4DFF) : Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF7C4DFF)
                          : const Color(0xFFD2D8F8),
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

  Widget _bottom(BuildContext context) {
    return Consumer<SignUpDetailViewModel>(
        builder: (context, viewModel, child) {
      return NextButton(
        onTap: () async {
          if (!viewModel.areBothSectionsCompleted) return;
          context.goNamed('signUpDetailfour');
        },
        text: '다음',
        height: 56.h,
        fontSize: 20.sp,
        enable: viewModel.areBothSectionsCompleted,
        backgroundColor: viewModel.areBothSectionsCompleted
            ? UsedColor.green
            : const Color(0xFFE6E6E6),
        textStyle: TextStyle(
          color:
              viewModel.areBothSectionsCompleted ? Colors.white : Colors.black,
          fontSize: 18.sp,
        ),
      );
    });
  }
}
