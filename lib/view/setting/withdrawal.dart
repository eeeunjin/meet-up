import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';

class Withdrawal extends StatelessWidget {
  const Withdrawal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 58.h,
            ),
            child: _header(context),
          ),
          Expanded(child: _main(context)),
        ],
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '탈퇴'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.only(left: 32.0.w),
          child: Text(
            '탈퇴 사유를 알려주시면\n개선을 위해 노력하겠습니다.',
            style: AppTextStyles.PR_SB_18
                .copyWith(color: UsedColor.charcoal_black),
          ),
        ),
        SizedBox(height: 28.h),
        Padding(
          padding: EdgeInsets.only(left: 32.0.w),
          child: Text(
            '복수 선택 가능',
            style: AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
          ),
        ),
        // 선택 리스트
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(left: 33.0.w, right: 32.w, bottom: 56.h),
          child: _nextbutton(),
        ),
      ],
    );
  }

  Widget _nextbutton() {
    return NextButton(
      onTap: () {},
      height: 56.h,
      text: '다음',
      // enable: ,
      textStyle: AppTextStyles.PR_SB_20.copyWith(color: Colors.white),
    );
  }
}
