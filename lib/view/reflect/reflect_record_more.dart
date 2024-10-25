import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/diary_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/reflect/reflect_record_view_model.dart';
import 'package:meet_up/view_model/reflect/reflect_write_diary_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ReflectRecordMore extends StatelessWidget {
  const ReflectRecordMore({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ReflectRecordViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        viewModel.resetAll();
        context.pop();
      },
      child: StreamBuilder<QuerySnapshot<Object?>>(
          stream: viewModel.getMyDiaryEntriesStream(uid: userViewModel.uid!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final diaryEntries = snapshot.data?.docs.map(
              (e) {
                return DiaryModel.fromJson(e.data() as Map<String, dynamic>);
              },
            ).toList();

            if (diaryEntries != null) {
              viewModel.setMyDiaryEntries(diaryEntries);
            }

            return Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 58.h),
                    child: _header(context, viewModel),
                  ),
                  Expanded(
                    child: Container(
                      color: UsedColor.bg_color,
                      padding: EdgeInsets.only(
                        left: 20.w,
                        right: 20.w,
                      ),
                      child: _main(context),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _header(BuildContext context, ReflectRecordViewModel viewModel) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: _back(context),
              ),
              GestureDetector(
                onTap: () {
                  viewModel.initializeDisplayedDate();
                  _showYearMonthPicker(context); // 연월 선택 팝업
                },
                child: Row(
                  children: [
                    Text(
                      DateFormat('yyyy년 M월').format(viewModel.selectedDate),
                      style: AppTextStyles.SU_R_20.copyWith(
                        color: UsedColor.text_3,
                      ),
                    ),
                    SizedBox(width: 11.5.w),
                    Image.asset(
                      ImagePath.reflectArrow,
                      width: 15.w,
                      height: 7.5.h,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
            ],
          ),
          SizedBox(height: 20.h),
          Divider(
            thickness: 0.5.h,
            height: 0,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

// MARK:-달력 팝업
  void _showYearMonthPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            height: 202.h,
            width: 300.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Consumer<ReflectRecordViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  children: [
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            logger.d('이전 년도 선택');
                            viewModel.selectPreviousYear();
                          },
                          child: Container(
                            height: 30.h,
                            width: 100.w,
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              ImagePath.reflectArrowLeft,
                              width: 8.w,
                              height: 12.h,
                            ),
                          ),
                        ),
                        DefaultTextStyle(
                          style: AppTextStyles.SU_SB_16.copyWith(
                            color: UsedColor.charcoal_black,
                          ),
                          child: Text(
                            '${viewModel.displayedDate.year}',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            logger.d('이후 년도 선택');
                            viewModel.selectNextYear();
                          },
                          child: Container(
                            height: 30.h,
                            width: 100.w,
                            color: Colors.transparent,
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              ImagePath.reflectArrowRight,
                              width: 8.w,
                              height: 12.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    // 월 선택 UI
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 16.h,
                        crossAxisSpacing: 42.w,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(12, (index) {
                          int month = index + 1;
                          bool isWritten = viewModel.isMonthWritten(
                              month, viewModel.displayedDate.year);

                          return GestureDetector(
                            onTap: isWritten
                                ? () {
                                    viewModel.selectMonth(month);
                                    viewModel.confirmSelectedDate();
                                    context.pop();
                                  }
                                : null,
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: viewModel.displayedDate.month == month &&
                                        viewModel.displayedDate.year ==
                                            viewModel.selectedDate.year
                                    ? UsedColor.b_line
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: FittedBox(
                                child: DefaultTextStyle(
                                  style: AppTextStyles.PR_R_16.copyWith(
                                    color: viewModel.displayedDate.month ==
                                                month &&
                                            viewModel.displayedDate.year ==
                                                viewModel.selectedDate.year
                                        ? Colors.black
                                        : isWritten
                                            ? Colors.black
                                            : Colors.grey[400],
                                  ),
                                  child: Text('$month'),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final viewModel =
            Provider.of<ReflectRecordViewModel>(context, listen: false);

        viewModel.resetAll();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  // MARK:-버튼
  Widget _buttons(BuildContext context) {
    return Consumer<ReflectRecordViewModel>(
      builder: (context, viewModel, child) {
        double buttonWidth = viewModel.isSortedByRecent ? 54.w : 64.w;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 22.h,
              width: buttonWidth,
              child: GestureDetector(
                onTap: () {
                  viewModel.sortMyDiaryEntriesByDate();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  child: Text(
                    viewModel.isSortedByRecent ? '최근순' : '오래된순',
                    style: AppTextStyles.PR_M_12.copyWith(
                      color: UsedColor.violet,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 7.w),
            SizedBox(
              height: 22.h,
              width: 43.w,
              child: GestureDetector(
                onTap: () {
                  viewModel.toggleEditMode();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  child: Text(
                    viewModel.isEditMode ? '닫기' : '편집',
                    style: AppTextStyles.PR_M_12.copyWith(
                      color: UsedColor.violet,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _main(BuildContext context) {
    final viewModel = Provider.of<ReflectRecordViewModel>(context);
    final filteredDiaryEntries = viewModel.filteredDiaryEntries; // 필터링된 일기 목록

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 18.h,
          ),
          if (filteredDiaryEntries.isNotEmpty)
            Align(
              alignment: Alignment.topRight,
              child: _buttons(context),
            ),
          SizedBox(height: 18.h),
          // 일기가 없을 때 빈 상태 화면 표시
          filteredDiaryEntries.isEmpty
              ? _emptyStateMode(viewModel)
              :
              // 일기가 있는 경우, 일기 목록을 보여줌
              Column(
                  children: filteredDiaryEntries.asMap().entries.map((entry) {
                    int index = entry.key;
                    var data = entry.value;
                    bool isLast = index == filteredDiaryEntries.length - 1;

                    return Column(
                      children: [
                        _buildDiaryEntry(
                          context,
                          data,
                          viewModel,
                          index,
                        ),
                        if (!isLast) SizedBox(height: 20.h),
                      ],
                    );
                  }).toList(),
                ),
          SizedBox(height: 18.h),
        ],
      ),
    );
  }

  // 작성된 일기가 없는 상태
  Widget _emptyStateMode(ReflectRecordViewModel viewModel) {
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
            '작성된 일기가 없습니다',
            style: AppTextStyles.PR_R_17.copyWith(
              color: UsedColor.text_5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // MARK:-개별 일기 항목
  Widget _buildDiaryEntry(
    BuildContext context,
    DiaryModel entry,
    ReflectRecordViewModel viewModel,
    int index,
  ) {
    String title = viewModel.getLimitedTitle(entry.title);
    DateFormat dateFormatter = DateFormat('yyyy.MM.dd. (E)', 'ko_KR');
    DateFormat timeFormatter = DateFormat('a h:mm');
    String date =
        '${dateFormatter.format(entry.date.toDate())} ${timeFormatter.format(entry.date.toDate()).replaceFirst('AM', '오전').replaceFirst('PM', '오후')}';
    String content = "";
    for (var review in entry.reviews.values) {
      content += "$review ";
    }

    return GestureDetector(
      onTap: () {
        viewModel.setSelectedDiary(entry);
        context.goNamed('reflectDiaryDetails');
      },
      child: Stack(
        children: [
          Container(
            width: 353.w,
            height: 161.h,
            padding: EdgeInsets.only(
              left: 6.w,
              right: 6.w,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.h,
                    left: 14.w,
                  ),
                  child: Text(
                    title,
                    style: AppTextStyles.PR_SB_17.copyWith(
                      color: UsedColor.charcoal_black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 14.w,
                  ),
                  child: Text(
                    date,
                    style: AppTextStyles.PR_M_15.copyWith(
                      color: UsedColor.text_3,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Divider(
                  thickness: 0.75.h,
                  height: 0.h,
                  color: UsedColor.button_g,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 14.w,
                    right: 14.w,
                    bottom: 16.h,
                  ),
                  child: Text(
                    content,
                    style: AppTextStyles.PR_M_14.copyWith(
                      color: UsedColor.line,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (viewModel.isEditMode)
            Positioned(
              top: 13.h,
              right: 15.w,
              child: GestureDetector(
                onTap: () {
                  _showDeleteConfirmationDialog(context, entry);
                },
                child: SizedBox(
                  width: 25.w,
                  height: 25.h,
                  child: Image.asset(
                    ImagePath.close,
                    color: UsedColor.line,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // MARK: - 일기 삭제
  void _showDeleteConfirmationDialog(BuildContext context, DiaryModel entry) {
    final ReflectRecordViewModel reflectRecordViewModel =
        Provider.of<ReflectRecordViewModel>(context, listen: false);
    final UserViewModel userViewModel =
        Provider.of<UserViewModel>(context, listen: false);
    final ReflectWriteDiaryViewModel reflectWriteDiaryViewModel =
        Provider.of<ReflectWriteDiaryViewModel>(context, listen: false);

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          '해당 일기를 삭제하시겠습니까?',
          style: AppTextStyles.PR_M_13.copyWith(
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          children: [
            SizedBox(
              height: 8.h,
            ),
            Text(
              '삭제한 일기는 다시 복구할 수 없습니다.',
              style: AppTextStyles.PR_R_12.copyWith(
                color: UsedColor.text_3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              context.pop();
            },
            child: Text(
              "취소",
              style: AppTextStyles.PR_M_14.copyWith(color: Colors.black),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              // schedule의 roomId 정보 업데이트
              await reflectWriteDiaryViewModel.updateScheduleModelbyMapData(
                uid: userViewModel.uid!,
                scheduleId: entry.scheduleDocId,
                data: {
                  "roomId": "",
                },
              );

              // myDiary 정보 삭제
              await reflectRecordViewModel.deleteMyDiaryEntry(
                userViewModel.uid!,
                entry.diaryDocId,
              );

              context.pop();
            },
            child: Text(
              "삭제",
              style: AppTextStyles.PR_M_14.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
