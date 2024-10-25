import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/profile/profile_review_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';

class ProfileMeetingReview extends StatelessWidget {
  const ProfileMeetingReview({super.key});

  // MARK: - 빌드
  @override
  Widget build(BuildContext context) {
    final profileReviewViewModel =
        Provider.of<ProfileReviewViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        final profileReviewViewModel =
            Provider.of<ProfileReviewViewModel>(context, listen: false);
        profileReviewViewModel.resetAllStates();
        context.pop();
      },
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot<Object?>>(
          stream:
              profileReviewViewModel.loadReviewData(uid: userViewModel.uid!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('데이터를 불러오는 중에 오류가 발생했습니다.'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // 리뷰 데이터 불러오기
            final reviews = snapshot.data!.docs
                .map((doc) => MeetingReviewModel.fromJson(
                    doc.data() as Map<String, dynamic>))
                .toList();
            profileReviewViewModel.saveReviewData(reviews);

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 58.h),
                  child: _header(context),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: UsedColor.bg_color,
                        constraints: const BoxConstraints.expand(),
                        padding: EdgeInsets.only(
                          top: 27.h,
                          left: 28.w,
                          right: 28.w,
                        ),
                        child: _main(context),
                      ),
                      if (profileReviewViewModel.selectedEditReviews.isNotEmpty)
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 1.sw,
                            height: 120.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(
                                  color: UsedColor.line,
                                  width: 0.3.h,
                                ),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: UsedColor.grey1,
                                  offset: const Offset(0, -4),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 24.h),
                                _deleteButton(context),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // MARK: - 헤더
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(title: '만남 후기', back: _back(context)),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            thickness: 0.3.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  // MARK: - 뒤로 가기 버튼
  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final profileReviewViewModel =
            Provider.of<ProfileReviewViewModel>(context, listen: false);
        profileReviewViewModel.resetAllStates();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  // MARK: - 메인
  Widget _main(BuildContext context) {
    final viewModel = Provider.of<ProfileReviewViewModel>(context);
    logger.d("rebuild");
    logger.d(viewModel.selectedEditReviews.map((e) => e.roomTitle).toList());

    return viewModel.reviews.isEmpty
        ? _emptyStateMode()
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _topTitle(context),
                SizedBox(height: 25.h),
                _groupedReviewList(context),
                if (viewModel.selectedEditReviews.isNotEmpty)
                  SizedBox(height: 120.h)
              ],
            ),
          );
  }

  // MARK: - 받은 만남 후기가 없을 때
  Widget _emptyStateMode() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 243.h),
          Image.asset(
            ImagePath.reflectNoneDiaryRecord,
            width: 50.w,
            height: 50.h,
          ),
          SizedBox(height: 16.h),
          Text(
            '받은 만남 후기가 없습니다',
            style: AppTextStyles.PR_R_17.copyWith(
              color: UsedColor.text_5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // MARK: - 편집 버튼
  Widget _editButton(BuildContext context) {
    final viewModel =
        Provider.of<ProfileReviewViewModel>(context, listen: false);
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

  // MARK: - 닫기 버튼
  Widget _closeButton(BuildContext context) {
    ProfileReviewViewModel viewModel =
        Provider.of<ProfileReviewViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        viewModel.resetSelectedEditReviews();
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

  // MARK: - 전체 선택 버튼
  Widget _selectAllButton(BuildContext context) {
    ProfileReviewViewModel viewModel =
        Provider.of<ProfileReviewViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        // 전체 선택 동작 구현
        viewModel.selectAllReviews();
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

  // MARK: - 삭제 버튼
  Widget _deleteButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDeleteConfirmationDialog(context);
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

  // MARK: - 부제
  Widget _topTitle(BuildContext context) {
    ProfileReviewViewModel viewModel =
        Provider.of<ProfileReviewViewModel>(context, listen: false);

    int newReviewNum =
        viewModel.reviews.where((element) => element.isNew).length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '받은 후기',
          style: AppTextStyles.PR_SB_20.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
        SizedBox(width: 8.w),
        if (newReviewNum > 0)
          Container(
            width: 16.w,
            height: 16.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: UsedColor.main,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              viewModel.reviews
                  .where((element) => element.isNew)
                  .length
                  .toString(),
              style: AppTextStyles.PR_R_10.copyWith(color: Colors.white),
            ),
          ),
        const Spacer(),
        viewModel.isEditing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _closeButton(context),
                  SizedBox(width: 8.w),
                  _selectAllButton(context),
                ],
              )
            : _editButton(context),
      ],
    );
  }

  // MARK: - 리뷰 리스트
  Widget _groupedReviewList(BuildContext context) {
    ProfileReviewViewModel viewModel =
        Provider.of<ProfileReviewViewModel>(context, listen: false);

    return Column(
      children: viewModel.getGroupedReviews().entries.map((entry) {
        String date = entry.key;
        List<MeetingReviewModel> reviews = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 표시
            Padding(
              padding: EdgeInsets.only(left: 6.h),
              child: SizedBox(
                height: 14.h,
                child: Text(
                  date,
                  style: AppTextStyles.PR_R_12.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            // 해당 날짜의 리뷰 리스트
            Column(
              children: reviews.map((review) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: _reviewCard(context, review),
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }

  // MARK: - 리뷰 카드
  Widget _reviewCard(BuildContext context, MeetingReviewModel review) {
    ProfileReviewViewModel viewModel =
        Provider.of<ProfileReviewViewModel>(context, listen: false);
    UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () async {
        if (viewModel.isEditing) {
          // 편집 모드일 때
          viewModel.setSelectedEditReviews(review);
          return;
        }

        if (review.isNew) {
          // 새로운 리뷰를 읽었을 때 isNew 상태 변경
          await viewModel.updateMeetingReviewModel(
            uid: userViewModel.uid,
            meetingReviewId: review.meetingReviewDocId,
          );
        }

        viewModel.setSelectedReview(review);

        if (context.mounted) {
          context.goNamed('profileMeetingReviewDetail');
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 24.w,
        ),
        height: 181.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: review.isNew
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
                _reviewContent(
                  review.roomTitle,
                  review.senderNickname,
                  review.rating,
                  review.isNew,
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 35.h,
                  ),
                  child: _imageChips(
                    context,
                    review.chosenChips,
                  ),
                ),
              ],
            ),
            if (viewModel.isEditing)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    viewModel.selectedEditReviews
                            .where((element) =>
                                element.meetingReviewDocId ==
                                review.meetingReviewDocId)
                            .isNotEmpty
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

  // MARK: - 이미지 칩
  Widget _imageChips(BuildContext context, List<dynamic> chosenChips) {
    final chosenChipFormatted = chosenChips.map((e) {
      final chipNum = e as String;
      return int.parse(chipNum.replaceAll("chatReview", ""));
    }).toList();

    List<String> chipImages = [];
    String imageString = "assets/images/profile_meeting_review_chip";
    if (chosenChipFormatted.first < 7) {
      for (int i = 1; i < 7; i++) {
        if (!chosenChipFormatted.contains(i)) {
          chipImages.add("$imageString$i.png");
        } else {
          chipImages.add("$imageString$i-1.png");
        }
      }
    } else {
      for (int i = 7; i < 13; i++) {
        if (!chosenChipFormatted.contains(i)) {
          chipImages.add("$imageString$i.png");
        } else {
          chipImages.add("$imageString$i-1.png");
        }
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            _buildChip(chipImages[0]),
            SizedBox(width: 12.w),
            _buildChip(chipImages[1]),
            SizedBox(width: 12.w),
            _buildChip(chipImages[2]),
          ],
        ),
        SizedBox(height: 18.h),
        Row(
          children: [
            _buildChip(chipImages[3]),
            SizedBox(width: 12.w),
            _buildChip(chipImages[4]),
            SizedBox(width: 12.w),
            _buildChip(chipImages[5]),
          ],
        ),
      ],
    );
  }

  // MARK: - 칩 빌드 함수
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

  // MARK: - 리뷰 내용
  Widget _reviewContent(String title, String sender, int rating, bool isNew) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isNew ? 16.h : 36.h),
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
            padding: EdgeInsets.only(left: 55.0.w),
            child: Text(
              "총점",
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

  // MARK: - NEW 배지
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

  // MARK: - 별점 표시
  Widget _starRating(int rating) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w),
      child: Row(
        children: List.generate(5, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index == 4 ? 0.w : 6.w),
            child: SizedBox(
              width: 17.w,
              height: 17.h,
              child: Image.asset(
                index < rating ? ImagePath.starSelected : ImagePath.star,
              ),
            ),
          );
        }),
      ),
    );
  }

  // MARK: - 삭제 확인 팝업창 표시
  void _showDeleteConfirmationDialog(BuildContext context) {
    ProfileReviewViewModel viewModel =
        Provider.of<ProfileReviewViewModel>(context, listen: false);
    UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
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
              context.pop();
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
              viewModel.deleteSelectedReviews(userViewModel.uid!);
              context.pop();
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
}
