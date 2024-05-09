import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/meet_browse_view_model.dart';
import 'package:provider/provider.dart';

class MeetFilterMain extends StatelessWidget {
  const MeetFilterMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
            Expanded(child: _main(context)),
            Padding(
              padding: EdgeInsets.only(left: 33.w, right: 32.w, bottom: 27.h),
              child: _bottom(context),
            ),
          ],
        ),
      ),
    );
  }

// header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '필터'),
          SizedBox(
            height: 22.h,
          ),
          _divider(),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    final meetBorwseViewModel =
        Provider.of<MeetBrowseViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 9.h),
      child: GestureDetector(
        onTap: () {
          meetBorwseViewModel.clearAllFilters();
          context.pop();
        },
        child: Image.asset(
          ImagePath.close,
          width: 40.w,
          height: 40.h,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 0.91.h,
      color: const Color(0xffd9d9d9),
    );
  }

  Widget _main(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32.36.h),
            _mainCategory(context),
            _divider(),
            SizedBox(height: 32.91.h),
            _area(context),
            SizedBox(height: 32.09.h),
            _divider(),
            SizedBox(height: 31.96.h),
            _age(context),
            SizedBox(height: 32.h),
            _divider(),
            SizedBox(height: 33.51.h),
            _genderRatio(context),
            SizedBox(height: 33.51.h),
            _divider(),
            SizedBox(height: 33.51.h),
            _detailedRules(context),
            SizedBox(height: 44.h),
          ],
        ),
      ),
    );
  }

  Widget _mainCategory(BuildContext context) {
    final viewModel = Provider.of<MeetBrowseViewModel>(context, listen: true);
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
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0.h, left: 22.46.w),
                      child: Text(
                        '상위 카테고리를 먼저 선택해주세요.',
                        style: AppTextStyles.PR_R_14
                            .copyWith(color: UsedColor.text_5),
                      ),
                    ),
                    SizedBox(
                      height: 29.52.h,
                    )
                  ],
                )
              else
                // 선택된 각 메인 카테고리에 대해 상세 카테고리 리스트를 표시
                ...viewModel.selectedMainCategories.map(
                  (mainCategory) => _subCategoryList(context, mainCategory),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _subCategoryList(BuildContext context, String mainCategory) {
    final viewModel = Provider.of<MeetBrowseViewModel>(context, listen: true);
    if (mainCategory == '기타') {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.0.h, left: 22.46.w),
            child: Text(
              '상위 카테고리를 먼저 선택해주세요.',
              style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
            ),
          ),
          SizedBox(
            height: 29.52.h,
          )
        ],
      );
    }
    List<String> subCategories = viewModel.getSubCategories(mainCategory);

    return Padding(
      padding: EdgeInsets.only(top: 19.0.h),
      child: Column(
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
                      color:
                          isSubSelected ? UsedColor.button : UsedColor.b_line,
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
      ),
    );
  }

  Widget _area(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 33.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: UsedColor.main, size: 12),
                  SizedBox(width: 14.46.w),
                  Text(
                    '지역',
                    style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              _selectedLocation(context),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 26.w),
                child: GestureDetector(
                  onTap: () {
                    context.goNamed('meetFilterArea');
                  },
                  child: SizedBox(child: Image.asset(ImagePath.nextArrow)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _selectedLocation(BuildContext context) {
    return Consumer<MeetBrowseViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.selectedProvince.isEmpty) {
          return const SizedBox.shrink();
        }
        String location = '';

        if (viewModel.selectedProvince != '전체') {
          location += viewModel.selectedProvince;
        }

        if (!viewModel.selectedDistrict.contains("전체")) {
          location += ' ${viewModel.selectedDistrict}';
        }

        return Text(
          location,
          style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_2),
        );
      },
    );
  }

  Widget _age(BuildContext context) {
    List<String> options = ['20대', '30대', '40대', '50대'];

    return Consumer<MeetBrowseViewModel>(
      builder: (context, viewModel, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 33.w),
              child: Row(
                children: [
                  Icon(Icons.circle, color: UsedColor.main, size: 12),
                  SizedBox(width: 14.46.w),
                  Text(
                    '나이',
                    style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 22.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 36.w),
              child: Wrap(
                spacing: 7.62.w,
                runSpacing: 7.62.h,
                children: options.map((option) {
                  bool isSelected = viewModel.selectedAge.contains(option);
                  return GestureDetector(
                    onTap: () {
                      viewModel.selectAge(option);
                    },
                    child: Container(
                      width: 74.38.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: isSelected ? UsedColor.button : Colors.white,
                        borderRadius: BorderRadius.circular(19.r),
                        border: Border.all(
                          color: isSelected
                              ? UsedColor.button
                              : const Color(0xFFD2D8F8),
                          width: 1.75.w,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: AppTextStyles.PR_M_12.copyWith(
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
        );
      },
    );
  }

  Widget _genderRatio(BuildContext context) {
    MeetBrowseViewModel viewModel =
        Provider.of<MeetBrowseViewModel>(context, listen: true);

    return Padding(
      padding: EdgeInsets.only(left: 27.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 6.0.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(
                  width: 13.85.w,
                ),
                // title
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '성비',
                    style: AppTextStyles.PR_SB_16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.only(left: 25.0.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => viewModel.selectWomen4(),
                  child: Image.asset(
                    (viewModel.roomGenderRatio == null)
                        ? ImagePath.grW4Empty
                        : (viewModel.roomGenderRatio!.name == "womanOnly")
                            ? ImagePath.grW4
                            : ImagePath.grW4Empty,
                    width: 76.w,
                    height: 76.h,
                  ),
                ),
                SizedBox(width: 24.w),
                GestureDetector(
                  onTap: () => viewModel.selectWomen2Men2(),
                  child: Image.asset(
                    (viewModel.roomGenderRatio == null)
                        ? ImagePath.grW2M2Empty
                        : (viewModel.roomGenderRatio!.name == "mixed")
                            ? ImagePath.grW2M2
                            : ImagePath.grW2M2Empty,
                    width: 76.w,
                    height: 76.h,
                  ),
                ),
                SizedBox(width: 24.w),
                GestureDetector(
                  onTap: () => viewModel.selectMen4(),
                  child: Image.asset(
                    (viewModel.roomGenderRatio == null)
                        ? ImagePath.grM4Empty
                        : (viewModel.roomGenderRatio!.name == "manOnly")
                            ? ImagePath.grM4
                            : ImagePath.grM4Empty,
                    width: 76.w,
                    height: 76.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - 세부 규칙 위젯
  Widget _detailedRules(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 27.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 6.0.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(width: 14.46.w),
                Text(
                  '세부 규칙',
                  style: AppTextStyles.PR_SB_16,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Consumer<MeetBrowseViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: viewModel.rules.entries.map((entry) {
                  bool isSelected = entry.value ?? false;
                  return Padding(
                    padding: EdgeInsets.only(left: 28.46.w, right: 39.12.w),
                    child: InkWell(
                      onTap: () {
                        viewModel.setRuleQuestion(entry.key, !isSelected);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 11.0.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(entry.key,
                                    style: isSelected
                                        ? AppTextStyles.PR_R_14
                                            .copyWith(color: UsedColor.violet)
                                        : AppTextStyles.PR_R_14
                                            .copyWith(color: UsedColor.text_5)),
                              ),
                              Icon(
                                Icons.check,
                                color: isSelected
                                    ? UsedColor.violet
                                    : UsedColor.text_5, // 색상 값을 조절하세요
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

// MARK: - bottom
  Widget _bottom(BuildContext context) {
    return Consumer<MeetBrowseViewModel>(
      builder: (context, viewModel, child) {
        bool isAllCompleted = viewModel.allCheckCompleted;
        return NextButton(
          onTap: () async {
            viewModel.addFilter();
            context.pop();
          },
          height: 56.h,
          text: '다음',
          enable: isAllCompleted,
          backgroundColor:
              isAllCompleted ? UsedColor.button : UsedColor.button_g,
          textStyle: TextStyle(
            color: isAllCompleted ? Colors.white : UsedColor.text_2,
            fontSize: 20.sp,
          ),
        );
      },
    );
  }
}
