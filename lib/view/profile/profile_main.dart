import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';

class ProfileMain extends StatelessWidget {
  const ProfileMain({super.key});

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
                  top: 58.h,
                ),
                child: _header(context),
              ),
            Expanded(child: _main(context)),
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
          // header(title: '채팅', back: null),
          Text(
            '프로필',
            style: AppTextStyles.SU_R_20.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            height: 0.3.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  Widget _main(BuildContext context) {
    return Container(
      color: UsedColor.bg_color,
      child: Column(
        children: [
          SizedBox(
            height: 14.h,
          ),
          _topButtons(context),
        ],
      ),
    );
  }

  Widget _topButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 27.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 알림 버튼
          Container(
            width: 41.w,
            height: 22.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.r), color: Colors.white),
            child: Center(
              child: Text(
                '알림',
                style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          // 설정 버튼
          GestureDetector(
            onTap: () {
              context.push('/settingMain');
            },
            child: Container(
              width: 41.w,
              height: 22.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11.r),
                  color: Colors.white),
              child: Center(
                child: Text(
                  '설정',
                  style:
                      AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
