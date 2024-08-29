import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/chat/chat_room_schedule_register_view_model.dart';
import 'package:meet_up/view_model/chat/chat_room_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:provider/provider.dart';

class ChatScheduleCheck extends StatelessWidget {
  const ChatScheduleCheck({super.key});

  // MARK: - 빌드
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
          SingleChildScrollView(child: _main(context)),
        ],
      ),
    );
  }

  // MARK: - 헤더
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

  // MARK: - 뒤로가기
  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 정보 초기화
        final viewModel =
            Provider.of<MeetCreateViewModel>(context, listen: false);
        viewModel.locationClearSelection();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  // MARK: - 구분선
  Widget _divider() {
    return Divider(
      thickness: 0.3.h,
      height: 0.h,
      color: UsedColor.line,
    );
  }

  // MARK: - 메인
  Widget _main(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 22.h),
        _naming(context),
        SizedBox(height: 22.h),
        _divider(),
        SizedBox(height: 20.h),
        _date(context),
        SizedBox(height: 21.h),
        _divider(),
        SizedBox(height: 20.h),
        _time(context),
        SizedBox(height: 21.h),
        _divider(),
        SizedBox(height: 20.h),
        _location(context),
        SizedBox(height: 20.h),
        _divider(),
        SizedBox(height: 20.h),
        _scheduleCheck(context),
        SizedBox(height: 20.h),
        _checkButton(context),
        SizedBox(height: 20.h),
        _checkText(context),
        SizedBox(height: 20.h),
        _divider(),
        SizedBox(height: 20.h),
        _member(context),
        _deleteButton(context),
      ],
    );
  }

  // MARK: - 일정 이름
  Widget _naming(BuildContext context) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    final scheduleName =
        RoomSchedule.fromJson(chatRoomViewModel.roomModel.room_schedule!).title;

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
          Text(
            scheduleName,
            style: AppTextStyles.PR_R_16.copyWith(
              color: UsedColor.text_1,
            ),
          )
        ],
        // 일정 입력인지 입력된 일정 이름 확인인지 모르겠음
      ),
    );
  }

  // MARK: - 날짜
  Widget _date(BuildContext context) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    final scheduleDate =
        RoomSchedule.fromJson(chatRoomViewModel.roomModel.room_schedule!).date;
    final scheduleDateYear = scheduleDate.toDate().year;
    final scheduleDateMonth = scheduleDate.toDate().month;
    final scheduleDateDay = scheduleDate.toDate().day;
    final scheduleDateWeekday = chatRoomViewModel.getDayOfWeek(
        scheduleDateYear, scheduleDateMonth, scheduleDateDay);
    final scheduleDateText =
        '$scheduleDateYear. $scheduleDateMonth. $scheduleDateDay. $scheduleDateWeekday요일';

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
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 22.w),
          // 선택된 날짜
          Text(
            scheduleDateText,
            style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_1),
          ),
        ],
      ),
    );
  }

  // MARK: - 시간
  Widget _time(BuildContext context) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    final scheduleTime =
        RoomSchedule.fromJson(chatRoomViewModel.roomModel.room_schedule!).date;
    final scheduleTimeHour = scheduleTime.toDate().hour % 12;
    final scheduleTimeMinute = (scheduleTime.toDate().minute < 10)
        ? '0${scheduleTime.toDate().minute}'
        : '${scheduleTime.toDate().minute}';
    final scheduleTimeText = (scheduleTime.toDate().hour < 12)
        ? '오전 $scheduleTimeHour:$scheduleTimeMinute'
        : '오후 $scheduleTimeHour:$scheduleTimeMinute';

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
            style:
                AppTextStyles.PR_M_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(width: 22.w),
          // 선택된 시간
          Text(
            scheduleTimeText,
            style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_1),
          ),
        ],
      ),
    );
  }

  // MARK: - 장소
  Widget _location(BuildContext context) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    final scheduleLocation =
        RoomSchedule.fromJson(chatRoomViewModel.roomModel.room_schedule!)
            .location;

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
          Text(
            scheduleLocation,
            style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_1),
          ),
        ],
      ),
    );
  }

  // MARK: - 일정 확정
  Widget _scheduleCheck(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 21.w),
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

  // MARK: - 참석 확인
  Widget _checkButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 52.0.w),
      child: Container(
        width: 287.w,
        height: 41.h,
        decoration: BoxDecoration(
            color: UsedColor.button, borderRadius: BorderRadius.circular(9.r)),
        child: Center(
          child: Text(
            '참석 확인',
            style: AppTextStyles.PR_SB_18.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // MARK: - 참석 확인 아래 텍스트
  Widget _checkText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 31.0.w),
      child: Text(
        '모든 참석자가 참석 확정 버튼을 누르면 일정이 확정됩니다.\n1일 내로  일정 확정이 되지 않으면 방이 사라집니다.\n참석 확정 버튼을 누르면 추후 변경이 불가합니다.',
        style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
        textAlign: TextAlign.center,
      ),
    );
  }

  // MARK: - 참석 여부
  Widget _member(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 21.w),
          child: Row(
            children: [
              Image.asset(
                ImagePath.scheduleIconMember,
                width: 23.w,
                height: 23.h,
              ),
              SizedBox(width: 12.w),
              Text(
                '참석 여부',
                style: AppTextStyles.PR_M_16
                    .copyWith(color: UsedColor.charcoal_black),
              ),
            ],
          ),
        ),
        SizedBox(height: 21.h),
        //TODO: 방 인원 확인하는 것처럼 해두기
        // 여기부터 다시 작업 
      ],
    );
  }

  // MARK: - 일정 삭제 버튼
  Widget _deleteButton(BuildContext context) {
    final viewModel =
        Provider.of<ChatRoomSchduleRegisterViewModel>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(bottom: 56.0.h, left: 51.w),
      child: NextButton(
        onTap: () {
          //TODO: 누를 때, 확인 문구 먼저
          deleteDialog(context, viewModel);
        },
        height: 50.h,
        width: 291.w,
        text: '일정 삭제하기',
      ),
    );
  }

  // MARK: - 일정 삭제 다이얼로그
  void deleteDialog(BuildContext context,
      ChatRoomSchduleRegisterViewModel ChatRoomSchduleHostViewModel) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            width: 245.w,
            height: 164.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Text(
                    '일정을 삭제하시겠습니까?',
                    style: AppTextStyles.PR_M_13.copyWith(
                        color: Colors.black, decoration: TextDecoration.none),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  '일정을 삭제하면 참석자들의\n기존 참석 확인은 무효 처리됩니다.\n일정은 하단 일정 등록 버튼을 통해\n방장이 새롭게 등록 가능합니다.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.PR_R_12.copyWith(
                      color: UsedColor.text_3, decoration: TextDecoration.none),
                ),
                SizedBox(height: 18.h),
                // 구분선
                Divider(
                  thickness: 0.3.h,
                  height: 0.h,
                  color: UsedColor.b_line,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 35.h,
                        child: TextButton(
                          // ! : - 잉크 효과 X
                          style: const ButtonStyle(
                              overlayColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '취소',
                            style: AppTextStyles.PR_M_14
                                .copyWith(color: UsedColor.charcoal_black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 35.h,
                      width: 0.3.w,
                      color: UsedColor.b_line,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 35.h,
                        child: TextButton(
                          style: const ButtonStyle(
                              overlayColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          onPressed: () {},
                          child: Text(
                            '삭제하기',
                            style: AppTextStyles.PR_M_14
                                .copyWith(color: UsedColor.charcoal_black),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
