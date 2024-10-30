import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';

class SettingNotification extends StatelessWidget {
  const SettingNotification({super.key});

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
          header(back: _back(context), title: '푸시 알림 설정'),
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _meeting(context),
          // _divider(),
          _evaluation(context),
          _divider(),
          // _coin(context),
          // _divider(),
          // _rank(context),
          // _divider(),
          _report(context),
          // _divider(),
          // _event(context),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      thickness: 10.h,
      color: UsedColor.grey2,
    );
  }

  // Widget _meeting(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 33.0.w, top: 24.h, bottom: 27.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '만남',
  //           style:
  //               AppTextStyles.PR_B_18.copyWith(color: UsedColor.charcoal_black),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(left: 33.0.w, right: 40.0.w),
  //           child: Column(
  //             children: [
  //               NotificationToggle(
  //                   text: '입장 요청',
  //                   initialValue: false,
  //                   onChanged: (bool value) {}),
  //               SizedBox(height: 28.h),
  //               NotificationToggle(
  //                   text: '채팅',
  //                   initialValue: false,
  //                   onChanged: (bool value) {}),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  Widget _evaluation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, top: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '상호평가',
            style:
                AppTextStyles.PR_B_18.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(
            height: 28.h,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 23.0.w,
              right: 40.0.w,
              bottom: 32.h,
            ),
            child: Column(
              children: [
                NotificationToggle(
                  text: '수신함',
                  initialValue: false,
                  onChanged: (bool value) {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  // Widget _coin(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 33.0.w, top: 24.h, bottom: 27.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '코인',
  //           style:
  //               AppTextStyles.PR_B_18.copyWith(color: UsedColor.charcoal_black),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(left: 33.0.w, right: 40.0.w),
  //           child: Column(
  //             children: [
  //               NotificationToggle(
  //                   text: '미션',
  //                   initialValue: false,
  //                   onChanged: (bool value) {}),
  //               SizedBox(height: 28.h),
  //               NotificationToggle(
  //                   text: '결제',
  //                   initialValue: false,
  //                   onChanged: (bool value) {}),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _rank(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 33.0.w, top: 24.h, bottom: 27.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '등급',
  //           style:
  //               AppTextStyles.PR_B_18.copyWith(color: UsedColor.charcoal_black),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(left: 33.0.w, right: 40.0.w),
  //           child: Column(
  //             children: [
  //               NotificationToggle(
  //                   text: '등급 상승',
  //                   initialValue: false,
  //                   onChanged: (bool value) {}),
  //               SizedBox(height: 28.h),
  //               NotificationToggle(
  //                   text: '등급 초기화',
  //                   initialValue: false,
  //                   onChanged: (bool value) {}),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _report(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, top: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '신고',
            style:
                AppTextStyles.PR_B_18.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(height: 28.h),
          Padding(
            padding: EdgeInsets.only(
              left: 23.0.w,
              right: 40.0.w,
              bottom: 32.h,
            ),
            child: Column(
              children: [
                NotificationToggle(
                  text: '신고 내용',
                  initialValue: false,
                  onChanged: (bool value) {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NotificationToggle extends StatelessWidget {
  final String text;
  final bool initialValue;
  final Function(bool) onChanged;

  const NotificationToggle(
      {super.key,
      required this.text,
      required this.initialValue,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_3),
        ),
        SizedBox(
          width: 56.w,
          height: 24.h,
          child: CupertinoSwitch(
            value: initialValue,
            onChanged: onChanged,
            activeColor: UsedColor.grey1,
            trackColor: UsedColor.grey1,
          ),
        ),
      ],
    );
  }
}
