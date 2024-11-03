import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';

class ProfileNotification extends StatelessWidget {
  const ProfileNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 58.h),
            child: _header(context),
          ),
          Expanded(child: _main(context)),
        ],
      ),
    );
  }

  // header 부분
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '알림'),
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

  // MARK:-main
  Widget _main(BuildContext context) {
    List<bool> isNewNotification = [true, false, false, false, false, false];

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: isNewNotification.length + 1,
        itemBuilder: (context, index) {
          if (index < isNewNotification.length) {
            // 알림 항목
            return _notificationItem(context, isNewNotification[index]);
          } else {
            // 마지막 항목: 문구
            return Padding(
              padding: EdgeInsets.only(
                top: 40.h,
                bottom: 110.h,
              ),
              child: Center(
                child: Text(
                  "알람은 30일 이후 순차적으로 삭제됩니다.",
                  style: AppTextStyles.SU_R_11.copyWith(
                    color: UsedColor.text_5,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // MARK:- 알림 항목
  Widget _notificationItem(BuildContext context, bool isNew) {
    return Container(
      width: 393.w,
      decoration: BoxDecoration(
        color: isNew ? UsedColor.image_card : Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 28.w, top: 14.h, bottom: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(ImagePath.profileNotification,
                    width: 8.w, height: 8.h),
                SizedBox(width: 2.w),
                Text(
                  "이벤트",
                  style: AppTextStyles.SU_R_10.copyWith(
                    color: UsedColor.text_3,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "000 콜라보 이벤트가 시작되었습니다!",
              style: AppTextStyles.PR_M_18.copyWith(
                color: isNew ? UsedColor.violet : Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "000하고 00코인 받을 수 있는 이벤트에 참여해 보세요!",
              style: AppTextStyles.SU_R_11.copyWith(
                color: UsedColor.text_5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
