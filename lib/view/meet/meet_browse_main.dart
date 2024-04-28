import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';

class MeetBrowseMain extends StatelessWidget {
  const MeetBrowseMain({super.key});

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
            // _main(context),
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
          header(back: _back(context), title: '만남방 둘러보기'),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 9.h),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image.asset(
          ImagePath.back,
          width: 40.w,
          height: 40.h,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 0.91.h,
      color: const Color(0xffd9d9d9),
    );
  }

  Widget _main(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: [
        SizedBox(height: 29.h),
        _search(context),
        SizedBox(height: 22.h),
        _filter(context),
        SizedBox(height: 22.h),
        _divider(),
        SizedBox(height: 28.h),
        // _meetingRoom(context),
      ]),
    );
  }

  Widget _search(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return SizedBox(
      width: 352.w,
      height: 37.h,
      child: Container(
        decoration: BoxDecoration(
          color: UsedColor.bg_color, // 배경색 설정
          borderRadius: BorderRadius.circular(20.0), // 테두리를 둥글게 만듦
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10.0.h),
            hintText: '만남방의 이름을 검색해 보세요.',
            prefixIcon: Image.asset(
              ImagePath.search,
              width: 10.w,
              height: 10.h,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                controller.clear();
              },
              child: Image.asset(
                ImagePath.close,
                width: 23.w,
                height: 23.h,
              ),
            ),
            // Remove border
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,

            hintStyle: AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
          ),
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _filter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context.goNamed('meetFilterMain');
            },
            child: Container(
              width: 92.w,
              height: 34.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19.r),
                  border: Border.all(width: 1.5.w, color: UsedColor.button_g)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '필터 설정',
                    style:
                        AppTextStyles.PR_M_12.copyWith(color: UsedColor.text_2),
                  ),
                  SizedBox(width: 5.w),
                  Image.asset(
                    ImagePath.filterIcon,
                    width: 14.w,
                    height: 11.h,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget _meetingRoom(BuildContext context) {}
