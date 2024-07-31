import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/schedule_date_picker_widget.dart';
import 'package:meet_up/view/widget/schedule_time_picker_widget.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:provider/provider.dart';

class ChatScheduleHostView extends StatelessWidget {
  const ChatScheduleHostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 채팅 overflow 방지
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 58.h),
            child: _header(context),
          ),
          _main(context),
        ],
      ),
    );
  }

// header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '일정 등록'),
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

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 정보 초기화
        final viewModel =
            Provider.of<MeetCreateViewModel>(context, listen: false);
        viewModel.locationClearSelection();
        context.pop(context);
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
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

  Widget _main(BuildContext context) {
    return Column(
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
        _scheduleCheck(context),
      ],
    );
  }

  Widget _naming(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context);

    return Padding(
      padding: EdgeInsets.only(left: 23.w),
      child: Row(
        children: [
          Image.asset(
            ImagePath.scheduleIcon1,
            width: 19.17.w,
            height: 19.17.h,
          ),
          SizedBox(width: 14.w),
          Text(
            '일정',
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 22.w),
        ],
        // 일정 입력인지 입력된 일정 이름 확인인지 모르겠음
      ),
    );
  }

  //MARK: - 날짜
  Widget _date(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context, listen: false);

    //ExpansionPanel 사용
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
                padding: EdgeInsets.only(left: 21.0.w),
                child: Row(
                  children: [
                    Image.asset(
                      ImagePath.scheduleIcon2,
                      width: 23.w,
                      height: 23.h,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      '날짜',
                      style: AppTextStyles.PR_M_16
                          .copyWith(color: UsedColor.charcoal_black),
                    ),
                    SizedBox(width: 22.w),
                    // 선택된 날짜
                    Text(
                      '${viewModel.selectedDate.year}. ${viewModel.selectedDate.month}. ${viewModel.selectedDate.day}',
                      style: AppTextStyles.PR_R_16
                          .copyWith(color: UsedColor.text_1),
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
                  child: Center(
                    child: ScheduleDatePicker(
                      onChangeListener: (DateTime dt) {},
                    ),
                  ),
                ),
              ),
            ),
            isExpanded: Provider.of<ChatViewModel>(context).isDatePanelExpanded,
          ),
        ],
      ),
    );
  }

  // MARK: - Time
  Widget _time(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context, listen: false);

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
                padding: EdgeInsets.only(left: 21.0.w),
                child: Row(
                  children: [
                    Image.asset(
                      ImagePath.scheduleIcon3,
                      width: 23.w,
                      height: 23.w,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      '시간',
                      style: AppTextStyles.PR_M_16
                          .copyWith(color: UsedColor.charcoal_black),
                    ),
                    SizedBox(width: 22.w),
                    // 선택된 시간
                    Text(
                      viewModel.formatTime(viewModel.selectedTime),
                      style: AppTextStyles.PR_R_16
                          .copyWith(color: UsedColor.text_1),
                    ),
                  ],
                ),
              );
            },
            body: SizedBox(
              height: 170.w,
              child: Padding(
                padding: EdgeInsets.only(top: 8.0.h, left: 70.w, bottom: 34.h),
                child: Container(
                  width: 279.w,
                  height: 132.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.6.r),
                    border: Border.all(width: 1.w, color: UsedColor.b_line),
                  ),
                  // 타임 피커 넣기
                  child: Center(
                    child: ScheduleTimePicker(
                      onTimeChanged: (TimeOfDay time) {
                        viewModel.updateTime(time);
                      },
                    ),
                  ),
                ),
              ),
            ),
            isExpanded: Provider.of<ChatViewModel>(context).isTimePanelExpanded,
          ),
        ],
      ),
    );
  }

  //MARK: - 장소
  Widget _location(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 21.0.w),
      child: Row(
        children: [
          Image.asset(
            ImagePath.scheduleIcon4,
            width: 23.w,
            height: 23.h,
          ),
          SizedBox(width: 12.w),
          Text(
            '장소',
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 22.w),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 19.h,
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: '만남 장소를 입력해주세요',
                  hintStyle:
                      AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_1),
                ),
                style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //MARK: - 일정 확인
  Widget _scheduleCheck(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context);

    return Padding(
      padding: EdgeInsets.only(left: 23.w),
      child: Row(
        children: [
          Image.asset(
            ImagePath.scheduleIconCheck,
            width: 23.w,
            height: 23.h,
          ),
          SizedBox(width: 12.w),
          Text(
            '일정 확정',
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
        ],
      ),
    );
  }
}
