import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      child: SingleChildScrollView(
          // child: Padding(
          // padding: EdgeInsets.only(
          //   left: 20.0.w,
          //   right: 20.0.w,
          // ),
          child: Column(children: [
        SizedBox(height: 39.h),
        _search(context),
        SizedBox(height: 23.h),
        _filter(context),
        SizedBox(height: 21.h),
        _divider(),
        SizedBox(height: 28.h),
        // _meetingRoom(context),
      ])),
    );
  }

  Widget _search(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return SingleChildScrollView(
      child: SizedBox(
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

              hintStyle:
                  AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
            ),
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }

  Widget _filter(BuildContext context) {
    List<String> filters = ['카테고리', '지역', '나이', '성비', '세부규칙'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 4.0.w,
        children: filters.map((category) {
          double buttonWidth = 70.w;
          if (category.length == 4) {
            buttonWidth = 90.w;
          }
          return SizedBox(
            width: buttonWidth,
            height: 34.h,
            child: ElevatedButton(
              onPressed: () {
                context.goNamed('meetFilterMain');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                // backgroundColor: Colors.white,
                side: BorderSide(
                  color: UsedColor.button_g,
                  width: 1.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(category,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.PR_M_12.copyWith(
                          color: UsedColor.text_2,
                        )),
                  ),
                  //  const Spacer(),
                  Image.asset(
                    ImagePath.vector,
                    width: 9.w,
                    height: 9.h,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Widget _meetingRoom(BuildContext context) {}
