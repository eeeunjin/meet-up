import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ReflectMain extends StatelessWidget {
  const ReflectMain({super.key});

  @override
  Widget build(BuildContext context) {
    final reflectViewModel =
        Provider.of<ReflectViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot<Object?>>(
        stream: reflectViewModel.getMyScheduleStream(uid: userViewModel.uid!),
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

          List<RoomModel> mySchedules = snapshot.data?.docs.map(
                (e) {
                  return RoomModel.fromJson(e.data() as Map<String, dynamic>);
                },
              ).toList() ??
              [];

          if (mySchedules.isNotEmpty) {
            reflectViewModel.setAvailableEntries(mySchedules);
          }

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
                  child: Container(
                    color: UsedColor.bg_color,
                    padding: EdgeInsets.only(
                      left: 27.w,
                      right: 26.w,
                      bottom: 28.h,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 28.h),
                        _myRecordSection(context),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 28.w,
                              height: 28.h,
                              child: Image.asset(
                                ImagePath.reflectDiary,
                              ),
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
                        _diaryListContainer(context, reflectViewModel),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
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
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 24.h,
                width: 80.w,
                child: Text(
                  '나의 기록',
                  style: AppTextStyles.PR_SB_20.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
              ),
              SizedBox(height: 35.h),
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

  Widget _diaryListContainer(
    BuildContext context,
    ReflectViewModel viewModel,
  ) {
    return Container(
      width: 340.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          if (viewModel.availableEntries.isNotEmpty)
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

  Widget _diaryList(
    BuildContext context,
    ReflectViewModel viewModel,
  ) {
    final diaryEntries = viewModel.availableEntries;

    return diaryEntries.isEmpty
        ? const SizedBox.shrink()
        : Column(
            children: diaryEntries.asMap().entries.map((entry) {
              int index = entry.key;
              var data = entry.value;
              bool isLast = index == diaryEntries.length - 1;
              if (index > 2) {
                return const SizedBox.shrink();
              }

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
                  _diaryEntry(
                    context: context,
                    title: data.room_schedule!['title']!,
                    date: scheduleDate,
                    schedule: data,
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
    required RoomModel schedule,
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
                style: AppTextStyles.PR_M_14.copyWith(
                  color: UsedColor.text_3,
                ),
              ),
            ],
          ),
          _buildWriteDiaryButton(
            context,
            schedule,
          ),
        ],
      ),
    );
  }

  Widget _buildWriteDiaryButton(
    BuildContext context,
    RoomModel schedule,
  ) {
    return GestureDetector(
      onTap: () {
        final ReflectWriteDiaryViewModel viewModel =
            Provider.of<ReflectWriteDiaryViewModel>(context, listen: false);
        viewModel.resetState();
        viewModel.setIsFromDiaryMore(false);
        viewModel.setScheduleModel(schedule);
        context.goNamed(
          'reflectSelectDiaryQuestion',
        );
      },
      child: Container(
        width: 80.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: UsedColor.image_card,
          borderRadius: BorderRadius.circular(13.88.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: Center(
          child: Text(
            '일기 쓰기',
            style: AppTextStyles.SU_M_12.copyWith(
              color: UsedColor.charcoal_black,
            ),
          ),
        ),
      ),
    );
  }
}
