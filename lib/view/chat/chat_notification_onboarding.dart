import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ChatNotification extends StatelessWidget {
  const ChatNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 58.h,
            ),
            child: _header(context),
          ),
          SizedBox(
            height: 51.h,
          ),
          Expanded(
            child: SizedBox(
              width: 1.sw,
              // color: UsedColor.bg_color,
              child: _main(context),
            ),
          ),
        ],
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '채팅 시 주의 사항'),
          SizedBox(
            height: 18.h,
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
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  Widget _main(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 21.w,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WarningSection(
              title: '이탈 (일정 확정 전)',
              iconPath: ImagePath.chatNotification1,
              items: const ['하나의 만남권당 최대 3번까지 이탈 가능', '이후 이탈 만남권 소진'],
            ),
            SizedBox(
              height: 48.h,
            ),
            WarningSection(
              title: '이탈 (일정 확정 후)',
              iconPath: ImagePath.chatNotification2,
              items: const ['만남권 소진'],
            ),
            SizedBox(
              height: 40.h,
            ),
            WarningSection(
              title: '이탈 (일정 확정 후 당일 이탈)',
              iconPath: ImagePath.chatNotification3,
              items: const ['1회: 일주일 정지', '2회: 한 달 정지', '3회: 영구 정지 처리'],
            ),
            SizedBox(
              height: 40.h,
            ),
            WarningSection(
              title: '개인정보 유출 및 공유',
              iconPath: ImagePath.chatNotification4,
              items: const [
                '만남 이전, 연락처를 공유하거나 요구하는 경우',
                '다른 사람의 개인정보를 유출하는 경우'
              ],
            ),
            SizedBox(height: 132.h),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: UsedColor.button_g,
                  borderRadius: BorderRadius.circular(12.5.r),
                ),
                child: Text(
                  '최초 신고자 50coin 지급',
                  style:
                      AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_1),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIndicator(true),
                  _buildIndicator(false),
                  _buildIndicator(false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          color: isActive ? UsedColor.main : UsedColor.b_line,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// WarningSection 위젯 정의
class WarningSection extends StatelessWidget {
  final String title;
  final String iconPath;
  final List<String> items;

  const WarningSection({
    super.key,
    required this.title,
    required this.iconPath,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            width: 48.w,
            height: 48.h,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.PR_M_16.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
                SizedBox(height: 8.h),
                ...items.map((item) => Text(
                      '• $item',
                      style: AppTextStyles.PR_R_14.copyWith(
                        color: UsedColor.text_3,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
