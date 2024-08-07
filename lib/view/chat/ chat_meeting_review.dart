import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:provider/provider.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';

class ChatMeetingReview extends StatelessWidget {
  ChatMeetingReview({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 58.h),
            child: _header(context),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                Provider.of<ChatViewModel>(context, listen: false).resetData();
                Provider.of<ChatViewModel>(context, listen: false).nextPage();
              },
              children: [
                _reviewPage(context, '닉네임1', '초보 클빙 모임', ImagePath.cogySelect),
                _reviewPage(context, '닉네임2', '초보 클빙 모임', ImagePath.piggySelect),
                _reviewPage(context, '닉네임3', '초보 클빙 모임', ImagePath.annumSelect),
                _finalPage(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewPage(BuildContext context, String nickname, String group,
      String profileImage) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12.h,
        left: 27.w,
        right: 26.w,
        bottom: 28.h,
      ),
      child: Center(
        child: Container(
          width: 340.w,
          // height: 708.h,
          padding: EdgeInsets.only(top: 12.h),
          decoration: BoxDecoration(
            color: UsedColor.image_card,
            borderRadius: BorderRadius.circular(29.r),
          ),
          child: Column(
            children: [
              _indicator(),
              _userInfo(nickname, group, profileImage),
              const Divider(),
              _ratingSection(context),
              _feedbackSection(context),
              _commentSection(context),
              // const Spacer(),
              _submitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _finalPage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 27.w,
        right: 26.w,
        bottom: 28.h,
      ),
      child: Center(
        child: Container(
          width: 340.w,
          padding: EdgeInsets.only(left: 37.w, right: 37.w),
          decoration: BoxDecoration(
            color: UsedColor.image_card,
            borderRadius: BorderRadius.circular(29.r),
          ),
          child: Column(
            children: [
              SizedBox(height: 195.h),
              Text(
                '후기가 모두에게 전송되었습니다.',
                style: AppTextStyles.PR_B_18.copyWith(
                  color: UsedColor.charcoal_black,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                '소중한 후기를 남겨 주셔서 감사합니다.\n(닉네임4) 님에게 60point가 지급될 예정입니다.',
                textAlign: TextAlign.center,
                style: AppTextStyles.PR_R_14.copyWith(
                  color: UsedColor.text_1,
                ),
              ),
              SizedBox(height: 44.h),
              Container(
                width: 208.w,
                height: 208.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    ImagePath.chatReviewLetter,
                    width: 117.w,
                    height: 117.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _indicator() {
    return Consumer<ChatViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            bool isSelected = viewModel.currentPage == index;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              width: 5.w,
              height: 5.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? UsedColor.main : UsedColor.b_line,
              ),
            );
          }),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '만남 후기 보내기'),
          // SizedBox(height: 21.h),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<ChatViewModel>(context, listen: false).resetData();
        context.pop();
      },
      child: Image.asset(
        ImagePath.close,
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  Widget _userInfo(String nickname, String group, String profileImage) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        Image.asset(
          profileImage,
          width: 80.w,
          height: 80.h,
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
    return Consumer<ChatViewModel>(builder: (context, viewModel, child) {
      return Column(
        children: [
          SizedBox(height: 12.h),
          Text(
            '‘닉네임’님과(와) 만남은 어떠셨나요?',
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
                child: GestureDetector(
                  onTap: () {
                    viewModel.setRating(index + 1);
                  },
                  child: Image.asset(
                    index < viewModel.rating
                        ? ImagePath.starSelected
                        : ImagePath.star,
                    width: 33.w,
                    height: 33.h,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 20.h),
        ],
      );
    });
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

    final List<String> negativeLabels = [
      '지각',
      '느린 응답',
      '불친절',
      '규칙 미준수',
      '약속 부도',
      '불순한 목적',
    ];

    return Consumer<ChatViewModel>(builder: (context, viewModel, child) {
      String questionText = '어떤 점이 좋으셨나요?';
      List<String> imageNames = positiveLabels;

      if (viewModel.rating > 0 && viewModel.rating < 3) {
        questionText = '어떤 점이 아쉬우셨나요?';
        imageNames = negativeLabels;
      }
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                questionText,
                style: AppTextStyles.PR_SB_15.copyWith(
                  color: UsedColor.charcoal_black,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '(복수 선택 가능)',
                style: AppTextStyles.PR_M_12.copyWith(
                  color: UsedColor.text_3,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 59.w, right: 59.w),
            child: Wrap(
              spacing: 24.w,
              runSpacing: 12.h,
              alignment: WrapAlignment.center,
              children: viewModel.images
                  .asMap()
                  .entries
                  .map((entry) =>
                      _imageChip(viewModel, entry.value, imageNames[entry.key]))
                  .toList(),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      );
    });
  }

  Widget _imageChip(ChatViewModel viewModel, String imageName, String label) {
    bool isSelected = viewModel.isSelected(imageName);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            viewModel.toggleChip(imageName);
          },
          child: Container(
            width: 58.w,
            height: 58.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? UsedColor.button : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                  isSelected
                      ? ImagePath.chatReviewSelected(imageName)
                      : ImagePath.chatReview(imageName),
                  width: 33.w,
                  height: 33.h,
                  fit: BoxFit.contain),
            ),
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
    );
  }

  Widget _commentSection(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '‘닉네임’님은 어떤 사람이었나요?',
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
                style: AppTextStyles.PR_R_13.copyWith(
                  color: UsedColor.text_5,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      '내가 본 상대방의 모습을 작성해 주세요.\n만남 평가 시 한 명당 20point를 지급해 드려요.\n(최소 20자 이상)',
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 14.h, horizontal: 16.w), // content padding 설정
                ),
                onChanged: (text) {
                  if (text.length >= 20 && text.length <= 100) {
                    viewModel.setComment(text);
                  } else {
                    viewModel.setComment('');
                  }
                },
              ),
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }

  // Submit Button
  Widget _submitButton(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: UsedColor.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 50.w),
                minimumSize: Size(154.w, 35.h),
              ),
              onPressed: viewModel.isReviewComplete
                  ? () {
                      if (viewModel.currentPage < 3) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                        viewModel.nextPage();
                      }
                    }
                  : null,
              child: Text(
                '전송하기',
                style: AppTextStyles.PR_SB_15.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        );
      },
    );
  }
}
