import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfileMain extends StatelessWidget {
  const ProfileMain({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final profileIcon = userViewModel.userModel!.profile_icon;
    final profileIconName = profileIcon.split('/').last.split('_').first;
    String path = '';
    switch (profileIconName) {
      case "fedro":
        path = ImagePath.fedroSelect;
      case "cogy":
        path = ImagePath.cogySelect;
      case "piggy":
        path = ImagePath.piggySelect;
      case "ham":
        path = ImagePath.hamSelect;
      case "aengmu":
        path = ImagePath.aengmuSelect;
    }
    // logger.d(path);
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
          // header(title: '채팅', back: null),
          Text(
            '프로필',
            style: AppTextStyles.SU_R_20.copyWith(color: UsedColor.text_3),
          ),
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

  Widget _main(BuildContext context) {
    return Container(
      color: UsedColor.bg_color,
      child: Column(
        children: [
          SizedBox(
            height: 14.h,
          ),
          _topButtons(context),
          SizedBox(height: 12.h),
          _profileBox(context),
          SizedBox(height: 32.h),
          _coinAndTicketBox(context),
          SizedBox(height: 16.h),
          _review(context),
        ],
      ),
    );
  }

  Widget _topButtons(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(right: 27.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 알림 버튼
          GestureDetector(
            onTap: () {
              context.push('/profileNoticationMain');
            },
            child: Container(
              width: 41.w,
              height: 22.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11.r),
                  color: Colors.white),
              child: Center(
                child: Text(
                  '알림',
                  style:
                      AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          // 설정 버튼
          GestureDetector(
            onTap: () async {
              await userViewModel.logout();
              while (context.canPop()) {
                context.pop();
              }
              // context.push('/settingMain');
            },
            child: Container(
              width: 41.w,
              height: 22.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11.r),
                  color: Colors.white),
              child: Center(
                child: Text(
                  '설정',
                  style:
                      AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileBox(BuildContext context) {
    return Container(
      width: 340.w,
      height: 176.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 프로필 이미지
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1.5.w, color: UsedColor.b_line),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 수정 버튼
                  Padding(
                    padding: EdgeInsets.only(left: 156.w, bottom: 8.h),
                    child: GestureDetector(
                      onTap: () {
                        // 수정 페이지
                        context.push('/profileEdit');
                      },
                      child: Image.asset(
                        ImagePath.profileEditIcon,
                        width: 32.w,
                        height: 32.h,
                      ),
                    ),
                  ),
                  // 사용자 닉네임
                  Padding(
                    padding: EdgeInsets.only(left: 24.0.w, bottom: 3.h),
                    child: Text(
                      '사용자 닉네임',
                      style: AppTextStyles.PR_SB_18
                          .copyWith(color: UsedColor.charcoal_black),
                    ),
                  ),
                  // 정기권 혜택 적용 중
                  Padding(
                    padding: EdgeInsets.only(left: 24.0.w),
                    child: Container(
                      width: 93.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.r),
                          color: UsedColor.image_card),
                      child: Center(
                        child: Text(
                          '정기권 혜택 적용 중',
                          style: AppTextStyles.PR_R_10
                              .copyWith(color: UsedColor.violet),
                        ),
                      ),
                    ),
                  ),
                  // Novice 혜택 보러가기
                  Padding(
                    padding: EdgeInsets.only(top: 24.0.h, left: 24.h),
                    child: Text(
                      'Novice 혜택 보러가기 >',
                      style: AppTextStyles.PR_R_12
                          .copyWith(color: UsedColor.text_5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coinAndTicketBox(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 코인 박스
        Container(
          width: 162.w,
          height: 96.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 24.0.w, top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '코인',
                  style: AppTextStyles.PR_SB_18
                      .copyWith(color: UsedColor.charcoal_black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        // 만남권 박스
        Container(
          width: 162.w,
          height: 96.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 24.0.w, top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '만남권',
                  style: AppTextStyles.PR_SB_18
                      .copyWith(color: UsedColor.charcoal_black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _review(BuildContext context) {
    return Container(
      width: 340.w,
      height: 95.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
    );
  }
}
