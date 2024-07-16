import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/profile/profile_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfileMain extends StatelessWidget {
  const ProfileMain({super.key});

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
          header(title: '프로필', back: null),
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
    return Padding(
      padding: EdgeInsets.only(right: 27.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 알림 버튼
          GestureDetector(
            onTap: () {
              context.goNamed('profileNoticationMain');
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
              context.goNamed('settingMain');
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
    final userViewModel = Provider.of<UserViewModel>(context);
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
              child: Image.asset(path),
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
                        logger.d(
                            'userModel: ${userViewModel.userModel!.toJson()}');

                        final profileViewModel = Provider.of<ProfileViewModel>(
                            context,
                            listen: false);
                        profileViewModel.resetProfileInfo();
                        profileViewModel
                            .initializeProfileInfo(userViewModel.userModel!);
                        context.pushNamed('profileEdit');
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
                      userViewModel.userModel!.nickname,
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
                  GestureDetector(
                    onTap: () {
                      context.goNamed('rankMain');
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 24.0.h, left: 24.h),
                      child: Text(
                        'Novice 혜택 보러가기 >',
                        style: AppTextStyles.PR_R_12
                            .copyWith(color: UsedColor.text_5),
                      ),
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

  //MARK: - 코인,티켓 박스
  Widget _coinAndTicketBox(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return GestureDetector(
      onTap: () {
        context.goNamed('coinMainFromProfileMain');
      },
      child: Row(
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
                  SizedBox(height: 9.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        ImagePath.profileCoinIcon,
                        width: 32.w,
                        height: 32.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 7.0.h, left: 7.w),
                        child: Text(
                          '${userViewModel.userModel!.coin} C',
                          style: AppTextStyles.PR_R_14
                              .copyWith(color: UsedColor.charcoal_black),
                        ),
                      ),
                    ],
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
                  SizedBox(height: 9.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        ImagePath.profileTicketIcon,
                        width: 32.w,
                        height: 32.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 7.0.h, left: 7.w),
                        child: Text(
                          '${userViewModel.userModel!.ticket}장',
                          style: AppTextStyles.PR_R_14
                              .copyWith(color: UsedColor.charcoal_black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//MARK: - 만남 후기
  Widget _review(BuildContext context) {
    return Container(
      width: 340.w,
      height: 95.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, top: 20.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '만남 후기',
                      style: AppTextStyles.PR_SB_18
                          .copyWith(color: UsedColor.charcoal_black),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0.h, left: 7.w),
                      child: Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: UsedColor.main),
                        // 후기 알림 수
                        child: Center(
                            child: Text(
                          '3',
                          style: AppTextStyles.SU_SB_10
                              .copyWith(color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  '상대방에게 받은 만남 후기를 확인해보세요',
                  style:
                      AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_5),
                )
              ],
            ),
            SizedBox(width: 35.w),
            Image.asset(
              ImagePath.profileReviewIcon,
              width: 56.w,
              height: 56.h,
            )
          ],
        ),
      ),
    );
  }
}
