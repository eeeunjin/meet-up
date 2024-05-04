import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/util/color.dart';
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
    return Text(roomModel.room_name);
  }
}
