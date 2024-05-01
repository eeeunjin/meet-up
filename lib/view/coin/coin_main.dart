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
            SizedBox(height: 52.h),
            _currentTicket(),
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
          // context.goNamed('meetMain');
          context.pop();
        } else if (fromRoute == 'meetManageMain') {
          // context.goNamed('meetManageMain');
          context.pop();
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
      padding: EdgeInsets.only(left: 32.0.w, right: 28.w),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              // Column 정렬 안되는 오류로 row로 한 번 감싸놓음
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '코인 보유 현황',
                        style: AppTextStyles.SU_R_12
                            .copyWith(color: UsedColor.text_3),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '600 C',
                        style: AppTextStyles.PR_SB_24
                            .copyWith(color: UsedColor.charcoal_black),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 0.w,
                bottom: 10.h,
                child: SizedBox(
                  width: 27.w,
                  height: 27.h,
                  child: Image.asset(
                    ImagePath.nextArrow,
                    width: 6.75.w,
                    height: 13.5.h,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: 337.w,
            height: 51.h,
            decoration: BoxDecoration(
              color: UsedColor.button,
              borderRadius: BorderRadius.circular(19.r),
            ),
            child: Center(
              child: Text(
                '코인 구매',
                style: AppTextStyles.PR_SB_17.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentTicket() {
    return Padding(
      padding: EdgeInsets.only(left: 32.0.w, right: 28.w),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              // Column 정렬 안되는 오류로 row로 한 번 감싸놓음
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '만남권 보유 현황',
                        style: AppTextStyles.SU_R_12
                            .copyWith(color: UsedColor.text_3),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '만남권 1개',
                        style: AppTextStyles.PR_SB_24
                            .copyWith(color: UsedColor.charcoal_black),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: 0.w,
                bottom: 10.h,
                child: SizedBox(
                  width: 27.w,
                  height: 27.h,
                  child: Image.asset(
                    ImagePath.nextArrow,
                    width: 6.75.w,
                    height: 13.5.h,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: 337.w,
            height: 51.h,
            decoration: BoxDecoration(
              color: UsedColor.button,
              borderRadius: BorderRadius.circular(19.r),
            ),
            child: Center(
              child: Text(
                '만남권 구매',
                style: AppTextStyles.PR_SB_17.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
