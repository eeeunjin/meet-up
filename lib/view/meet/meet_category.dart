import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:provider/provider.dart';

class MeetCategory extends StatelessWidget {
  const MeetCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Column(
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
              SizedBox(height: 33.h),
              Expanded(child: _mainCategory(context)),
              Align(alignment: Alignment.bottomCenter, child: _bottom(context)),
            ],
          ),
        ],
      )),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '카테고리 선택'),
          SizedBox(
            height: 11.h,
          ),
          _divider(),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 정보 초기화
        final viewModel =
            Provider.of<MeetCreateViewModel>(context, listen: false);
        viewModel.categoryClearSelection();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  // 구분선
  Widget _divider() {
    return Divider(
      height: 0.3.h,
      color: UsedColor.line,
    );
  }

  Widget _mainCategory(BuildContext context) {
    final viewModel = Provider.of<MeetCreateViewModel>(context, listen: true);
    List<String> options = ['취미', '운동', '공부/학업', '휴식/친목', '기타'];

    // 메인 카테고리
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 33.w),
          child: Column(
            children: [
              Row(
                children: [
                  // 파란 동그라미
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: UsedColor.main),
                  ),
                  SizedBox(width: 14.46.w),
                  Text(
                    '카테고리',
                    style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 20.64.h),
              Padding(
                padding: EdgeInsets.only(right: 40.0.w),
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: options.map((option) {
                    bool isSelected =
                        viewModel.selectedMainCategories.contains(option);
                    return GestureDetector(
                      onTap: () {
                        viewModel.selectMainCategory(option);
                      },
                      child: Container(
                        width: 99.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: isSelected ? UsedColor.button : Colors.white,
                          borderRadius: BorderRadius.circular(12.61.r),
                          border: Border.all(
                            color: isSelected
                                ? UsedColor.button
                                : UsedColor.b_line,
                            width: 2.25.w,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: AppTextStyles.PR_SB_14.copyWith(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 33.h),
        _divider(),
        SizedBox(height: 33.h),
        // 상세 카테고리
        Padding(
          padding: EdgeInsets.only(left: 33.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 파란 동그라미
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: UsedColor.main),
                  ),
                  SizedBox(width: 14.46.w),
                  Text(
                    '상세 카테고리',
                    style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
                  ),
                ],
              ),
              if (viewModel.selectedMainCategories.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 7.0.h, left: 14.76.w),
                  child: Text(
                    '상위 카테고리를 먼저 선택해주세요.',
                    style:
                        AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
                  ),
                )
              else
                // 선택된 각 메인 카테고리에 대해 상세 카테고리 리스트를 표시
                ...viewModel.selectedMainCategories.map(
                  (mainCategory) => Padding(
                    padding: EdgeInsets.only(top: 8.0.h),
                    child: _subCategoryList(context, mainCategory),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _subCategoryList(BuildContext context, String mainCategory) {
    final viewModel = Provider.of<MeetCreateViewModel>(context, listen: true);
    if (mainCategory == '기타') {
      return Padding(
        padding: EdgeInsets.only(top: 8.0.h),
        child: Padding(
          padding: EdgeInsets.only(top: 7.0.h, left: 14.76.w),
          child: Text(
            '상위 카테고리를 먼저 선택해주세요.',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
          ),
        ), // This will be your message.
      );
    }
    List<String> subCategories = viewModel.getSubCategories(mainCategory);

    return Column(
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: subCategories.map((subCategory) {
            bool isSubSelected = viewModel.isSubCategorySelected(subCategory);
            return GestureDetector(
              onTap: () {
                viewModel.selectSubCategory(subCategory);
              },
              child: Container(
                width: 99.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: isSubSelected ? UsedColor.button : Colors.white,
                  borderRadius: BorderRadius.circular(12.61.r),
                  border: Border.all(
                    color: isSubSelected ? UsedColor.button : UsedColor.b_line,
                    width: 2.25.w,
                  ),
                ),
                child: Center(
                  child: Text(
                    subCategory,
                    style: AppTextStyles.PR_SB_14.copyWith(
                      color: isSubSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 28.h),
      ],
    );
  }

  Widget _bottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 33.w, bottom: 56.h),
      child:
          Consumer<MeetCreateViewModel>(builder: (context, viewModel, child) {
        return NextButton(
          onTap: () async {
            if (viewModel.isCategorySelectionComplete) {
              Navigator.of(context).pop();
            } else {
              return;
            }
          },
          height: 56.h,
          text: viewModel.isCategorySelectionComplete ? '저장' : '저장 안됨',
          enable: viewModel.isCategorySelectionComplete,
          backgroundColor: viewModel.isCategorySelectionComplete
              ? UsedColor.button
              : UsedColor.button_g,
          textStyle: TextStyle(
            color: viewModel.isCategorySelectionComplete
                ? Colors.white
                : UsedColor.text_2,
          ),
        );
      }),
    );
  }
}
