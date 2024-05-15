import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class MeetUserInfo extends StatelessWidget {
  const MeetUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel()..loadUserModel(),
      child: Scaffold(
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
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(
            back: _back(context),
            title: '사용자 닉네임',
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
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        if (userViewModel.userModel == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          UserModel user = userViewModel.userModel!;
          return Container(
            color: Colors.white,
            child: Container(
              color: UsedColor.bg_color,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 32.h),
                      _profile(context, user),
                      SizedBox(height: 16.h),
                      _userInfo(context, userViewModel),
                      SizedBox(height: 16.h),
                      _userPersonality(context, user),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 120.r,
                    backgroundImage: NetworkImage(user.profile_icon),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 27.w,
                      height: 27.h,
                      decoration: BoxDecoration(
                        color: UsedColor.main,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0.w),
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
                  Container(
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
            color: UsedColor.bg_color,
          ),
          SizedBox(height: 17.h),
          Text(
            'Novice 등급',
            style: AppTextStyles.PR_M_16.copyWith(
              color: UsedColor.text_1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userInfo(BuildContext context, UserViewModel userViewModel) {
    UserModel user = userViewModel.userModel!;
    return Container(
      width: 337.w,
      height: 188.h,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userInfoDetail(ImagePath.infoIcon2, '성별', user.gender),
          _userInfoDetail(
              ImagePath.infoIcon3, '나이', userViewModel.getAgeRange()),
          _userInfoDetail(ImagePath.infoIcon4, '거주지', user.region['name']),
          _userInfoDetail(ImagePath.infoIcon5, '소속 분류', user.job),
        ],
      ),
    );
  }

  Widget _userInfoDetail(String imagePath, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Image.asset(imagePath, width: 24.w, height: 24.h),
          SizedBox(width: 24.w),
          Text(
            label,
            style: AppTextStyles.PR_M_16.copyWith(
              color: UsedColor.charcoal_black,
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            value,
            style: AppTextStyles.PR_M_13.copyWith(
              color: UsedColor.charcoal_black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userPersonality(BuildContext context, UserModel user) {
    return Container(
      width: 337.w,
      height: 303.h,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _personalityImage('성격', ImagePath.infoIcon6),
          SizedBox(height: 23.h),
          Wrap(
            spacing: 8.w,
            children: user.personality_self
                .map((trait) => _personalityChip(trait))
                .toList(),
          ),
          SizedBox(height: 31.h),
          _personalityImage('관심사', ImagePath.infoIcon7),
          SizedBox(height: 23.h),
          Wrap(
            spacing: 8.w,
            children: user.interest
                .map((interest) => _personalityChip(interest))
                .toList(),
          ),
          SizedBox(height: 31.h),
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
    return Chip(
      label: Text(
        label,
        style: AppTextStyles.SU_R_12.copyWith(
          color: UsedColor.violet,
        ),
      ),
      backgroundColor: UsedColor.image_card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
