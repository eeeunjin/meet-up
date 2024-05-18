import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_user_info_view_model.dart';
import 'package:provider/provider.dart';

class MeetUserInfo extends StatelessWidget {
  const MeetUserInfo({super.key});

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
          _divider(),
          Expanded(child: _main(context)),
        ],
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    final meetUserInfoViewModel =
        Provider.of<MeetUserInfoViewModel>(context, listen: false);
    return Center(
      child: Column(
        children: [
          header(
            back: _back(context),
            title: meetUserInfoViewModel.userModel!.nickname,
          ),
          SizedBox(
            height: 16.h,
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
          context.pop();
        },
        child: Image.asset(
          ImagePath.back,
          width: 10.w,
          height: 20.h,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      thickness: 0.3.h,
      height: 0.h,
      color: const Color(0xffd9d9d9),
    );
  }

  Widget _main(BuildContext context) {
    return Consumer<MeetUserInfoViewModel>(
      builder: (context, meetUserInfoViewModel, child) {
        if (meetUserInfoViewModel.userModel == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          UserModel user = meetUserInfoViewModel.userModel!;
          return Container(
            color: Colors.white,
            child: Container(
              color: UsedColor.bg_color,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 32.h),
                      _profile(context, user),
                      SizedBox(height: 16.h),
                      _userInfo(context, meetUserInfoViewModel),
                      SizedBox(height: 16.h),
                      _userPersonality(context, user),
                      SizedBox(height: 47.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _profile(BuildContext context, UserModel user) {
    return Container(
      width: 340.w,
      height: 227.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 27.0.h),
          Row(
            children: [
              SizedBox(width: 23.0.w),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: UsedColor.b_line,
                        width: 1.5.h,
                      ),
                      borderRadius: BorderRadius.circular(120.r),
                    ),
                    child: Image.asset(
                      user.profile_icon,
                      height: 120.h,
                      width: 120.w,
                    ),
                  ),
                  Positioned(
                    top: 15.0.h,
                    right: 0.w,
                    child: Container(
                      width: 27.w,
                      height: 27.h,
                      decoration: BoxDecoration(
                        color: UsedColor.main,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 4.0.h,
                          right: 4.0.w,
                          left: 5.0.w,
                          bottom: 5.0.h,
                        ),
                        child: Image.asset(
                          ImagePath.infoIcon1,
                          height: 18.h,
                          width: 18.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 21.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.nickname,
                    style: AppTextStyles.PR_SB_18.copyWith(
                      color: UsedColor.charcoal_black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (!user.isFixedTicket)
                    Container(
                      height: 20.h,
                      width: 104.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: UsedColor.image_card,
                        borderRadius: BorderRadius.circular(9.r),
                      ),
                      child: Text(
                        '정기권 혜택 적용중',
                        style: AppTextStyles.SU_M_12.copyWith(
                          color: UsedColor.violet,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Divider(
            thickness: 1.5.h,
            height: 1.0.h,
            color: UsedColor.bg_color,
          ),
          SizedBox(height: 17.h),
          Center(
            child: Text(
              '${user.rank} 등급',
              style: AppTextStyles.PR_M_16.copyWith(
                color: UsedColor.text_1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userInfo(
      BuildContext context, MeetUserInfoViewModel meetUserInfoViewModel) {
    UserModel user = meetUserInfoViewModel.userModel!;
    return Container(
      width: 337.w,
      height: 188.h,
      padding: EdgeInsets.symmetric(horizontal: 28.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0.h),
          _userInfoDetail(
              ImagePath.infoIcon2, meetUserInfoViewModel.convertGenderToKor()),
          SizedBox(height: 20.0.h),
          _userInfoDetail(
              ImagePath.infoIcon3, meetUserInfoViewModel.getAgeRange()),
          SizedBox(height: 20.0.h),
          _userInfoDetail(ImagePath.infoIcon4,
              user.region['province'] + " > " + user.region['district']),
          SizedBox(height: 20.0.h),
          _userInfoDetail(ImagePath.infoIcon5,
              meetUserInfoViewModel.convertAffliationToKor()),
        ],
      ),
    );
  }

  Widget _userInfoDetail(String imagePath, String value) {
    return Row(
      children: [
        Image.asset(imagePath, width: 24.w, height: 24.h),
        SizedBox(width: 24.w),
        Text(
          value,
          style: AppTextStyles.PR_M_16.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
      ],
    );
  }

  Widget _userPersonality(BuildContext context, UserModel user) {
    return Container(
      width: 337.w,
      height: 303.h,
      padding: EdgeInsets.symmetric(horizontal: 28.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          _personalityImage('성격', ImagePath.infoIcon6),
          SizedBox(height: 20.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var trait in user.personality_self) ...[
                _personalityChip(trait),
                SizedBox(
                  width: 8.0.w,
                )
              ]
            ],
          ),
          SizedBox(height: 30.h),
          _personalityImage('관심사', ImagePath.infoIcon7),
          SizedBox(height: 23.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var interest in user.interest) ...[
                _personalityChip(interest),
                SizedBox(
                  width: 8.0.w,
                )
              ]
            ],
          ),
          SizedBox(height: 30.h),
          _personalityImage('만남 목적', ImagePath.infoIcon8),
          SizedBox(height: 23.h),
          Wrap(
            spacing: 8.w,
            children: user.purpose
                .map((purpose) => _personalityChip(purpose))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _personalityImage(String title, String imagePath) {
    return Row(
      children: [
        Image.asset(imagePath, width: 24.w, height: 24.h),
        SizedBox(width: 16.w),
        Text(
          title,
          style: AppTextStyles.PR_M_16.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
      ],
    );
  }

  Widget _personalityChip(String label) {
    return Container(
      height: 24.h,
      width: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: UsedColor.image_card,
      ),
      child: Center(
        child: Text(
          label,
          style: AppTextStyles.SU_R_12.copyWith(
            color: UsedColor.violet,
          ),
        ),
      ),
    );
  }
}
