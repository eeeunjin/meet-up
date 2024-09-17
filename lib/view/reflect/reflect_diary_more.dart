import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/reflect/reflect_writing_diary.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/reflect/reflect_view_model.dart';
import 'package:provider/provider.dart';

class ReflectDiaryMore extends StatelessWidget {
  const ReflectDiaryMore({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider를 통해 ViewModel을 가져옴
    final viewModel = Provider.of<ReflectViewModel>(context);

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
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ReflectViewModel>().reset();
        Navigator.of(context).pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  // MARK:-메인 리스트 부분 - 작성 가능한 일기와 내가 작성한 일기
  Widget _main(BuildContext context, ReflectViewModel viewModel) {
    final availableEntries = viewModel.availableEntries;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: _buttons(context, viewModel),
          ),
          SizedBox(height: 18.h),
          Column(
            children: availableEntries.asMap().entries.map((entry) {
              int index = entry.key;
              var data = entry.value;
              bool isLast = index == availableEntries.length - 1;

              return Column(
                children: [
                  _diaryEntryContainer(context, data['title']!, data['date']!),
                  if (!isLast) SizedBox(height: 20.h),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 일기 항목을 감싸는 컨테이너
  Widget _diaryEntryContainer(BuildContext context, String title, String date) {
    return Container(
      width: 353.w,
      height: 88.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: _diaryEntry(context, title, date),
    );
  }

  // 최근순 버튼이 들어가는 부분 - 우측 상단에 위치
  Widget _buttons(BuildContext context, ReflectViewModel viewModel) {
    return SizedBox(
      height: 22.h,
      width: 54.w,
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
            '최근순',
            style: AppTextStyles.PR_M_12.copyWith(
              color: UsedColor.violet,
            ),
          ),
        ),
      ),
    );
  }

  // 개별 일기 항목 위젯
  Widget _diaryEntry(BuildContext context, String title, String date) {
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
        _buildWriteDiaryButton(context),
      ],
    );
  }

  // 일기 쓰기 버튼
  Widget _buildWriteDiaryButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ReflectWritingDiary(),
          ),
        );
      },
      child: Container(
        width: 77.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3FD),
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
