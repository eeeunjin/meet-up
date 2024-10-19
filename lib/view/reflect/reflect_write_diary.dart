import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/diary_model.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/reflect/reflect_view_model.dart';
import 'package:meet_up/view_model/reflect/reflect_write_diary_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ReflectWriteDiary extends StatelessWidget {
  const ReflectWriteDiary({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        final reflectWriteDiaryViewModel =
            Provider.of<ReflectWriteDiaryViewModel>(context, listen: false);
        reflectWriteDiaryViewModel.resetState();
        context.pop();
        context.pop();
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(title: '일기 쓰기', back: _back(context)),
          SizedBox(
            height: 14.h,
          ),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final reflectWriteDiaryViewModel =
            Provider.of<ReflectWriteDiaryViewModel>(context, listen: false);
        reflectWriteDiaryViewModel.resetState();
        context.pop();
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
    return Consumer<ReflectWriteDiaryViewModel>(
      builder: (context, viewModel, child) {
        final selectedQuestions = viewModel.getSelectedQuestions();

        final dateFormatter = DateFormat('yyyy.MM.dd. (E)', 'ko_KR');
        final timeFormatter = DateFormat('a h:mm');

        DateTime date;

        if (viewModel.scheduleModel != null) {
          date = viewModel.scheduleModel!.room_schedule!['date'].toDate();
        } else {
          date = DateTime.now();
        }

        final scheduleDate =
            '${dateFormatter.format(date)} ${timeFormatter.format(date).replaceFirst('AM', '오전').replaceFirst('PM', '오후')}';

        String title;

        if (viewModel.scheduleModel != null) {
          title = viewModel.scheduleModel!.room_schedule!['title'];
        } else {
          title = '';
        }

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
                    // 첫 번째 섹션 패딩
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
                                title,
                                style: AppTextStyles.PR_SB_16.copyWith(
                                  color: UsedColor.charcoal_black,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Text(
                                    scheduleDate,
                                    style: AppTextStyles.PR_M_14.copyWith(
                                      color: UsedColor.text_3,
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

                    // 선택된 질문 섹션
                    ...List.generate(selectedQuestions.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 24.w,
                          right: 24.w,
                        ),
                        child: _questionAnswerField(
                          context,
                          selectedQuestions.values.elementAt(index),
                          selectedQuestions.keys.elementAt(index),
                          viewModel,
                        ),
                      );
                    }),

                    // 질문 추가 버튼 (최대 3개까지 선택 가능)
                    if (selectedQuestions.length < 3) ...[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24.w,
                          right: 24.w,
                        ),
                        child: _addQuestionButton(context),
                      ),
                    ],

                    SizedBox(height: 24.h),
                    Divider(
                      thickness: 0.75.h,
                      height: 0.h,
                      color: UsedColor.b_line,
                    ),
                    SizedBox(height: 24.h),
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

                    // 별점 섹션
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 24.w,
                      ),
                      child: _ratingSection(viewModel),
                    ),

                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 24.w,
                        bottom: 24.h,
                      ),
                      child: _bottom(context, viewModel),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//MARK: - 질문 답변창
  Widget _questionAnswerField(
    BuildContext context,
    String question,
    int index,
    ReflectWriteDiaryViewModel viewModel,
  ) {
    logger.d(
        'question: $question, index: $index, answer: ${viewModel.answers[index]}');
    final TextEditingController controller = TextEditingController();
    controller.text =
        viewModel.answers[index] == null ? '' : viewModel.answers[index]!;

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
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TextField(
                minLines: 1,
                maxLines: 7,
                controller: controller,
                keyboardType: TextInputType.multiline,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(150), // 최대 150자까지 입력 가능
                ],
                onChanged: (value) {
                  viewModel.updateAnswer(index, value);
                },
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
            Positioned(
              top: 6.h,
              right: 7.w,
              child: GestureDetector(
                onTap: () => viewModel.removeQuestion(index),
                child: Image.asset(
                  ImagePath.reflectClose,
                  width: 25.w,
                  height: 25.h,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

//MARK: - 질문 추가 버튼
  Widget _addQuestionButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final viewModel =
            Provider.of<ReflectWriteDiaryViewModel>(context, listen: false);
        viewModel.resetSelectedImages();
        viewModel.setAddQuestion(true);
        if (viewModel.isFromDiaryMore) {
          context.goNamed('reflectSelectDiaryQuestion_diaryMore_add');
        } else {
          context.goNamed('reflectSelectDiaryQuestion_add');
        }
      },
      child: Center(
        child: Image.asset(
          ImagePath.plus,
          width: 62.w,
          height: 62.h,
        ),
      ),
    );
  }

//MARK: - 별점
  Widget _ratingSection(ReflectWriteDiaryViewModel viewModel) {
    final List<String> ratingQuestions = [
      '나는 어땠나요?',
      '상대는 어땠나요?',
      '우리는 어땠나요?',
      '재미있었나요?',
      '유익했나요?',
      '목적을 달성했나요?',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          (ratingQuestions.length / 3).ceil(),
          (blockIndex) {
            return Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child:
                  _ratingSectionBlock(blockIndex, viewModel, ratingQuestions),
            );
          },
        ),
        if (viewModel.allRatingsCompleted()) _totalRatingBlock(viewModel),
      ],
    );
  }

  Widget _ratingSectionBlock(int blockIndex,
      ReflectWriteDiaryViewModel viewModel, List<String> ratingQuestions) {
    int startIndex = blockIndex * 3;
    int endIndex = (blockIndex * 3 + 3) > ratingQuestions.length
        ? ratingQuestions.length
        : blockIndex * 3 + 3;

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
        children: List.generate(endIndex - startIndex, (index) {
          return Column(
            children: [
              _ratingQuestion(ratingQuestions[startIndex + index],
                  startIndex + index, viewModel),
              if (index != endIndex - startIndex - 1) const Divider(),
            ],
          );
        }),
      ),
    );
  }

  Widget _ratingQuestion(
      String question, int index, ReflectWriteDiaryViewModel viewModel) {
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
                child: GestureDetector(
                  onTap: () => viewModel.setRating(index, starIndex + 1),
                  child: Image.asset(
                    starIndex < viewModel.ratings[index]
                        ? ImagePath.starSelected
                        : ImagePath.star,
                    width: 22.w,
                    height: 22.h,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

//MARK: - 별점 총점
  Widget _totalRatingBlock(ReflectWriteDiaryViewModel viewModel) {
    int totalRating = viewModel.calculateTotalRating().round(); // 반올림하여 정수로 변환

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

//MARK: - bottom
  Widget _bottom(BuildContext context, ReflectWriteDiaryViewModel viewModel) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final reflectViewModel =
        Provider.of<ReflectViewModel>(context, listen: false);
    return GestureDetector(
      onTap: viewModel.canSubmit
          ? () async {
              final schedule = viewModel.scheduleModel!;
              DiaryModel diary = DiaryModel(
                diaryDocId: "",
                scheduleDocId: schedule.room_name,
                isPersonalSchedule: schedule.room_category == "",
                title: schedule.room_schedule!["title"],
                date: schedule.room_schedule!["date"],
                reviews: viewModel.answers.map((key, value) {
                  return MapEntry(key.toString(), value);
                }),
                meetingScores: viewModel.ratings,
              );

              await viewModel.createDiary(
                uid: userViewModel.uid!,
                diary: diary,
              );

              // 스케줄 업데이트
              var updatedSchedule = schedule;
              updatedSchedule.roomId = "diary";

              await viewModel.updateScheduleModel(
                uid: userViewModel.uid!,
                data: updatedSchedule,
              );

              context.pop();
              context.pop();
              reflectViewModel.resetSortOrder();
            }
          : null,
      child: Container(
        width: 292.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: viewModel.canSubmit ? UsedColor.button : UsedColor.button_g,
          borderRadius: BorderRadius.circular(18.5.r),
        ),
        alignment: Alignment.center,
        child: Text(
          '저장하기',
          style: AppTextStyles.PR_SB_20.copyWith(
            color: viewModel.canSubmit ? Colors.white : UsedColor.text_2,
          ),
        ),
      ),
    );
  }
}
