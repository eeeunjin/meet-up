import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/profile/profile_review_view_model.dart';
import 'package:provider/provider.dart';

class ProfileMeetingReviewDetail extends StatelessWidget {
  const ProfileMeetingReviewDetail({super.key});

  // MARK: - 빌드
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

  // MARK: - 헤더
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '만남 후기'),
        ],
      ),
    );
  }

  // MARK: - 뒤로가기
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

  // MARK: - 메인
  Widget _main(BuildContext context) {
    final viewModel =
        Provider.of<ProfileReviewViewModel>(context, listen: false);
    final review = viewModel.selectedReview!;
    final profileImage = review.senderProfileIcon;
    final nickname = review.senderNickname;
    final title = review.roomTitle;
    final rating = review.rating;
    final chosenChips = review.chosenChips;
    final comment = review.comment;

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
                  _userInfo(context,
                      profileImage: profileImage,
                      nickname: nickname,
                      title: title),
                  Divider(thickness: 0.75.h, color: UsedColor.b_line),
                  _ratingSection(context, rating: rating),
                  _feedbackSection(context,
                      chosenChips: chosenChips, rating: rating),
                  _commentSection(context, comment: comment),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // MARK: - 사용자 정보
  Widget _userInfo(
    BuildContext context, {
    required String profileImage,
    required String nickname,
    required String title,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 80.h,
          width: 80.w,
          child: Image.asset(profileImage),
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
          title,
          style: AppTextStyles.PR_M_15.copyWith(
            color: UsedColor.text_3,
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  // MARK: - 평가
  Widget _ratingSection(
    BuildContext context, {
    required int rating,
  }) {
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
                index < rating ? ImagePath.starSelected : ImagePath.star,
                width: 33.w,
                height: 33.h,
              ),
            );
          }),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  // MARK: - 피드백
  Widget _feedbackSection(BuildContext context,
      {required List<dynamic> chosenChips, required int rating}) {
    final List<String> chosenChip =
        chosenChips.map((e) => e as String).toList();
    final List<int> chosenChipFormatted = chosenChip
        .map((e) => int.parse(e.replaceAll("chatReview", "")))
        .toList();

    final List<String> chipImages = [];
    const String imageString = "chatReview";
    if (rating >= 3) {
      for (int i = 1; i < 7; i++) {
        chipImages.add("$imageString$i");
      }
    } else {
      for (int i = 7; i < 13; i++) {
        chipImages.add("$imageString$i");
      }
    }

    final List<String> labels = (rating < 3)
        ? ['지각', '느린 응답', '불친절', '규칙 미준수', '약속 부도', '불순한 목적']
        : ['시간 준수', '빠른 응답', '매너와 센스', '원활한 소통', '공통 관심사', '좋은 인상'];

    final String title = (rating < 3) ? '이런 점이 아쉬웠어요!' : '이런 점이 좋았어요!';

    return Column(
      children: [
        Text(
          title,
          style: AppTextStyles.PR_SB_15.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++) ...[
              _imageChip(
                  chipImages[i],
                  labels[i],
                  rating < 3
                      ? chosenChipFormatted.contains(i + 7)
                      : chosenChipFormatted.contains(i + 1)),
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
              _imageChip(
                  chipImages[i],
                  labels[i],
                  rating < 3
                      ? chosenChipFormatted.contains(i + 7)
                      : chosenChipFormatted.contains(i + 1)),
              if (i != 5) SizedBox(width: 24.w),
            ],
          ],
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  // MARK: - 이미지 칩
  Widget _imageChip(
    String imageName,
    String label,
    bool isSelected,
  ) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 58.w,
            height: 58.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? UsedColor.button : Colors.white,
            ),
            child: SizedBox(
              width: 33.w,
              height: 33.h,
              child: isSelected
                  ? Image.asset(ImagePath.chatReviewSelected(imageName))
                  : Image.asset(ImagePath.chatReview(imageName)),
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

  // MARK: - 코멘트 섹션
  Widget _commentSection(
    BuildContext context, {
    required String comment,
  }) {
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
            controller: TextEditingController(text: comment),
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
