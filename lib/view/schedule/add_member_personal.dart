import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/schedule/schedule_add_member_view_model.dart';
import 'package:meet_up/view_model/schedule/schedule_main_view_model.dart';
import 'package:provider/provider.dart';

class AddMemberPersonal extends StatelessWidget {
  const AddMemberPersonal({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleAddMemberViewModel>(context);

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
          SizedBox(height: 63.h),
          _main(context, viewModel),
          const Spacer(),
          _bottom(context),
        ],
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '참여자 입력'),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            thickness: 0.3.h,
            height: 0.h,
            color: UsedColor.line,
          )
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 정보 초기화
        final viewModel =
            Provider.of<ScheduleAddMemberViewModel>(context, listen: false);
        viewModel.memberClearSelection();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  Widget _main(BuildContext context, ScheduleAddMemberViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(left: 29.w, right: 26.w),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              // '#' 텍스트
              Padding(
                padding: EdgeInsets.only(left: 5.0.w),
                child: Text(
                  '#',
                  style:
                      AppTextStyles.PR_SB_22.copyWith(color: UsedColor.button),
                ),
              ),
              // 텍스트 필드
              TextField(
                controller: viewModel.textController,
                cursorColor: Colors.black, // 커서 색상 변경
                decoration: InputDecoration(
                  hintText: '참여자 이름을 입력해 주세요. (최대 4명)',
                  hintStyle:
                      AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_5),
                  contentPadding: EdgeInsets.only(left: 25.w),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: UsedColor.text_1, width: 0.75),
                  ),
                ),
                onChanged: (text) {
                  viewModel.setKeywordCount();
                  logger.d(text);
                  // 4명 입력하면 더 입력 못하도록 막음
                  if (viewModel.members.length >= 4) {
                    viewModel.textController.clear();
                    return;
                  }
                  if (text.length > 8) {
                    // 스페이스바로 저장
                    if (text.characters.last == ' ') {
                      final keyword = text.trim();
                      viewModel.addKeyword(keyword);
                      viewModel.textController.clear();
                    }
                    // 스페이스바가 아닌 경우 입력 막기
                    else {
                      viewModel.textController.text =
                          viewModel.textController.text.substring(0, 8);
                      viewModel.setKeywordCount();
                    }
                  } else {
                    // 스페이스바로 저장
                    if (text.characters.last == ' ') {
                      final keyword = text.trim();
                      viewModel.addKeyword(keyword);
                      viewModel.textController.clear();
                    }
                  }
                },
                onSubmitted: (text) {
                  // 엔터로 저장
                  final keyword = text.trim();
                  if (keyword.isNotEmpty) {
                    viewModel.addKeyword(keyword);
                    viewModel.textController.clear();
                  }
                },
                textInputAction: TextInputAction.done,
                style: AppTextStyles.PR_R_15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  viewModel.keywordCount,
                  style:
                      AppTextStyles.PR_SB_11.copyWith(color: UsedColor.text_4),
                ),
              ),
            ],
          ),
          // 텍스트 카운트 표시
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.0.w, top: 5.0.h, right: 7.0.w),
                child: Row(
                  children: [
                    Visibility(
                      visible: viewModel.members.length >= 4,
                      child: Text(
                        '참여자는 최대 4명까지 입력이 가능합니다.',
                        style: AppTextStyles.SU_R_12
                            .copyWith(color: UsedColor.red),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 6.0.h),
                  child: _memberList(context, viewModel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _memberList(
      BuildContext context, ScheduleAddMemberViewModel viewModel) {
    return Wrap(
      // 자동 줄바꿈
      spacing: 4.0, // 좌우 간격
      runSpacing: 4.0, // 상하 간격
      children: viewModel.members
          .map((keyword) => _keywordChip(
              keyword,
              AppTextStyles.SU_SB_12.copyWith(color: UsedColor.violet),
              context))
          .toList(),
    );
  }

  Widget _keywordChip(
      String member, TextStyle textStyle, BuildContext context) {
    double baseWidth = 78.w;
    int additionalCharacters = member.length - 2;
    double additionalWidth = 10.w;
    double containerWidth =
        baseWidth + (additionalCharacters * additionalWidth);

    containerWidth = max(containerWidth, baseWidth);

    return Container(
      width: containerWidth,
      height: 29.h,
      decoration: BoxDecoration(
        color: UsedColor.image_card,
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, right: 11.w),
            child: Center(
              child: Text(
                '#$member',
                style: AppTextStyles.SU_SB_12.copyWith(color: UsedColor.violet),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<ScheduleAddMemberViewModel>(context, listen: false)
                  .removeKeyword(member);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 11.0.w),
              child: Image.asset(
                ImagePath.closeIcon,
                width: 7.w,
                height: 7.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 33.w, bottom: 56.h),
      child: Consumer2<ScheduleAddMemberViewModel, ScheduleMainViewModel>(
          builder: (context, scheduleAddMemberViewModel, scheduleMainViewModel,
              child) {
        return NextButton(
          onTap: () async {
            if (scheduleAddMemberViewModel.memberCheckCompleted) {
              scheduleMainViewModel.selectedMembers =
                  List.from(scheduleAddMemberViewModel.members);
              scheduleAddMemberViewModel.memberClearSelection();
              context.pop();
            } else {
              return;
            }
          },
          height: 56.h,
          text: '저장',
          enable: scheduleAddMemberViewModel.memberCheckCompleted,
          backgroundColor: scheduleAddMemberViewModel.memberCheckCompleted
              ? UsedColor.button
              : UsedColor.button_g,
          textStyle: AppTextStyles.PR_SB_20.copyWith(
              color: scheduleAddMemberViewModel.memberCheckCompleted
                  ? Colors.white
                  : UsedColor.text_2),
        );
      }),
    );
  }
}
