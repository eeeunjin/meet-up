import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/view/reflect/reflect_diary_details.dart';
import 'package:meet_up/view/reflect/reflect_writing_diary.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';

class ReflectMain extends StatelessWidget {
  const ReflectMain({super.key});

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
          header(title: '성찰', back: null),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            thickness: 0.3.h,
            height: 0.h,
            color: UsedColor.line,
          ),
          _writingDiary(context),
        ],
      ),
    );
  }

  Widget _writingDiary(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: UsedColor.bg_color,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ReflectWritingDiary()),
            );
          },
          child: const Text('일기 쓰기'),
        ),
      ),
    );
  }

  // Widget _diaryDetails(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.all(16.w),
  //     color: UsedColor.bg_color,
  //     child: Center(
  //       child: ElevatedButton(
  //         onPressed: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => const ReflectDiaryDetails()),
  //           );
  //         },
  //         child: const Text('일기 상세 보기'),
  //       ),
  //     ),
  //   );
  // }

  Widget _main(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.goNamed('chatScheduleHost');
          },
          child: Container(
            width: 100.w,
            height: 50.h,
            color: Colors.red,
            child: const Center(child: Text('TEST')),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.goNamed('chatScheduleHostView');
          },
          child: Container(
            width: 100.w,
            height: 50.h,
            color: Colors.blue,
            child: const Center(child: Text('HOSTVIEWTEST')),
          ),
        ),
      ],
    );
  }
}
