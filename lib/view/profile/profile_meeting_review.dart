import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/profile/profile_review_view_model.dart';
import 'package:provider/provider.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';

class ProfileMeetingReview extends StatelessWidget {
  const ProfileMeetingReview({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ProfileReviewViewModel>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 58.h),
            child: _header(context),
          ),
          Expanded(
            child: Container(
              color: UsedColor.bg_color,
              padding: EdgeInsets.only(
                top: 12.h,
                left: 28.w,
                right: 28.w,
                // bottom: 87.h,
              ),
              child: _main(context, viewModel),
            ),
          ),
        ],
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
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }
}

Widget _main(BuildContext context, ProfileReviewViewModel viewModel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _unreadReviewButton(),
      SizedBox(height: 16.h), // 버튼 간격
      Align(
        alignment: Alignment.centerRight,
        child: viewModel.isEditing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _closeButton(context, viewModel),
                  SizedBox(width: 8.w),
                  _selectAllButton(context, viewModel),
                ],
              )
            : _editButton(context, viewModel),
      ),
      SizedBox(height: 24.h),
      _groupedReviewList(context, viewModel),
      const Spacer(),
      if (viewModel.isEditing && viewModel.selectedReviews.containsValue(true))
        Padding(
          padding: EdgeInsets.only(bottom: 56.h),
          child: _deleteButton(context, viewModel),
        ),
    ],
  );
}

// MARK:- 편집 버튼
Widget _editButton(BuildContext context, ProfileReviewViewModel viewModel) {
  return GestureDetector(
    onTap: () {
      viewModel.toggleEditMode();
    },
    child: Container(
      height: 22.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Text(
        '편집',
        style: AppTextStyles.PR_M_12.copyWith(
          color: UsedColor.violet,
        ),
      ),
    ),
  );
}

