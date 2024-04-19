import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';

class SettingMain extends StatelessWidget {
  const SettingMain({super.key});

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
            _main(),
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
          header(back: _back(context), title: '설정'),
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

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  Widget _main() {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0.h),
          _personalSetting(),
          Divider(
            height: 0.3.h,
            color: UsedColor.grey1,
          ),
        ],
      ),
    );
  }

  Widget _personalSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '개인 설정',
          style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
        ),
        SizedBox(height: 8.0.h),
        SizedBox(
          height: 48.h,
          child: Row(
            children: [
              Image.asset(
                ImagePath.setIcon1,
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(width: 16.w),
              Text(
                '회원 정보',
                style: AppTextStyles.PR_R_16
                    .copyWith(color: UsedColor.charcoal_black),
              )
            ],
          ),
        ),
        SizedBox(
          height: 48.h,
          child: Row(
            children: [
              Image.asset(
                ImagePath.setIcon2,
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(width: 16.w),
              Text(
                '알림 설정',
                style: AppTextStyles.PR_R_16
                    .copyWith(color: UsedColor.charcoal_black),
              )
            ],
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
