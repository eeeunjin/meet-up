import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/view/reflect/reflect_select_diary_question.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/reflect/reflect_view_model.dart';
import 'package:provider/provider.dart';

class ReflectDiaryDetail extends StatelessWidget {
  const ReflectDiaryDetail({super.key});

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
          Expanded(child: _main(context)),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(title: '일기 상세 보기', back: _back(context)),
          SizedBox(
            height: 17.h,
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

  Widget _main(BuildContext context) {
    const String meetingTitle = '초보 클럽 모임';
    const String meetingDate = '2024.02.07.(수) 오후 7:30';
    final List<String> selectedQuestions = [
      '어떤 만남이었는지 설명한다면?',
    ];
    const String answer =
        '즐겁고 보람찬 만남\n스트레이 키즈 노래 안 틀어 준 만남\n스트레이 키즈 노래 안 틀어 준 만남\n스트레이 키즈 노래 안 틀어 준 만남\n스트레이 키즈 노래 안 틀어 준 만남\n스트레이 키즈 노래 안 틀어 준 만남\n스트레이 키즈 노래 안 틀어 준 만남\n';

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 16.h,
          left: 27.w,
          right: 26.w,
          bottom: 56.h,
        ),
        child: Center(
          child: Container(
            width: 340.w,
            decoration: BoxDecoration(
              color: UsedColor.image_card,
              borderRadius: BorderRadius.circular(29.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 24.h,
                    bottom: 24.h,
                    left: 24.w,
                    right: 24.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meetingTitle,
                            style: AppTextStyles.PR_SB_16.copyWith(
                              color: UsedColor.charcoal_black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text(
                                meetingDate,
                                style: AppTextStyles.PR_M_14.copyWith(
                                  color: UsedColor.text_3,
                                ),
                              ),
                              SizedBox(width: 40.w),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  '만남 상세 보기 >',
                                  style: AppTextStyles.PR_M_13.copyWith(
                                    color: UsedColor.text_4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.75.h,
                  height: 0.h,
                  color: UsedColor.b_line,
                ),
                SizedBox(height: 24.h),
                ...List.generate(selectedQuestions.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 24.w,
                      right: 24.w,
                    ),
                    child: _questionAnswerField(
                      context,
                      selectedQuestions[index],
                      answer,
                    ),
                  );
                }),
                Center(
                  child: Text(
                    '만남을 되돌아 볼까요?',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.PR_SB_16.copyWith(
                      color: UsedColor.charcoal_black,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(
                    left: 24.w,
                    right: 24.w,
                  ),
                  child: _ratingSection(),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //MARK: - 질문 답변창
  Widget _questionAnswerField(
      BuildContext context, String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            question,
            style: AppTextStyles.PR_SB_16.copyWith(
              color: UsedColor.charcoal_black,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          width: 292.w,
          height: 172.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 18.h,
              bottom: 18.h,
              left: 17.w,
              right: 17.w,
            ),
            child: Text(
              answer,
              style: AppTextStyles.PR_R_13.copyWith(
                color: UsedColor.text_5,
                height: 4.h,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  //MARK: - 별점 섹션
  Widget _ratingSection() {
    final List<Map<String, int>> ratingData = [
      {'나는 어땠나요?': 4},
      {'상대는 어땠나요?': 4},
      {'우리는 어땠나요?': 3},
      {'재미있었나요?': 5},
      {'유익했나요?': 5},
      {'목적을 달성했나요?': 4},
    ];
    const totalRating = 4.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          (ratingData.length / 3).ceil(),
          (blockIndex) {
            int startIndex = blockIndex * 3;
            int endIndex = (blockIndex * 3 + 3) > ratingData.length
                ? ratingData.length
                : blockIndex * 3 + 3;

            return Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child:
                  _ratingSectionBlock(ratingData.sublist(startIndex, endIndex)),
            );
          },
        ),
        _totalRatingBlock(totalRating),
      ],
    );
  }

  Widget _ratingSectionBlock(List<Map<String, int>> ratingBlock) {
    return Container(
      width: 292.w,
      height: 124.h,
      padding: EdgeInsets.only(
        top: 12.h,
        bottom: 12.h,
        left: 15.w,
        right: 15.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: ratingBlock.map((ratingItem) {
          String question = ratingItem.keys.first;
          int rating = ratingItem.values.first;
          return Column(
            children: [
              _ratingQuestion(question, rating),
              if (ratingItem != ratingBlock.last) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _ratingQuestion(String question, int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            question,
            style: AppTextStyles.PR_SB_13.copyWith(
              color: UsedColor.text_3,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(5, (starIndex) {
              return Padding(
                padding: EdgeInsets.only(right: starIndex != 4 ? 9.w : 0),
                child: Image.asset(
                  starIndex < rating ? ImagePath.starSelected : ImagePath.star,
                  width: 22.w,
                  height: 22.h,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  //MARK: - 별점 총점
  Widget _totalRatingBlock(double totalRating) {
    return Container(
      width: 292.w,
      height: 83.h,
      padding: EdgeInsets.only(
        top: 14.h,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: index != 4 ? 9.w : 0),
                  child: Image.asset(
                    index < totalRating.round()
                        ? ImagePath.starSelected
                        : ImagePath.star,
                    width: 22.w,
                    height: 22.h,
                  ),
                );
              }),
            ),
            SizedBox(height: 8.h),
            RichText(
              text: TextSpan(
                text: '만남의 총점은 ',
                style: AppTextStyles.PR_SB_13.copyWith(
                  color: UsedColor.text_4,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '$totalRating점',
                    style: AppTextStyles.PR_SB_18.copyWith(
                      color: UsedColor.text_2,
                    ),
                  ),
                  TextSpan(
                    text: ' 입니다!',
                    style: AppTextStyles.PR_SB_13.copyWith(
                      color: UsedColor.text_4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