// MARK:- 닫기 버튼
Widget _closeButton(BuildContext context, ProfileReviewViewModel viewModel) {
  return GestureDetector(
    onTap: () {
      viewModel.toggleEditMode();
    },
    child: Container(
      height: 22.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: UsedColor.button,
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Center(
        child: Text(
          '닫기',
          style: AppTextStyles.PR_M_12.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

// MARK:- 전체 선택 버튼
Widget _selectAllButton(
    BuildContext context, ProfileReviewViewModel viewModel) {
  return GestureDetector(
    onTap: () {
      // 전체 선택 동작 구현
    },
    child: Container(
      width: 62.w,
      height: 22.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Center(
        child: Text(
          '전체 선택',
          style: AppTextStyles.PR_M_12.copyWith(
            color: UsedColor.violet,
          ),
        ),
      ),
    ),
  );
}

// MARK:- 삭제 버튼
Widget _deleteButton(BuildContext context, ProfileReviewViewModel viewModel) {
  return GestureDetector(
    onTap: () {
      _showDeleteConfirmationDialog(context, viewModel);
    },
    child: Container(
      width: 329.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: UsedColor.charcoal_black,
        borderRadius: BorderRadius.circular(19.r),
      ),
      child: Center(
        child: Text(
          '삭제',
          style: AppTextStyles.PR_SB_20.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

// MARK:- 읽지 않은 후기 버튼
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

// MARK:- 리뷰 리스트
Widget _groupedReviewList(
    BuildContext context, ProfileReviewViewModel viewModel) {
  final groupedReviews = {
    '2000.00.00': [
      {
        'id': 1,
        'title': '클라이밍 좋아클라..',
        'sender': '발신자 | 초보 클밍이',
        'rating': 4,
        'isNew': false,
      },
      {
        'id': 2,
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
            padding: EdgeInsets.only(left: 6.h),
            child: Text(
              date,
              style: AppTextStyles.PR_R_12.copyWith(
                color: UsedColor.charcoal_black,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          // 해당 날짜의 리뷰 리스트
          Column(
            children: reviews.map((review) {
              return Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: _reviewCard(context, viewModel, review),
              );
            }).toList(),
          ),
        ],
      );
    }).toList(),
  );
}

// MARK:- 리뷰 카드
Widget _reviewCard(BuildContext context, ProfileReviewViewModel viewModel,
    Map<String, dynamic> review) {
  final int reviewId = review['id'];

  return GestureDetector(
    onTap: () {
      context.goNamed('profileMeetingReviewDetail');
    },
    child: Container(
      padding: EdgeInsets.only(
        left: 24.w,
      ),
      // width: 341.w,
      height: 181.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: review['isNew']
            ? Border.all(
                color: UsedColor.button,
                width: 2.w,
              )
            : null,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: _reviewContent(
                  review['title'],
                  review['sender'],
                  review['rating'],
                  review['isNew'],
                ),
              ),
              SizedBox(width: 24.w),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.h,
                ),
                child: VerticalDivider(
                  color: UsedColor.line,
                  thickness: 0.3.w,
                  width: 1.w,
                ),
              ),
              // SizedBox(width: 25.w),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 35.h,
                ),
                child: _imageChips(),
              ),
            ],
          ),
          if (viewModel.isEditing)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: GestureDetector(
                onTap: () {
                  viewModel.toggleSelection(reviewId);
                },
                child: Image.asset(
                  viewModel.isSelected(reviewId)
                      ? ImagePath.profileCheckBoxSelected
                      : ImagePath.profileCheckBox,
                  width: 20.w,
                  height: 20.h,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

// MARK:- 이미지 칩
Widget _imageChips() {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            _buildChip(ImagePath.profileChip1Check),
            SizedBox(width: 12.w),
            _buildChip(ImagePath.profileChip2Uncheck),
            SizedBox(width: 12.w),
            _buildChip(ImagePath.profileChip3Check),
          ],
        ),
        SizedBox(height: 18.h),
        Row(
          children: [
            _buildChip(ImagePath.profileChip4Uncheck),
            SizedBox(width: 12.w),
            _buildChip(ImagePath.profileChip5Check),
            SizedBox(width: 12.w),
            _buildChip(ImagePath.profileChip6Check),
          ],
        ),
      ],
    ),
  );
}

// MARK:- 칩 빌드 함수
Widget _buildChip(String imagePath) {
  return Column(
    children: [
      Image.asset(
        imagePath,
        width: 32.w,
        height: 44.h,
      ),
    ],
  );
}

// MARK:-리뷰 내용
Widget _reviewContent(String title, String sender, int rating, bool isNew) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: isNew ? 24.h : 44.h),
        if (isNew) _newBadge(),
        SizedBox(height: isNew ? 4.h : 0),
        Text(
          title,
          style: AppTextStyles.PR_SB_15.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          sender,
          style: AppTextStyles.PR_R_11.copyWith(
            color: UsedColor.text_3,
          ),
        ),
        SizedBox(height: 23.h),
        Padding(
          padding: EdgeInsets.only(left: 52.h),
          child: Text(
            "총점",
            textAlign: TextAlign.center,
            style: AppTextStyles.PR_M_11.copyWith(
              color: UsedColor.text_3,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _starRating(rating),
        SizedBox(height: 13.h),
      ],
    ),
  );
}

// MARK:-NEW 배지
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

//MARK:- 별점 표시
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

// MARK: - 삭제 확인 팝업창 표시
void _showDeleteConfirmationDialog(
    BuildContext context, ProfileReviewViewModel viewModel) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(
        '만남 후기를 삭제하시겠습니까?',
        style: AppTextStyles.PR_SB_16.copyWith(
          color: UsedColor.charcoal_black,
        ),
        textAlign: TextAlign.center,
      ),
      content: Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Text(
          '삭제시 복구할 수 없습니다.',
          style: AppTextStyles.PR_R_12.copyWith(
            color: UsedColor.charcoal_black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop(); // 팝업 닫기
          },
          child: Text(
            '취소',
            style: AppTextStyles.PR_M_14.copyWith(
              color: UsedColor.charcoal_black,
            ),
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {
            // 삭제 로직 호출
            viewModel.deleteSelectedReviews();
            Navigator.of(context).pop(); // 팝업 닫기
          },
          child: Text(
            '삭제',
            style: AppTextStyles.PR_M_14.copyWith(
              color: UsedColor.charcoal_black,
            ),
          ),
        ),
      ],
    ),
  );
}
