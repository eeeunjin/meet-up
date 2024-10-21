import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';

class ProfileMeetingReview extends StatelessWidget {
  const ProfileMeetingReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 58.h,
            ),
            child: _header(context),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 28.w,
                right: 28.w,
                top: 12.h,
                bottom: 84.h,
              ),
              color: UsedColor.bg_color,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: _unreadReviewButton(),
                  ),
                  SizedBox(height: 30.h), // 날짜와 컨테이너 사이 간격 조정
                  // 날짜별 리뷰 리스트
                  _groupedReviewList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 헤더 위젯
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(title: '만남 후기', back: _back(context)),
          SizedBox(height: 16.h),
          Divider(
            thickness: 0.3.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  // 뒤로 가기 버튼
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

  // 읽지 않은 후기 버튼
  Widget _unreadReviewButton() {
    return Container(
      width: 125.w,
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(
            '읽지 않은 후기',
            style: AppTextStyles.PR_R_12.copyWith(
              color: UsedColor.charcoal_black,
            ),
          ),
          SizedBox(width: 8.w),
          CircleAvatar(
            radius: 8.r,
            backgroundColor: UsedColor.violet,
            child: Text(
              '1',
              style: AppTextStyles.PR_R_10.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // 날짜별로 그룹화된 리뷰 리스트
  Widget _groupedReviewList() {
    final groupedReviews = {
      '2000.00.00': [
        {
          'title': '클라이밍 좋아클라...',
          'sender': '발신자 | 초보 클밍이',
          'rating': 4,
          'isNew': false,
        },
        {
          'title': '클라이밍 좋아!',
          'sender': '발신자 | 중수 클밍이',
          'rating': 2,
          'isNew': true,
        },
      ],
    };

    return Column(
      children: groupedReviews.entries.map((entry) {
        String date = entry.key;
        List<Map<String, dynamic>> reviews = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 표시
            Padding(
              padding: EdgeInsets.only(
                left: 6.h,
              ),
              child: Text(
                date,
                style: AppTextStyles.PR_R_12.copyWith(
                  color: UsedColor.charcoal_black,
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            // 해당 날짜의 리뷰 리스트
            Column(
              children: reviews.map((review) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: _reviewCard(
                    title: review['title']!,
                    sender: review['sender']!,
                    rating: review['rating']!,
                    isNew: review['isNew']!,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }

  // 리뷰 카드
  Widget _reviewCard({
    required String title,
    required String sender,
    required int rating,
    required bool isNew,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 21.w,
        top: 16.h,
        bottom: 16.h,
      ),
      width: 341.w,
      height: 180.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: isNew
            ? Border.all(
                color: UsedColor.button,
                width: 2.w,
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우 공간 균등 분배
        crossAxisAlignment: CrossAxisAlignment.center, // 세로 중앙 정렬
        children: [
          // 리뷰 내용
          Expanded(
            child: _reviewContent(title, sender, rating, isNew),
          ),
          // Vertical Divider 가운데에 위치하도록
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: VerticalDivider(
              color: UsedColor.line, // Divider의 색상
              thickness: 0.3.w, // Divider의 두께
              width: 1.w, // Divider의 실제 너비
            ),
          ),
          SizedBox(width: 30.w),
        ],
      ),
    );
  }

  // 리뷰 내용
  Widget _reviewContent(String title, String sender, int rating, bool isNew) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isNew ? 8.h : 23.h),
          if (isNew) _newBadge(),
          SizedBox(height: isNew ? 4.h : 0),
          Text(
            title,
            style: AppTextStyles.PR_SB_15
                .copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(height: 4.h),
          Text(
            sender,
            style: AppTextStyles.PR_R_11.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 23.h),
          Padding(
            padding: EdgeInsets.only(
              left: 52.h,
            ),
            child: Text(
              "총점",
              textAlign: TextAlign.center,
              style: AppTextStyles.PR_M_11.copyWith(color: UsedColor.text_3),
            ),
          ),
          SizedBox(height: 8.h),
          _starRating(rating),
          SizedBox(
            height: 13.h,
          ),
        ],
      ),
    );
  }

  // NEW 배지
  Widget _newBadge() {
    return Container(
      width: 40.w,
      height: 16.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: UsedColor.button,
        borderRadius: BorderRadius.circular(14.55.r),
      ),
      child: Text(
        'NEW!',
        style: AppTextStyles.PR_R_9.copyWith(color: Colors.white),
      ),
    );
  }

  // 별점 표시
  Widget _starRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Padding(
          padding: EdgeInsets.only(right: 6.w),
          child: Image.asset(
            index < rating ? ImagePath.starSelected : ImagePath.star,
            width: 17.w,
            height: 17.h,
          ),
        );
      }),
    );
  }
}
