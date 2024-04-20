import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';

class AddPersonalSchedule extends StatelessWidget {
  const AddPersonalSchedule({super.key});

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
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Column(
            //       children: [
            //         _main(context),
            //         Padding(
            //           padding: EdgeInsets.only(
            //               left: 33.w, right: 32.w, bottom: 56.h),
            //           child: _bottom(context),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
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
          header(back: _back(context), title: '개인 일정 추가'),
          SizedBox(
            height: 16.h,
          ),
          _divider(),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Padding(
        padding: EdgeInsets.only(left: 25.0.w),
        child: Image.asset(
          ImagePath.backCross,
          width: 17.48.w,
          height: 17.48.h,
        ),
      ),
    );
  }

  // 구분선
  Widget _divider() {
    return Divider(
      height: 0.3.h,
      color: UsedColor.line,
    );
  }
}
