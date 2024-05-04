import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';

class RoomDetail extends StatelessWidget {
  final RoomModel roomModel; // RoomModel 객체를 받습니다.
  const RoomDetail({super.key, required this.roomModel});

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
          Expanded(
            child: _main(context),
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
          header(back: _back(context), title: '세부 정보'),
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
      width: double.infinity,
      color: UsedColor.bg_color,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 30.w, top: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                roomModel.room_name,
                style: AppTextStyles.PR_SB_22
                    .copyWith(color: UsedColor.charcoal_black),
              ),
              SizedBox(height: 10.h),
              // detail
              Text(
                roomModel.room_description,
                style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
              ),
              SizedBox(height: 21.h),
              // keywords
              Wrap(
                spacing: 7.w,
                children: roomModel.room_keyword
                    .map<Widget>((keyword) => _keywordContainer(keyword))
                    .toList(),
              ),
              SizedBox(height: 28.h),
              // etc
              Container(
                width: 340.w,
                height: 131.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 24.w, top: 17.h),
                      child: Row(
                        children: [
                          // 파란 동그라미
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: UsedColor.main),
                          ),
                          SizedBox(
                            width: 11.w,
                          ),
                          Text(
                            '카테고리',
                            style: AppTextStyles.PR_SB_12
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            '${roomModel.room_category}>${roomModel.room_category_detail}',
                            style: AppTextStyles.PR_R_12
                                .copyWith(color: UsedColor.text_3),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _keywordContainer(String keyword) {
    return Container(
      width: 68.w,
      height: 19.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Center(
        child: Text(
          '#$keyword',
          style: AppTextStyles.SU_SB_9.copyWith(color: UsedColor.violet),
        ),
      ),
    );
  }
}
