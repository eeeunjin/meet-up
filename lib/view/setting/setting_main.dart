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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 58.h,
            ),
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
          header(back: _back(context), title: '설정'),
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
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0.h),
          _personalSetting(context),
          Divider(
            thickness: 0.3.h,
            height: 0.h,
            color: UsedColor.grey1,
          ),
          SizedBox(height: 12.h),
          _help(),
        ],
      ),
    );
  }

  Widget _personalSetting(BuildContext context) {
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
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () {
            // context.push('/settingMain/settingNotification');
            context.goNamed('settingNotification');
          },
          child: SizedBox(
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
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _help() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '도움말',
          style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
        ),
        SizedBox(height: 8.0.h),
        SizedBox(
          height: 48.h,
          child: Row(
            children: [
              Image.asset(
                ImagePath.setIcon3,
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(width: 16.w),
              Text(
                '자주 묻는 질문',
                style: AppTextStyles.PR_R_16
                    .copyWith(color: UsedColor.charcoal_black),
              )
            ],
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 48.h,
          child: Row(
            children: [
              Image.asset(
                ImagePath.setIcon4,
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(width: 16.w),
              Text(
                '공지사항',
                style: AppTextStyles.PR_R_16
                    .copyWith(color: UsedColor.charcoal_black),
              )
            ],
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 48.h,
          child: Row(
            children: [
              Image.asset(
                ImagePath.setIcon5,
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(width: 16.w),
              Text(
                '개인정보처리방침',
                style: AppTextStyles.PR_R_16
                    .copyWith(color: UsedColor.charcoal_black),
              )
            ],
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 48.h,
          child: Row(
            children: [
              Image.asset(
                ImagePath.setIcon6,
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(width: 16.w),
              Text(
                '서비스이용사항',
                style: AppTextStyles.PR_R_16
                    .copyWith(color: UsedColor.charcoal_black),
              )
            ],
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 48.h,
          child: Row(
            children: [
              Image.asset(
                ImagePath.setIcon7,
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(width: 16.w),
              Text(
                '오픈소스라이센스',
                style: AppTextStyles.PR_R_16
                    .copyWith(color: UsedColor.charcoal_black),
              )
            ],
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 48.h,
          child: Row(
            children: [
              Image.asset(
                ImagePath.setIcon8,
                width: 24.w,
                height: 24.h,
              ),
              SizedBox(width: 16.w),
              Text(
                '버전정보',
                style: AppTextStyles.PR_R_16
                    .copyWith(color: UsedColor.charcoal_black),
              )
            ],
          ),
        ),
      ],
    );
  }
}
