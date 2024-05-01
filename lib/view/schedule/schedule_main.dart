import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/view_model/schedule/schedule_main_view_model.dart';
import 'package:provider/provider.dart';

class ScheduleMain extends StatelessWidget {
  const ScheduleMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (Platform.isIOS)
            _header(context)
          else if (Platform.isAndroid)
            Padding(
              padding: EdgeInsets.only(
                top: 58.h,
              ),
              child: _header(context),
            ),
          Expanded(child: _main(context)),
        ],
      ),
      // 개인 일정 추가 플로팅액션 버튼
      floatingActionButton: FloatingActionButton(
        heroTag: null, // 고유 태그 지정 - hero오류
        onPressed: () {
          context.push('/addPersonalSchedule');
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // header(title: '채팅', back: null),
          Text(
            '일정',
            style: AppTextStyles.SU_R_20.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(
            height: 30.h,
          ),
          _meetPart(),
        ],
      ),
    );
  }

  // 파트 선택
  Widget _meetPart() {
    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            _selectedPart(
              title: '밋업 만남',
              isSelected: viewModel.selectedPart == SelectedPart.meetUp,
              onTap: () => viewModel.selectMeetUp(),
            ),
            _selectedPart(
              title: '개인 만남',
              isSelected: viewModel.selectedPart == SelectedPart.personal,
              onTap: () => viewModel.selectPersonal(),
            ),
          ],
        );
      },
    );
  }

  // 파트 선택 위젯
  Widget _selectedPart({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.PR_M_17.copyWith(
                  color:
                      isSelected ? UsedColor.violet : UsedColor.charcoal_black),
            ),
            SizedBox(height: 11.h),
            Container(
              height: 3.h,
              color:
                  isSelected ? UsedColor.progress_bar : UsedColor.progress_bar2,
            )
          ],
        ),
      ),
    );
  }

  Widget _main(BuildContext context) {
    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.selectedPart == SelectedPart.meetUp) {
          return _meetUpView(context);
        } else {
          return _personalView(context);
        }
      },
    );
  }

  // 밋업 만남 뷰
  Widget _meetUpView(BuildContext context) {
    return Container(
      color: UsedColor.bg_color,
      child: Center(
        child: Text(
          'MeetUp Selected',
          style: TextStyle(fontSize: 24.sp),
        ),
      ),
    );
  }

  // 개인 만남 뷰
  Widget _personalView(BuildContext context) {
    return Container(
      color: UsedColor.bg_color,
      child: Center(
        child: Text(
          'Personal Selected',
          style: TextStyle(fontSize: 24.sp),
        ),
      ),
    );
  }
}
