import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:provider/provider.dart';

class MeetCreate extends StatelessWidget {
  const MeetCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
              _main(context),
              Padding(
                padding: EdgeInsets.only(left: 33.w, right: 32.w, bottom: 56.h),
                child: _bottom(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '만남방 개설하기'),
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
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  // main contents
  Widget _main(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 33.h),
        _naming(context),
        SizedBox(height: 31.h),
        _divider(),
        SizedBox(height: 33.h),
        _category(),
        SizedBox(height: 31.h),
        _divider(),
        SizedBox(height: 33.h),
        _location(),
        SizedBox(height: 31.h),
        _divider(),
        SizedBox(height: 32.91.h),
        _keyword(),
        SizedBox(height: 31.h),
        _divider(),
        SizedBox(height: 32.31.h),
        _detail(context),
        SizedBox(height: 22.h),
        _age(context),
        SizedBox(height: 33.h),
        _divider(),
        SizedBox(height: 32.h),
        _genderRatio(context),
        SizedBox(height: 32.7.h),
        _divider(),
        SizedBox(height: 32.h),
        _rules(context),
        SizedBox(height: 72.2.h),
      ],
    );
  }

  // 구분선
  Widget _divider() {
    return Divider(
      height: 0.91.h,
      color: const Color(0xffd9d9d9),
    );
  }

  // MARK - 방 명
  Widget _naming(BuildContext context) {
    final viewModel = Provider.of<MeetCreateViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 파란 동그라미
          Container(
            width: 8.w,
            height: 8.w,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: UsedColor.main),
          ),
          SizedBox(
            width: 23.w,
          ),
          // title
          Container(
            alignment: Alignment.center,
            child: Text(
              '방 명',
              style: AppTextStyles.PR_SB_16,
            ),
          ),
          SizedBox(width: 23.w),
          // text field
          Expanded(
            child: Stack(
              children: [
                Transform.translate(
                  offset: Offset(0, -4.0.h), // text와 높이를 맞추기 위한 임의 값
                  child: Container(
                    alignment: Alignment.center,
                    width: 210.w, // 임의 값
                    height: 19.h,
                    child: TextField(
                      onChanged: (text) {
                        viewModel.countNaming(text);
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: '방 명을 입력해주세요',
                        hintStyle: TextStyle(color: UsedColor.text_5),
                      ),
                      style: AppTextStyles.PR_R_15
                          .copyWith(color: UsedColor.text_5),
                    ),
                  ),
                ),
                Positioned(
                  right: 26.0.w,
                  bottom: 0.0.h,
                  child: Text(
                    viewModel.subNamingCount,
                    style: AppTextStyles.PR_SB_11
                        .copyWith(color: UsedColor.text_3), // 임의 색상
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MARK - 카테고리
  Widget _category() {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 파란 동그라미
          Container(
            width: 8.w,
            height: 8.w,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: UsedColor.main),
          ),
          SizedBox(
            width: 23.w,
          ),
          // title
          Container(
            alignment: Alignment.center,
            child: Text(
              '카테고리',
              style: AppTextStyles.PR_SB_16,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 26.0.w),
            child: Image.asset(ImagePath.nextArrow),
          ),
        ],
      ),
    );
  }

  // MARK - 지역
  Widget _location() {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 파란 동그라미
          Container(
            width: 8.w,
            height: 8.w,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: UsedColor.main),
          ),
          SizedBox(
            width: 23.w,
          ),
          // title
          Container(
            alignment: Alignment.center,
            child: Text(
              '지역',
              style: AppTextStyles.PR_SB_16,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 26.0.w),
            child: Image.asset(ImagePath.nextArrow),
          ),
        ],
      ),
    );
  }

  // MARK - 키워드
  Widget _keyword() {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 파란 동그라미
          Container(
            width: 8.w,
            height: 8.w,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: UsedColor.main),
          ),
          SizedBox(
            width: 23.w,
          ),
          // title
          Container(
            alignment: Alignment.center,
            child: Text(
              '키워드',
              style: AppTextStyles.PR_SB_16,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 26.0.w),
            child: Image.asset(ImagePath.nextArrow),
          ),
        ],
      ),
    );
  }

  // MARK - 설명
  Widget _detail(BuildContext context) {
    final viewModel = Provider.of<MeetCreateViewModel>(context);
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
                // 파란 동그라미
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(
                  width: 23.w,
                ),
                // title
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '설명',
                    style: AppTextStyles.PR_SB_16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.09.w),
          // 설명 입력란
          Container(
            width: 340.w,
            height: 176.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: UsedColor.B_line, width: 2.h),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 28.0.w, top: 15.h),
              child: TextField(
                decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: '만남 목표를 간단히 입력해 주세요. (50자 제한)',
                    hintStyle: TextStyle(color: UsedColor.text_5)),
                onChanged: (text) {
                  viewModel.setDescription(text);
                },
                style: AppTextStyles.PR_R_15.copyWith(color: UsedColor.text_5),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          //글자수 표시
          Padding(
            padding: EdgeInsets.only(left: 307.w),
            child: Text(
              viewModel.subTextCount,
              style: AppTextStyles.PR_SB_11
                  .copyWith(color: UsedColor.text_3), // 임의 색상
            ),
          ),
        ],
      ),
    );
  }

  // MARK - 나이
  Widget _age(BuildContext context) {
    final viewModel = Provider.of<MeetCreateViewModel>(context, listen: true);
    List<String> options = [
      "20대",
      "30대",
      "40대",
      "50대",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 33.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 파란 동그라미
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: UsedColor.main),
              ),
              SizedBox(
                width: 23.w,
              ),
              // title
              Container(
                alignment: Alignment.center,
                child: Text(
                  '나이',
                  style: AppTextStyles.PR_SB_16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 21.h),
        Padding(
          padding: EdgeInsets.only(left: 36.w),
          child: Wrap(
            spacing: 7.62.w,
            runSpacing: 7.62.h,
            children: options.map((option) {
              bool isSelected = viewModel.selectedAges.contains(option);
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
  }

  // MARK - 성비
  Widget _genderRatio(BuildContext context) {
    MeetCreateViewModel viewModel =
        Provider.of<MeetCreateViewModel>(context, listen: true);

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
                // 파란 동그라미
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
          SizedBox(height: 13.3.h),
          Padding(
            padding: EdgeInsets.only(left: 31.0.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => viewModel.selectWomen4(),
                  child: Image.asset(
                    viewModel.isWomen4Selected
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
                    viewModel.isWomen2Men2Selected
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
                    viewModel.isMen4Selected
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

  // MARK - 세부 규칙
  Widget _rules(BuildContext context) {
    MeetCreateViewModel viewModel = Provider.of<MeetCreateViewModel>(context);

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
                // 파란 동그라미
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(
                  width: 14.46.w,
                ),
                // title
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '세부 규칙',
                    style: AppTextStyles.PR_SB_16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 27.1.h),
          // contents
          ...viewModel.rules.entries.map((entry) {
            bool isSelected = entry.value ?? false;
            return Padding(
              padding: EdgeInsets.only(left: 28.46.w, right: 39.12.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(entry.key,
                            style: isSelected
                                ? AppTextStyles.PR_M_14
                                    .copyWith(color: Colors.black)
                                : AppTextStyles.PR_R_14
                                    .copyWith(color: UsedColor.text_5)),
                      ),
                      _responseButton(context, entry.key, true),
                      SizedBox(width: 7.12.w),
                      _responseButton(context, entry.key, false),
                    ],
                  ),
                  SizedBox(
                    height: 22.58.h,
                  )
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // MARK - 세부 규칙 - 예, 아니요 컨테이너
  Widget _responseButton(BuildContext context, String rule, bool response) {
    MeetCreateViewModel viewModel =
        Provider.of<MeetCreateViewModel>(context, listen: false);
    bool isSelected = viewModel.rules[rule] == response;

    return GestureDetector(
      onTap: () {
        viewModel.setRuleQuestion(rule, response);
      },
      child: Container(
        width: 42.96.w,
        height: 19.75.h,
        decoration: BoxDecoration(
            color: isSelected ? UsedColor.button : Colors.white,
            borderRadius: BorderRadius.circular(9.9.r),
            border: Border.all(
                color: isSelected ? UsedColor.button : UsedColor.B_line,
                width: 1.41.h)),
        child: Center(
          child: Text(response ? '가능' : '불가능',
              style: AppTextStyles.PR_SB_11.copyWith(
                color: isSelected ? Colors.white : Colors.black,
              )),
        ),
      ),
    );
  }

  Widget _bottom(BuildContext context) {
    return Consumer<MeetCreateViewModel>(
      builder: (context, viewModel, child) {
        return NextButton(
          onTap: () async {
            if (!viewModel.allCheckCompleted) return;
          },
          height: 56.h,
          text: '만남방 개설',
          enable: viewModel.allCheckCompleted,
          backgroundColor: viewModel.allCheckCompleted
              ? UsedColor.button
              : UsedColor.button_g,
          textStyle: TextStyle(
            color:
                viewModel.allCheckCompleted ? Colors.white : UsedColor.text_2,
            fontSize: 20.sp,
          ),
        );
      },
    );
  }
}
