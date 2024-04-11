import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_keyword_view_model.dart';
import 'package:provider/provider.dart';

class MeetKeyWord extends StatelessWidget {
  const MeetKeyWord({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MeetKeyWordViewModel>(context);

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
            SizedBox(height: 63.h),
            _main(context, viewModel),
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
          header(back: _back(context), title: '키워드 입력'),
          SizedBox(
            height: 11.h,
          ),
          Divider(
            height: 0.3.h,
            color: UsedColor.line,
          )
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

  Widget _main(BuildContext context, MeetKeyWordViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(left: 29.w, right: 26.w),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              // '#' 텍스트
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Text(
                  '#',
                  style:
                      AppTextStyles.PR_SB_22.copyWith(color: UsedColor.button),
                ),
              ),
              // 텍스트 필드
              TextField(
                controller: viewModel.textController,
                cursorColor: Colors.black, // 커서 색상 변경
                decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText: '관련 키워드를 입력해주세요. (최대 3개)',
                  hintStyle:
                      AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_5),
                  contentPadding: EdgeInsets.only(left: 25.w),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: UsedColor.text_1, width: 0.75),
                  ),
                ),
                onChanged: (text) {
                  viewModel.setDescription(text);
                },
                style: AppTextStyles.PR_R_15,
              ),
              // 저장 버튼
              Positioned(
                right: 2.w,
                child: GestureDetector(
                  onTap: () {
                    String keyword = viewModel.textController.text.trim();
                    debugPrint('Before adding keyword: $keyword');
                    if (keyword.isNotEmpty) {
                      viewModel.addKeyword(keyword);
                      viewModel.textController.clear();
                    }
                  },
                  child: Container(
                    width: 44.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.r),
                      border: Border.all(width: 1.w, color: UsedColor.B_line),
                    ),
                    child: Center(
                      child: Text(
                        '저장',
                        style: AppTextStyles.PR_M_13
                            .copyWith(color: UsedColor.charcoal_black),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 텍스트 카운트 표시
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.0.w, top: 5.0.h, right: 7.0.w),
                child: Row(
                  children: [
                    Text(
                      '띄어쓰기 없이 1-8자 입력하세요.',
                      style:
                          AppTextStyles.SU_R_12.copyWith(color: UsedColor.red),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(top: 3.0.h),
                      child: Text(
                        viewModel.subTextCount,
                        style: AppTextStyles.PR_SB_11
                            .copyWith(color: UsedColor.text_3), // 임의 색상
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 6.0.h),
                  child: _keywordList(context, viewModel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _keywordList(BuildContext context, MeetKeyWordViewModel viewModel) {
    return Wrap(
      // 자동 줄바꿈
      spacing: 4.0, // 좌우 간격
      runSpacing: 4.0, // 상하 간격
      children: viewModel.keywords
          .map((keyword) => _keywordChip(
              keyword,
              AppTextStyles.SU_SB_12.copyWith(color: UsedColor.violet),
              context))
          .toList(),
    );
  }

  Widget _keywordChip(
      String keyword, TextStyle textStyle, BuildContext context) {
    double baseWidth = 78.w;
    int additionalCharacters = keyword.length - 2;
    double additionalWidth = 10.w;
    double containerWidth =
        baseWidth + (additionalCharacters * additionalWidth);

    containerWidth = max(containerWidth, baseWidth);

    return Container(
      width: containerWidth,
      height: 29.h,
      decoration: BoxDecoration(
        color: UsedColor.image_card,
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '#$keyword',
                style: AppTextStyles.SU_SB_12.copyWith(color: UsedColor.violet),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<MeetKeyWordViewModel>(context, listen: false)
                  .removeKeyword(keyword);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 6.0.w),
              child: Image.asset(
                ImagePath.closeIcon,
                width: 7.w,
                height: 7.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
