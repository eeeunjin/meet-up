import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/model/diary_model.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/view_model/chat/chat_room_meeting_review_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/reflect/reflect_record_view_model.dart';
import 'package:provider/provider.dart';

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
              padding: EdgeInsets.only(
                top: 58.h,
              ),
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
          header(title: '만남 후기', back: _back(context)),
          SizedBox(
            height: 16.h,
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
        ImagePath.close,
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  Widget _main(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 20.h,
          left: 28.w,
          right: 27.w,
          bottom: 18.h,
        ),
        child: Center(
          child: Container(
            width: 338.w,
            decoration: BoxDecoration(
              color: UsedColor.image_card,
              borderRadius: BorderRadius.circular(29.r),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 41.h,
                bottom: 23.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _profileSection(),
                  SizedBox(height: 24.h),
                  Divider(
                    color: UsedColor.b_line,
                    thickness: 0.75.w,
                  ),
                  SizedBox(height: 24.h),
                  _ratingSection(),
                  SizedBox(height: 28.h),
                  _featuresGrid(),
                  SizedBox(height: 28.h),
                  _bottomTextField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileSection() {
    return Column(
      children: [
        Image.asset(
          ImagePath.cogySelect,
          width: 80.w,
          height: 80.h,
        ),
        SizedBox(height: 8.h),
        Text(
          '닉네임1',
          style: AppTextStyles.PR_B_24.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '초보 클밍 모임',
          style: AppTextStyles.PR_M_15.copyWith(
            color: UsedColor.text_3,
          ),
        ),
      ],
    );
  }

  Widget _ratingSection() {
    return Column(
      children: [
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
              padding: EdgeInsets.only(right: 13.89.w),
              child: Image.asset(
                index < 4 ? ImagePath.starSelected : ImagePath.star, // 별 이미지
                width: 32.w, // 별 크기 설정
                height: 32.h,
              ),
            );
          }),
        ),
        SizedBox(height: 28.h),
        Text(
          '이런 점이 좋았어요!',
          style: AppTextStyles.PR_SB_15.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
      ],
    );
  }

  Widget _featuresGrid() {
    final List<String> positiveLabels = [
      '시간 준수',
      '빠른 응답',
      '매너와 센스',
      '원활한 소통',
      '공통 관심사',
      '좋은 인상',
    ];

    final List<String> negativeLabels = [
      '지각',
      '느린 응답',
      '불친절',
      '규칙 미준수',
      '약속 부도',
      '불순한 목적',
    ];

    final List<String> labels = [
      ...positiveLabels,
      ...negativeLabels
    ]; // 두 리스트 결합

    // 예시 이미지 리스트
    final List<String> images = [
      ImagePath.chatReview1Selected,
      ImagePath.chatReview2,
      ImagePath.chatReview3Selected,
      ImagePath.chatReview4,
      ImagePath.chatReview5Selected,
      ImagePath.chatReview6Selected,
    ];
    // final List<String> images = [
    //   ImagePath.chatReview1,
    //   ImagePath.chatReview2,
    //   ImagePath.chatReview3,
    //   ImagePath.chatReview4,
    //   ImagePath.chatReview5,
    //   ImagePath.chatReview6,
    //   ImagePath.chatReview7,
    //   ImagePath.chatReview8,
    //   ImagePath.chatReview9,
    //   ImagePath.chatReview10,
    //   ImagePath.chatReview11,
    //   ImagePath.chatReview12,
    // ];
    // final List<String> imageSelected = [
    //   ImagePath.chatReview1Selected,
    //   ImagePath.chatReview2Selected,
    //   ImagePath.chatReview3Selected,
    //   ImagePath.chatReview4Selected,
    //   ImagePath.chatReview5Selected,
    //   ImagePath.chatReview6Selected,
    //   ImagePath.chatReview7Selected,
    //   ImagePath.chatReview8Selected,
    //   ImagePath.chatReview9Selected,
    //   ImagePath.chatReview10Selected,
    //   ImagePath.chatReview11Selected,
    //   ImagePath.chatReview12Selected,
    // ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 24.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: positiveLabels.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58.w,
              height: 58.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: SizedBox(
                width: 33.w,
                height: 33.h,
                child: Image.asset(
                  images[index],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 7.h),
            Text(
              positiveLabels[index],
              style: AppTextStyles.PR_M_12.copyWith(
                color: UsedColor.text_2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  Widget _bottomTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '사용자',
                style: AppTextStyles.PR_B_15.copyWith(
                  color: UsedColor.charcoal_black,
                ),
              ),
              TextSpan(
                text: '님은 이런 사람이었어요!',
                style: AppTextStyles.PR_SB_15.copyWith(
                  color: UsedColor.charcoal_black,
                ),
              ),
            ],
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
            child: TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: AppTextStyles.PR_R_13.copyWith(
                  color: UsedColor.text_2,
                )),
          ),
        ),
      ],
    );
  }
}
