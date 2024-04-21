import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
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
            _main(context)
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
    return Container(
      height: 0.3.h,
      color: UsedColor.line,
    );
  }

  // 메인
  Widget _main(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 22.h),
        Padding(
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
                style: AppTextStyles.PR_M_16
                    .copyWith(color: UsedColor.charcoal_black),
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
                        hintText: '일정을 입력해주세요',
                        hintStyle: TextStyle(color: UsedColor.text_5),
                      ),
                      style: AppTextStyles.PR_R_15
                          .copyWith(color: UsedColor.text_5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 22.h),
        _divider(),
        SizedBox(height: 18.h),
        _date(context),
        SizedBox(height: 18.h),
        _divider(),
      ],
    );
  }

  Widget _date(BuildContext context) {
    final viewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);

    // Mark - ExpansionTile 사용
    // return Theme(
    //   data: Theme.of(context).copyWith(
    //     dividerColor: Colors.transparent,
    //     unselectedWidgetColor: Colors.white,
    //   ),
    //   child: ExpansionTile(
    //     leading: SizedBox(width: 0.0.w),
    //     title: Row(
    //       children: [
    //         Image.asset(
    //           ImagePath.scheduleIcon2,
    //           width: 20.w,
    //           height: 20.h,
    //         ),
    //         SizedBox(width: 10.w),
    //         Text(
    //           '날짜',
    //           style: AppTextStyles.PR_M_16
    //               .copyWith(color: UsedColor.charcoal_black),
    //         ),
    //       ],
    //     ),
    //     children: [
    //       Container(
    //         height: 132.h,
    //         color: Colors.green, // ex
    //       ),
    //     ],
    //   ),
    // );

    // Mark - ExpansionPanel 사용
    return Theme(
      data: Theme.of(context).copyWith(cardColor: Colors.white),
      child: ExpansionPanelList(
        elevation: 0.h,
        expandedHeaderPadding: const EdgeInsets.all(0), // 헤더 주변 기본 패딩 제거
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
            body: SizedBox(
              height: 150.w,
              child: const Center(
                child: Text(
                  'Selected date content goes here',
                  style: TextStyle(color: Colors.black),
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
}
