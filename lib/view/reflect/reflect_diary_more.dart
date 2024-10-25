import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/reflect/reflect_view_model.dart';
import 'package:meet_up/view_model/reflect/reflect_write_diary_view_model.dart';
import 'package:provider/provider.dart';

class ReflectDiaryMore extends StatelessWidget {
  const ReflectDiaryMore({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ReflectViewModel>(context);
    final availableEntries = viewModel.availableEntries;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 58.h),
            child: _header(context),
          ),
          availableEntries.isEmpty
              ? _emptyStateMode()
              : Expanded(
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

  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(title: '작성 가능한 일기', back: _back(context)),
          SizedBox(height: 17.h),
          Divider(
            thickness: 0.3.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final viewModel = Provider.of<ReflectViewModel>(context, listen: false);

        viewModel.resetSortOrder();

        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  Widget _main(BuildContext context, ReflectViewModel viewModel) {
    final availableEntries = viewModel.availableEntries;

    if (availableEntries.isEmpty) {
      return _emptyStateMode(); // 일기가 없을 때 빈 상태 화면 표시
    }

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
            children: availableEntries.asMap().entries.map((entry) {
              int index = entry.key;
              var data = entry.value;
              bool isLast = index == availableEntries.length - 1;

              String scheduleDate = "";
              if (data.room_schedule!['date'] != null) {
                final dateFormatter = DateFormat('yyyy.MM.dd. (E)', 'ko_KR');
                final timeFormatter = DateFormat('a h:mm');

                DateTime date = data.room_schedule!['date'].toDate();
                scheduleDate =
                    '${dateFormatter.format(date)} ${timeFormatter.format(date).replaceFirst('AM', '오전').replaceFirst('PM', '오후')}';
              }

              return Column(
                children: [
                  _diaryEntryContainer(
                    context,
                    data.room_schedule!["title"],
                    scheduleDate,
                    data,
                  ),
                  if (!isLast) SizedBox(height: 20.h),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _emptyStateMode() {
    return Expanded(
      child: Container(
        color: UsedColor.bg_color,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 229.h),
            Image.asset(
              ImagePath.reflectNoneDiary,
              width: 50.w,
              height: 50.h,
            ),
            SizedBox(height: 16.h),
            Text(
              '작성 가능한 일기가 없습니다.',
              style: AppTextStyles.PR_R_17.copyWith(
                color: UsedColor.text_2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              '만남을 가진 후 일기를 작성해 보세요!',
              style: AppTextStyles.PR_R_16.copyWith(
                color: UsedColor.text_5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // MARK:-일기 항목
  Widget _diaryEntryContainer(
      BuildContext context, String title, String date, RoomModel schedule) {
    return Container(
      width: 353.w,
      height: 88.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: _diaryEntry(context, title, date, schedule),
    );
  }

// MARK:- 버튼
  Widget _buttons(BuildContext context) {
    return Consumer<ReflectViewModel>(
      builder: (context, viewModel, child) {
        double buttonWidth = viewModel.isSortedByRecent ? 54.w : 64.w;

        return SizedBox(
          height: 22.h,
          width: buttonWidth,
          child: GestureDetector(
            onTap: () {
              viewModel.sortAvailableEntriesByDate();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              child: Text(
                viewModel.isSortedByRecent ? '최근순' : '오래된순',
                style: AppTextStyles.PR_M_12.copyWith(
                  color: UsedColor.violet,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // MARK:-개별 일기 항목
  Widget _diaryEntry(
      BuildContext context, String title, String date, RoomModel schedule) {
    return Row(
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
            Text(
              date,
              style: AppTextStyles.PR_M_14.copyWith(
                color: UsedColor.text_3,
              ),
            ),
          ],
        ),
        _buildWriteDiaryButton(context, schedule),
      ],
    );
  }

  // MARK:-일기 쓰기 버튼
  Widget _buildWriteDiaryButton(BuildContext context, RoomModel schedule) {
    return GestureDetector(
      onTap: () {
        final ReflectWriteDiaryViewModel viewModel =
            Provider.of<ReflectWriteDiaryViewModel>(context, listen: false);
        viewModel.resetState();
        viewModel.setIsFromDiaryMore(true);
        viewModel.setScheduleModel(schedule);
        context.goNamed(
          'reflectSelectDiaryQuestion_diaryMore',
        );
      },
      child: Container(
        width: 77.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: UsedColor.image_card,
          borderRadius: BorderRadius.circular(13.88.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: Center(
          child: Text(
            '일기 쓰기',
            style: AppTextStyles.SU_R_12.copyWith(
              color: UsedColor.charcoal_black,
            ),
          ),
        ),
      ),
    );
  }
}
