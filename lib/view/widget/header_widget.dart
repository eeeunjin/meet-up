import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';

Widget header({required Widget? back, required title}) {
  return SizedBox(
    height: 35.h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 가로로 가운데 정렬
      children: [
        if (back != null) back,
        Expanded(
          child: Center(
            child: Text(
              title,
              style: AppTextStyles.SU_R_20.copyWith(color: UsedColor.text_3),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (back != null) Container(width: 40.w), // 여백 조절
      ],
    ),
  );
}
