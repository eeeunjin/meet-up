import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';

class CoinMain extends StatelessWidget {
  final String? fromRoute;

  const CoinMain({super.key, this.fromRoute});

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
            SizedBox(height: 45.h),
            _currentCoin(),
          ],
        ),
      ),
    );
  }

  //header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '코인/만남권'),
          SizedBox(
            height: 11.h,
          ),
          Divider(
            height: 0.3.h,
            color: UsedColor.line,
          )
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // fromRoute에 따라 다른 페이지로 이동하도록 조건 추가
        if (fromRoute == 'meetMain') {
          context.goNamed('meetMain');
        } else if (fromRoute == 'meetManageMain') {
          context.goNamed('meetManageMain');
        } else {
          context.pop();
        }
      },
      child: Image.asset(
        ImagePath.back,
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  Widget _currentCoin() {
    return Padding(
      padding: EdgeInsets.only(left: 32.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '코인 보유 현황',
            style: AppTextStyles.SU_R_12.copyWith(color: UsedColor.text_3),
          ),
          Text(
            '600 C',
            style: AppTextStyles.PR_SB_24
                .copyWith(color: UsedColor.charcoal_black),
          ),
        ],
      ),
    );
  }
}
