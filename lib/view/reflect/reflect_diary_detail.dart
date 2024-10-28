import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/model/diary_model.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/reflect/reflect_record_view_model.dart';
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
    final reflectRecordViewModel =
        Provider.of<ReflectRecordViewModel>(context, listen: false);
    DiaryModel selectedDiary = reflectRecordViewModel.selectedDiary!;
    String meetingTitle = selectedDiary.title;
    DateFormat dateFormatter = DateFormat('yyyy.MM.dd.(E)', 'ko_KR');
    DateFormat timeFormatter = DateFormat('a hh:mm', 'ko_KR');
    DateTime dirayDate = selectedDiary.date.toDate();
    // AM/PM 한국어로 변환
    String meetingDate =
        '${dateFormatter.format(dirayDate)} ${timeFormatter.format(dirayDate).replaceFirst('AM', '오전').replaceFirst('PM', '오후')}';

    final questions = [
      '어떤 만남이었는지 설명한다면?',
      '해당 만남에서 좋았던 점은?',
      '해당 만남에서 아쉬웠던 점은?',
      '해당 만남을 통해 새로 알게 된 점은?',
      '해당 만남을 한 줄로 표현한다면?'
    ];
    final indexes =
        selectedDiary.reviews.keys.map((e) => int.parse(e)).toList();

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
                  child: Column(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            meetingDate,
                            style: AppTextStyles.PR_M_14.copyWith(
                              color: UsedColor.text_3,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              selectedDiary.isPersonalSchedule
                                  ? "개인 일정"
                                  : '그로윗 일정',
                              style: AppTextStyles.PR_SB_13.copyWith(
                                color: UsedColor.text_5,
                              ),
                            ),
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
                ...List.from(indexes).map(
                  (index) {
                    final question = questions[index];
                    final answer = selectedDiary.reviews[index.toString()]!;
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 24.w,
                      ),
                      child: _questionAnswerField(
                        context,
                        question,
                        answer,
                      ),
                    );
                  },
                ),
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
                  child: _ratingSection(selectedDiary),
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
    final TextEditingController controller = TextEditingController();
    controller.text = answer;
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: TextField(
            readOnly: true,
            minLines: 1,
            maxLines: 7,
            controller: controller,
            keyboardType: TextInputType.multiline,
            inputFormatters: [
              LengthLimitingTextInputFormatter(150), // 최대 150자까지 입력 가능
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: 18.h,
                bottom: 18.h,
                left: 17.w,
                right: 18.w,
              ),
            ),
            style: AppTextStyles.PR_R_13.copyWith(
              color: UsedColor.text_5,
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  //MARK: - 별점 섹션
  Widget _ratingSection(DiaryModel diary) {
    final meetingRating = diary.meetingScores;
    final List<Map<String, int>> ratingData = [
      {'나는 어땠나요?': meetingRating[0]},
      {'상대는 어땠나요?': meetingRating[1]},
      {'우리는 어땠나요?': meetingRating[2]},
      {'재미있었나요?': meetingRating[3]},
      {'유익했나요?': meetingRating[4]},
      {'목적을 달성했나요?': meetingRating[5]},
    ];
    int totalratingSum = ratingData
        .map((ratingItem) => ratingItem.values.first)
        .reduce((value, element) => value + element);
    int totalratingMean = (totalratingSum / ratingData.length).round();

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
        _totalRatingBlock(totalratingMean),
      ],
    );
  }

  Widget _ratingSectionBlock(List<Map<String, int>> ratingBlock) {
    return Container(
      width: 292.w,
      height: 130.h,
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
  Widget _totalRatingBlock(int totalRating) {
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
                    index < totalRating
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
