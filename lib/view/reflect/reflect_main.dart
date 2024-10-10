import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/reflect/reflect_select_diary_question.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/reflect/reflect_view_model.dart';
import 'package:provider/provider.dart';

class ReflectMain extends StatelessWidget {
  const ReflectMain({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ReflectViewModel>(context);

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
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  left: 27.w,
                  right: 26.w,
                  bottom: 28.h,
                ),
                color: UsedColor.bg_color,
                child: Column(
                  children: [
                    SizedBox(height: 28.h),
                    _myRecordSection(context),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImagePath.reflectDiary,
                          width: 28.w,
                          height: 28.h,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          '일기를 작성하면 등급을 올릴 수 있어요!',
                          style: AppTextStyles.PR_M_13.copyWith(
                            color: UsedColor.text_4,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _diaryListContainer(context, viewModel),
                  ],
                ),
              ),
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
          header(title: '성찰', back: null),
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

  Widget _myRecordSection(BuildContext context) {
    return Container(
      width: 340.w,
      height: 130.h,
      padding: EdgeInsets.only(
        left: 28.w,
        right: 28.w,
        top: 20.h,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.r),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '나의 기록',
                style: AppTextStyles.PR_SB_20.copyWith(
                  color: UsedColor.charcoal_black,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                '00개 작성',
                style: AppTextStyles.PR_M_14.copyWith(
                  color: UsedColor.text_3,
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  context.goNamed('reflectRecordMore');
                },
                child: Text(
                  '더보기 >',
                  style: AppTextStyles.PR_M_14.copyWith(
                    color: UsedColor.text_4,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            radius: 45.w,
            backgroundColor: Colors.transparent,
            child: Image.asset(ImagePath.cogySelect),
          ),
        ],
      ),
    );
  }

  Widget _diaryListContainer(BuildContext context, ReflectViewModel viewModel) {
    return Container(
      width: 340.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 19.h,
              left: 26.w,
              right: 26.w,
              bottom: 20.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '작성 가능한 일기',
                  style: AppTextStyles.PR_SB_18.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.goNamed('reflectDiaryMore');
                  },
                  child: Text(
                    '더보기 >',
                    style: AppTextStyles.PR_M_14.copyWith(
                      color: UsedColor.text_4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.h,
            thickness: 0.3.h,
            color: UsedColor.line,
          ),
          _diaryList(context, viewModel),
        ],
      ),
    );
  }

  Widget _diaryList(BuildContext context, ReflectViewModel viewModel) {
    final diaryEntries = viewModel.availableEntries;

    return Column(
      children: diaryEntries.asMap().entries.map((entry) {
        int index = entry.key;
        var data = entry.value;
        bool isLast = index == diaryEntries.length - 1;

        return Column(
          children: [
            _diaryEntry(
              context: context,
              title: data['title']!,
              date: data['date']!,
            ),
            if (!isLast)
              Divider(
                height: 0.h,
                thickness: 0.3.h,
                color: UsedColor.line,
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _diaryEntry({
    required BuildContext context,
    required String title,
    required String date,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: 28.h,
        bottom: 28.h,
        left: 28.w,
        right: 25.w,
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
              Text(
                date,
                style: AppTextStyles.PR_SB_14.copyWith(
                  color: UsedColor.text_3,
                ),
              ),
            ],
          ),
          _buildWriteDiaryButton(context),
        ],
      ),
    );
  }

  Widget _buildWriteDiaryButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(
          'reflectSelectDiaryQuestion',
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
