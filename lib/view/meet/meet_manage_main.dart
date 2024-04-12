import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/coin_widget.dart';
import 'package:meet_up/view/widget/header_widget.dart';

class MeetManageMain extends StatelessWidget {
  const MeetManageMain({super.key});

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
            Expanded(
              child: _main(context),
            ),
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
          header(back: _back(context), title: '내가 만든 만남방'),
          SizedBox(
            height: 11.h,
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

  Widget _main(BuildContext context) {
    return Container(
      color: UsedColor.bg_color,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 19.w),
          child: Column(
            children: [
              SizedBox(height: 31.h),
              _title(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.0.w, right: 8.w),
          child: Text(
            '만남권 관리',
            style: AppTextStyles.PR_SB_22,
          ),
        ),
        // 방 개수
        Text(
          '6개',
          style: AppTextStyles.SU_SB_16.copyWith(color: UsedColor.text_3),
        ),
        SizedBox(width: 118.w),
        GestureDetector(
            onTap: () {
              context.goNamed('coinMainFromMeetManageMain');
            },
            child: const CoinWidget(coinAmount: '600', itemCount: 5)),
      ],
    );
  }
}
