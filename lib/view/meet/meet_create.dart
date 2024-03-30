import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
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
        _naming(),
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
        _genderRatio(),
        SizedBox(height: 32.7.h),
        _divider(),
        SizedBox(height: 32.h),
        _rules(context),
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
  Widget _naming() {
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
            child: Transform.translate(
              offset: Offset(0, -4.0.h), // text와 높이를 맞추기 위한 임의 값
              child: Container(
                alignment: Alignment.center,
                width: 210.w, // 임의 값
                height: 19.h,
                child: TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: '방 명을 입력해주세요',
                    hintStyle: TextStyle(color: UsedColor.text_5),
                  ),
                  style: AppTextStyles.PR_R_15,
                ),
              ),
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
                style: AppTextStyles.PR_R_15,
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
  Widget _genderRatio() {
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
                    '성비',
                    style: AppTextStyles.PR_SB_16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 13.3.h),
          Row(
            children: [
              Container(
                width: 76.w,
                height: 76.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: UsedColor.iamge_card),
              ),
              Container(
                width: 76.w,
                height: 76.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: UsedColor.iamge_card),
              ),
              Container(
                width: 76.w,
                height: 76.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: UsedColor.iamge_card),
              ),
            ],
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
                  width: 23.w,
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
          SizedBox(height: 32.09.w),
          // contents
          ...viewModel.rules.keys.map(
            (rule) => Padding(
              padding: EdgeInsets.only(left: 14.46.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      rule,
                      style: AppTextStyles.PR_R_14,
                    ),
                  ),
                  _responseButton(),
                  SizedBox(width: 7.12.w),
                  _responseButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _responseButton() {
    return GestureDetector(
        // onTap: ,
        child: Container());
  }
}
