import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';

class ChatMain extends StatelessWidget {
  const ChatMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (Platform.isIOS)
            _header(context)
          else if (Platform.isAndroid)
            Padding(
              padding: EdgeInsets.only(
                top: 58.h,
              ),
              child: _header(context),
            ),
          // Expanded(child: _main(context)),
        ],
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // header(title: '채팅', back: null),
          Text(
            '채팅',
            style: AppTextStyles.SU_R_20.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            height: 0.3.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }
}
