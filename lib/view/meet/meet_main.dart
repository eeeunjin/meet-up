import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';

class MeetMain extends StatelessWidget {
  const MeetMain({super.key});

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
            Expanded(child: _main(context)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '만남',
            style: AppTextStyles.SU_R_20.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(
            height: 23.h,
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
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
          child: Column(
            children: [
              SizedBox(height: 54.h),
              _event(),
              SizedBox(height: 64.h),
              _manageMeetList(context),
              SizedBox(height: 28.h),
              _searchMeetList(context),
              SizedBox(height: 28.h),
              _checkMeetList(),
              SizedBox(height: 89.h),
            ],
          ),
        ),
      ),
    );
  }

  // Mark - 내가 만든 만남방
  Widget _manageMeetList(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed('meetManageMain');
      },
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                ImagePath.meetIcon1,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                '내가 만든 만남방을 관리해보세요!',
                style: AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: 353.w,
            height: 115.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19.r),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25.h,
                      ),
                      Row(
                        children: [
                          Text(
                            '내가 만든 ',
                            style: AppTextStyles.PR_SB_20
                                .copyWith(color: UsedColor.violet),
                          ),
                          Text('만남방', style: AppTextStyles.PR_SB_20),
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        '더보기 >',
                        style: AppTextStyles.SU_R_12
                            .copyWith(color: UsedColor.text_5),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 110.w,
                ),
                Image.asset(
                  ImagePath.meetImage1,
                  width: 70.w,
                  height: 70.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mark - 만남방 둘러보기
  Widget _searchMeetList(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed('meetBrowseMain');
      },
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                ImagePath.meetIcon1,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                '나에게 맞는 만남방을 찾아보세요!',
                style: AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: 353.w,
            height: 115.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19.r),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25.h,
                      ),
                      Row(
                        children: [
                          Text('만남방', style: AppTextStyles.PR_SB_20),
                          Text(
                            ' 둘러보기',
                            style: AppTextStyles.PR_SB_20
                                .copyWith(color: UsedColor.violet),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        '더보기 >',
                        style: AppTextStyles.SU_R_12
                            .copyWith(color: UsedColor.text_5),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 110.w,
                ),
                Image.asset(
                  ImagePath.meetImage2,
                  width: 70.w,
                  height: 70.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mark - 만남 요청 리스트
  Widget _checkMeetList() {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              ImagePath.meetIcon1,
              width: 20.w,
              height: 20.h,
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              '내가 만든 만남방을 관리해보세요!',
              style: AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          width: 353.w,
          height: 115.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19.r),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      '입장 요청 리스트',
                      style: AppTextStyles.PR_SB_20
                          .copyWith(color: UsedColor.violet),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      '더보기 >',
                      style: AppTextStyles.SU_R_12
                          .copyWith(color: UsedColor.text_5),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 110.w,
              ),
              Image.asset(
                ImagePath.meetImage3,
                width: 70.w,
                height: 70.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _event() {
    return Container(
      width: 354.w,
      height: 120.h,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
    );
  }
}
