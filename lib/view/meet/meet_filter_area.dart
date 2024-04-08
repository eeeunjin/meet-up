import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/meet_browse_view_model.dart';
import 'package:provider/provider.dart';

class MeetFilterArea extends StatelessWidget {
  const MeetFilterArea({super.key});

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
            // Expanded(child: _main(context)),
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
          header(back: _back(context), title: '지역 선택'),
          SizedBox(
            height: 22.h,
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
    return Padding(
      padding: EdgeInsets.only(left: 9.h),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image.asset(
          ImagePath.close,
          width: 40.w,
          height: 40.h,
        ),
      ),
    );
  }
}

// Widget _main(BuildContext context) {
//   return Container(
//     color: Colors.white,
//     child: SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.only(left: 20.w, right: 20.w),
//         child: Column(
//           children: [
//             // _category(context),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget _selectArea(BuildContext context) {}
