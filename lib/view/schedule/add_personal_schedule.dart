import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/schedule/schedule_main_view_model.dart';
import 'package:provider/provider.dart';

class AddPersonalSchedule extends StatelessWidget {
  const AddPersonalSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (Platform.isIOS)
              _header(context)
            else if (Platform.isAndroid)
              Padding(
                padding: EdgeInsets.only(
                  top: 15.h,
                ),
                child: _header(context),
              ),
            Expanded(child: _main(context)),
            _bottom(context),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Column(
            //       children: [
            //         _main(context),
            //         Padding(
            //           padding: EdgeInsets.only(
            //               left: 33.w, right: 32.w, bottom: 56.h),
            //           child: _bottom(context),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '개인 일정 추가'),
          SizedBox(
            height: 16.h,
          ),
          _divider(),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 25.0.w),
        child: Image.asset(
          ImagePath.backCross,
          width: 17.48.w,
          height: 17.48.h,
        ),
      ),
    );
  }

  // 구분선
  Widget _divider() {
    return Divider(
      thickness: 0.3.h,
      height: 0.h,
      color: UsedColor.line,
    );
  }

  // 메인
  Widget _main(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 22.h),
          _naming(context),
          SizedBox(height: 22.h),
          _divider(),
          SizedBox(height: 10.h),
          _date(context),
          SizedBox(height: 10.h),
          _divider(),
          SizedBox(height: 10.h),
          _time(context),
          SizedBox(height: 10.h),
          _divider(),
          SizedBox(height: 20.h),
          _location(context),
          SizedBox(height: 20.h),
          _divider(),
          SizedBox(height: 20.h),
          _detail(context),
          SizedBox(height: 18.h),
          _divider(),
          SizedBox(height: 18.h),
          _member(context),
        ],
      ),
    );
  }

  Widget _date(BuildContext context) {
    final viewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);

    // Mark - ExpansionPanel 사용
    return Theme(
      data: Theme.of(context).copyWith(cardColor: Colors.white),
      child: ExpansionPanelList(
        elevation: 0.h,
        expandedHeaderPadding: EdgeInsets.zero, // 헤더 주변 기본 패딩 제거
        expansionCallback: (int index, bool isExpanded) {
          viewModel.toggleDatePanel();
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: EdgeInsets.only(left: 23.0.w),
                child: Row(
                  children: [
                    Image.asset(
                      ImagePath.scheduleIcon2,
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      '날짜',
                      style: AppTextStyles.PR_M_16
                          .copyWith(color: UsedColor.charcoal_black),
                    ),
                  ],
                ),
              );
            },
            // 토글 내부 내용
            body: SizedBox(
              height: 170.h,
              child: Padding(
                padding: EdgeInsets.only(top: 8.0.h, left: 70.w, bottom: 34.h),
                child: Container(
                  width: 279.w,
                  height: 132.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.6.r),
                    border: Border.all(width: 1.w, color: UsedColor.b_line),
                  ),
                  // 데이트 피커 넣기
                  child: const Center(
                    child: Text(
                      '데이트 피커 넣기',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            isExpanded:
                Provider.of<ScheduleMainViewModel>(context).isDatePanelExpanded,
          ),
        ],
      ),
    );
  }

  Widget _time(BuildContext context) {
    final viewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);

    // Mark - ExpansionPanel 사용
    return Theme(
      data: Theme.of(context).copyWith(cardColor: Colors.white),
      child: ExpansionPanelList(
        elevation: 0.h,
        expandedHeaderPadding: EdgeInsets.zero, // 헤더 주변 기본 패딩 제거
        expansionCallback: (int index, bool isExpanded) {
          viewModel.toggleTimePanel();
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: EdgeInsets.only(left: 23.0.w),
                child: Row(
                  children: [
                    Image.asset(
                      ImagePath.scheduleIcon3,
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      '시간',
                      style: AppTextStyles.PR_M_16
                          .copyWith(color: UsedColor.charcoal_black),
                    ),
                  ],
                ),
              );
            },
            body: SizedBox(
              height: 150.w,
              child: const Center(
                child: Text(
                  'Selected time content goes here',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            isExpanded:
                Provider.of<ScheduleMainViewModel>(context).isTimePanelExpanded,
          ),
        ],
      ),
    );
  }

  Widget _location(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 23.0.w),
      child: Row(
        children: [
          Image.asset(
            ImagePath.scheduleIcon4,
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(width: 20.w),
          Text(
            '장소',
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 19.h,
              child: TextField(
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: '만남 장소를 입력해주세요',
                  hintStyle: TextStyle(color: UsedColor.text_5),
                ),
                style: AppTextStyles.PR_R_15.copyWith(color: UsedColor.text_5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 23.0.w),
      child: Row(
        children: [
          Image.asset(
            ImagePath.scheduleIcon5,
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(width: 20.w),
          Text(
            '설명',
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -4.0.h),
              child: Container(
                alignment: Alignment.center,
                height: 19.h,
                child: TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: '만남에 대한 간단한 설명을 작성해 주세요.',
                    hintStyle: TextStyle(color: UsedColor.text_5),
                  ),
                  style:
                      AppTextStyles.PR_R_15.copyWith(color: UsedColor.text_5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _member(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 23.0.w),
      child: Row(
        children: [
          Image.asset(
            ImagePath.scheduleIcon6,
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(width: 20.w),
          Text(
            '참여',
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -4.0.h),
              child: Container(
                alignment: Alignment.center,
                height: 19.h,
                child: TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: '인원 및 참여자 정보를 입력해주세요.',
                    hintStyle: TextStyle(color: UsedColor.text_5),
                  ),
                  style:
                      AppTextStyles.PR_R_15.copyWith(color: UsedColor.text_5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _naming(BuildContext context) {
    final viewModel = Provider.of<ScheduleMainViewModel>(context);

    return Padding(
      padding: EdgeInsets.only(left: 23.0.w),
      child: Row(
        children: [
          Image.asset(
            ImagePath.scheduleIcon1,
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(width: 20.w),
          Text(
            '일정',
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 19.h,
              child: TextField(
                onChanged: (text) => viewModel.namingContents(text),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: '일정을 입력해주세요',
                  hintStyle: TextStyle(color: UsedColor.text_5),
                ),
                style: AppTextStyles.PR_R_15.copyWith(color: UsedColor.text_5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 저장
Widget _bottom(BuildContext context) {
  return Consumer<ScheduleMainViewModel>(builder: (context, viewModel, child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 56.0.h, left: 51.w, right: 51.w),
      child: NextButton(
        onTap: () async {
          if (!viewModel.allCheckCompleted) return;
        },
        height: 50.h,
        text: '저장',
        enable: viewModel.allCheckCompleted,
        backgroundColor:
            viewModel.allCheckCompleted ? UsedColor.button : UsedColor.button_g,
        textStyle: TextStyle(
          color: viewModel.allCheckCompleted ? Colors.white : UsedColor.text_2,
          fontSize: 20.sp,
        ),
      ),
    );
  });
}
