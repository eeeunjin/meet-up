import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget header({required Widget? back, required title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 가로로 가운데 정렬
    children: [
      if (back != null) back,
      Expanded(
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 20.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      if (back != null) Container(width: 40.w), // 여백 조절
    ],
  );
}
