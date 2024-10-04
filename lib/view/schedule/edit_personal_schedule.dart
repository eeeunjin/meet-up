import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/personal_schedule_date_picker_widget.dart';
import 'package:meet_up/view/widget/personal_schedule_time_picker_widget.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/schedule/schedule_main_view_model.dart';
import 'package:provider/provider.dart';

class EditPersonalSchedule extends StatelessWidget {
  const EditPersonalSchedule({super.key});

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
          header(back: _back(context), title: '개인 일정 추가'),
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
            Provider.of<ScheduleMainViewModel>(context, listen: false);
        viewModel.backClearSelection();

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

  //MARK: - 메인
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
          SizedBox(height: 104.h),
          _bottom(context),
        ],
      ),
    );
  }

  //MARK: - 일정
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
          SizedBox(width: 14.w),
          Text(
            '일정',
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 22.w),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 19.h,
              child: TextField(
                onChanged: (text) => viewModel.namingContents(text),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: '일정을 입력해주세요',
                  hintStyle: TextStyle(color: UsedColor.line),
                ),
                style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //MARK: - 날짜
  Widget _date(BuildContext context) {
    final viewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);

    // ExpansionPanel 사용
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
                      '${viewModel.selectedDate.year}. ${viewModel.selectedDate.month}. ${viewModel.selectedDate.day}. ${DateFormat.E('ko_KR').format(viewModel.selectedDate)}요일',
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
                    child: PersonalScheduleDatePicker(
                      onChangeListener: (DateTime dt) {},
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

  // MARK: - 시간
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
                padding: EdgeInsets.only(left: 20.0.w),
                child: Row(
                  children: [
                    Image.asset(
                      ImagePath.scheduleIcon3,
                      width: 23.w,
                      height: 23.h,
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
                  alignment: Alignment.center,
                  width: 279.w,
                  height: 132.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.6.r),
                    border: Border.all(width: 1.w, color: UsedColor.b_line),
                  ),
                  // 타임 피커 넣기
                  child: PersonalScheduleTimePicker(
                    onTimeChanged: (TimeOfDay time) {
                      viewModel.updateTime(time);
                    },
                  ),
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

  //MARK: - 장소
  Widget _location(BuildContext context) {
    final viewModel = Provider.of<ScheduleMainViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(left: 21.0.w),
      child: Row(
        children: [
          Image.asset(
            ImagePath.scheduleIcon4,
            width: 20.w,
            height: 20.h,
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
                controller: viewModel.locationTextController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: '만남 장소를 입력해주세요',
                  hintStyle: TextStyle(color: UsedColor.line),
                ),
                style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //MARK: - 설명
  Widget _detail(BuildContext context) {
    final viewModel = Provider.of<ScheduleMainViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(left: 21.0.w),
      child: Row(
        children: [
          Image.asset(
            ImagePath.scheduleIcon5,
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(width: 12.w),
          Text(
            '설명',
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 22.w),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 19.h,
              child: TextField(
                controller: viewModel.detailTextController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: '만남에 대한 간단한 설명을 작성해 주세요.',
                  hintStyle: TextStyle(color: UsedColor.line),
                ),
                style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //MARK: - 참여자 선택
  Widget _member(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 21.0.w),
      child: Row(
        children: [
          Image.asset(
            ImagePath.scheduleIcon6,
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(width: 12.w),
          Text(
            '참여',
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 22.w),
          // 참여자 선택 힌트 텍스트
          GestureDetector(
              onTap: () {
                // 참여자 선택 페이지로 이동
                context.goNamed('addMemberPersonal');
              },
              child: _selectedMembers(context)),
        ],
      ),
    );
  }

  Widget _selectedMembers(BuildContext context) {
    final viewModel = Provider.of<ScheduleMainViewModel>(context);
    return Consumer<ScheduleMainViewModel>(
        builder: (context, viewmodel, child) {
      List<String> participants = viewModel.selectedMembers;

      if (participants.isEmpty) {
        return Text(
          '인원 및 참여자 정보를 입력해주세요.',
          style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_5),
        );
      } else {
        return Wrap(
          spacing: 8.w,
          children: participants.map((member) {
            return Container(
              padding: EdgeInsets.only(
                  left: 10.w, right: 9.w, top: 3.h, bottom: 3.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.5.r),
                color: UsedColor.image_card,
              ),
              child: Text(
                member,
                style: AppTextStyles.SU_M_10.copyWith(color: UsedColor.violet),
              ),
            );
          }).toList(),
        );
      }
    });
  }

//MARK: - 저장
  Widget _bottom(BuildContext context) {
    return Consumer<ScheduleMainViewModel>(
        builder: (context, viewModel, child) {
      return Padding(
        padding: EdgeInsets.only(bottom: 56.0.h, left: 33.w, right: 33.w),
        child: NextButton(
          onTap: () async {
            if (!viewModel.allCheckCompleted) return;
          },
          height: 56.h,
          width: 327.w,
          text: '저장',
          enable: viewModel.allCheckCompleted,
          backgroundColor: viewModel.allCheckCompleted
              ? UsedColor.button
              : UsedColor.button_g,
          textStyle: TextStyle(
            color:
                viewModel.allCheckCompleted ? Colors.white : UsedColor.text_2,
            fontSize: 20.sp,
          ),
        ),
      );
    });
  }
}
