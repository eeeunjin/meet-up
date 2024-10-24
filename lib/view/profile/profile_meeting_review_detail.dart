import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';

class ProfileMeetingReviewDetail extends StatelessWidget {
  const ProfileMeetingReviewDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 58.h),
              child: _header(context),
            ),
            Expanded(child: _main(context)),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '만남 후기'),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: SizedBox(
        width: 30.w,
        height: 30.h,
        child: Image.asset(
          ImagePath.close,
        ),
      ),
    );
  }

  Widget _main(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.h,
            left: 27.w,
            right: 26.w,
            bottom: 28.h,
          ),
          child: Center(
            child: Container(
              width: 340.w,
              height: 708.h,
              decoration: BoxDecoration(
                color: UsedColor.image_card,
                borderRadius: BorderRadius.circular(29.r),
              ),
              child: Column(
                children: [
                  SizedBox(height: 23.h),
                  _userInfo("닉네임 1", "초보 클밍 모임", ""),
                  Divider(thickness: 0.75.h, color: UsedColor.b_line),
                  _ratingSection(context),
                  _feedbackSection(context),
                  _commentSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userInfo(String nickname, String group, String profileImage) {
    return Column(
      children: [
        SizedBox(
          height: 80.h,
          width: 80.w,
          // child: Image.asset(profileImage),
          child: Image.asset(ImagePath.aengmuSelect),
        ),
        SizedBox(height: 8.h),
        Text(
          nickname,
          style: AppTextStyles.PR_B_24.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          group,
          style: AppTextStyles.PR_M_15.copyWith(
            color: UsedColor.text_3,
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _ratingSection(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Text(
          '총점',
          style: AppTextStyles.PR_SB_15.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Image.asset(
                index < 4 ? ImagePath.starSelected : ImagePath.star,
                width: 33.w,
                height: 33.h,
              ),
            );
          }),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _feedbackSection(BuildContext context) {
    final List<String> positiveLabels = [
      '시간 준수',
      '빠른 응답',
      '매너와 센스',
      '원활한 소통',
      '공통 관심사',
      '좋은 인상',
    ];

    final List<String> images = [
      'chatReview7',
      'chatReview8',
      'chatReview9',
      'chatReview10',
      'chatReview11',
      'chatReview12'
    ];

    final List<String> negativeLabels = [
      '지각',
      '느린 응답',
      '불친절',
      '규칙 미준수',
      '약속 부도',
      '불순한 목적',
    ];

    return Column(
      children: [
        Text(
          "이런 점이 좋았어요!",
          style: AppTextStyles.PR_SB_15.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++) ...[
              _imageChip(images[i], positiveLabels[i]),
              if (i != 2) SizedBox(width: 24.w),
            ],
          ],
        ),
        SizedBox(
          height: 11.89.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 3; i < 6; i++) ...[
              _imageChip(images[i], positiveLabels[i]),
              if (i != 5) SizedBox(width: 24.w),
            ],
          ],
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _imageChip(String imageName, String label) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 58.w,
            height: 58.h,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: UsedColor.button),
            child: SizedBox(
              width: 33.w,
              height: 33.h,
              child: Image.asset(ImagePath.chatReviewSelected(imageName)),
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            label,
            style: AppTextStyles.PR_M_12.copyWith(
              color: UsedColor.text_2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _commentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '사용자님은 이런 사람이었어요!',
          style: AppTextStyles.PR_SB_15.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: 292.w,
          height: 91.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: TextField(
            minLines: 3,
            maxLines: null,
            enabled: false,
            style: AppTextStyles.PR_R_13.copyWith(
              color: UsedColor.text_5,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  vertical: 14.h, horizontal: 16.w), // content padding 설정
            ),
          ),
        ),
      ],
    );
  }
}
