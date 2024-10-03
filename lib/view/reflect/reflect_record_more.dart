import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/reflect/reflect_view_model.dart';
import 'package:provider/provider.dart';

class ReflectRecordMore extends StatelessWidget {
  const ReflectRecordMore({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ReflectViewModel>(context);

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
                top: 18.h,
                left: 20.w,
                right: 20.w,
                bottom: 52.h,
              ),
              child: _main(context, viewModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, ReflectViewModel viewModel) {
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
                  _showYearMonthPicker(context, viewModel); // 연월 선택 팝업
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
          SizedBox(height: 14.h),
          Divider(
            thickness: 0.5.h,
            height: 0,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  void _showYearMonthPicker(BuildContext context, ReflectViewModel viewModel) {
    // 팝업을 열 때 현재 연월을 기본값으로 설정
    viewModel.selectMonth(DateTime.now().month);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeNotifierProvider.value(
          value: viewModel,
          child: Consumer<ReflectViewModel>(
            builder: (context, viewModel, child) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 30.w,
                    right: 30.w,
                    top: 18.h,
                    bottom: 18.h,
                  ),
                  height: 165.h,
                  width: 245.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              viewModel.selectPreviousYear();
                            },
                            child: Image.asset(
                              ImagePath.reflectArrowLeft,
                              width: 4.5.w,
                              height: 9.h,
                            ),
                          ),
                          Text(
                            '${viewModel.selectedDate.year}',
                            style: AppTextStyles.SU_SB_16.copyWith(
                              color: UsedColor.charcoal_black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              viewModel.selectNextYear();
                            },
                            child: Image.asset(
                              ImagePath.reflectArrowRight,
                              width: 4.5.w,
                              height: 9.h,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 19.h),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16.w,
                          crossAxisSpacing: 44.h,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(12, (index) {
                            int month = index + 1;
                            bool isWritten = viewModel.isMonthWritten(
                                month, viewModel.selectedDate.year);

                            return GestureDetector(
                              onTap: isWritten
                                  ? () {
                                      viewModel.selectMonth(month);
                                      Navigator.pop(context);
                                    }
                                  : null, // 작성되지 않은 월은 클릭 비활성화
                              child: Container(
                                alignment: Alignment.center,
                                width: 23.w,
                                height: 23.h,
                                decoration: BoxDecoration(
                                  color: viewModel.selectedDate.month == month
                                      ? UsedColor.b_line
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: FittedBox(
                                  child: Text(
                                    '$month',
                                    style: AppTextStyles.PR_R_16.copyWith(
                                      color:
                                          viewModel.selectedDate.month == month
                                              ? UsedColor.charcoal_black
                                              : isWritten
                                                  ? UsedColor.charcoal_black
                                                  : UsedColor.text_4,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final viewModel = context.read<ReflectViewModel>();

        viewModel.resetSortOrder();
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
    return Consumer<ReflectViewModel>(
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

  Widget _main(BuildContext context, ReflectViewModel viewModel) {
    final filteredDiaryEntries = viewModel.filteredDiaryEntries;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: _buttons(context),
          ),
          SizedBox(height: 18.h),
          Column(
            children: filteredDiaryEntries.asMap().entries.map((entry) {
              int index = entry.key;
              var data = entry.value;
              bool isLast = index == filteredDiaryEntries.length - 1;

              return Column(
                children: [
                  _buildDiaryEntry(context, data, viewModel, index),
                  if (!isLast) SizedBox(height: 20.h),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // MARK:-개별 일기 항목
  Widget _buildDiaryEntry(BuildContext context, Map<String, String> entry,
      ReflectViewModel viewModel, int index) {
    String title = viewModel.getLimitedTitle(entry['title'] ?? '');

    return GestureDetector(
      onTap: () {
        context.goNamed(
          'reflectDiaryView',
        );
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
                    entry['date'] ?? '',
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
                    entry['content'] ?? '',
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
              top: 20.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () {
                  _showDeleteConfirmationDialog(context, index, viewModel);
                },
                child: Image.asset(ImagePath.close,
                    width: 20.w, height: 20.h, color: UsedColor.line),
              ),
            ),
        ],
      ),
    );
  }

  //MARK:- 삭제 확인 팝업창
  void _showDeleteConfirmationDialog(
      BuildContext context, int index, ReflectViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            width: 245.w,
            height: 109.h,
            padding: EdgeInsets.only(
              top: 19.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '해당 일기를 삭제하시겠습니까?',
                  style: AppTextStyles.PR_M_13.copyWith(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  '삭제한 일기는 다시 복구할 수 없습니다.',
                  style: AppTextStyles.PR_R_12.copyWith(
                    color: UsedColor.line,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Divider(thickness: 0.5.h, height: 0.h, color: UsedColor.line),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 9.h),
                          child: Center(
                            child: Text(
                              '취소',
                              style: AppTextStyles.PR_M_14.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 0.5.w,
                      height: 35.h,
                      color: UsedColor.line,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          viewModel.deleteDiaryEntry(index);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 9.h),
                          child: Center(
                            child: Text(
                              '삭제',
                              style: AppTextStyles.PR_M_14.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
