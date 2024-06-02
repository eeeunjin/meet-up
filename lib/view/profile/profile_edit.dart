import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({super.key});

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
          header(back: _back(context), title: '프로필'),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            thickness: 0.3.h,
            height: 0.h,
            color: UsedColor.line,
          )
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

  Widget _main(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          _profileImage(context),
          SizedBox(height: 32.h),
          _nickname(context),
          SizedBox(height: 32.h),
          _gender(context),
          SizedBox(height: 32.h),
          _age(context),
          SizedBox(height: 32.h),
          _address(context),
          SizedBox(height: 32.h),
          _classification(context),
          SizedBox(height: 32.h),
          _personality(context),
          // SizedBox(height: 32.h),
          // Text(
          //   '관심사',
          //   style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          // ),
          // SizedBox(height: 8.h),
          // _interests(context),
          // SizedBox(height: 32.h),
          // Text(
          //   '만남 목적',
          //   style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          // ),
          // SizedBox(height: 8.h),
          // _meetingPurpose(context),
          // SizedBox(height: 42.h),
        ],
      ),
    );
  }

  //MAKR: - 프로필 사진
  Widget _profileImage(BuildContext context) {
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
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1.5.w, color: UsedColor.b_line),
            ),
            child: Image.asset(path),
          ),
          Positioned(
            bottom: 0.h,
            right: 2.w,
            child: Image.asset(
              ImagePath.profileImageEditIcon,
              width: 32.w,
              height: 32.h,
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - 닉네임
  Widget _nickname(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '닉네임',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: TextEditingController(
                text: userViewModel.userModel?.nickname ?? ''),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              isDense: true,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: UsedColor.line, width: 0.5.h),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: UsedColor.line, width: 0.5.h),
              ),
            ),
            style:
                AppTextStyles.PR_R_16.copyWith(color: UsedColor.charcoal_black),
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  //MARK: - 성별
  Widget _gender(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '성별',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 16.h),
          Text(
            userViewModel.userModel!.gender == 'male' ? '남성' : '여성',
            style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.line,
          )
        ],
      ),
    );
  }

  // MARK: - 나이
  Widget _age(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    // 나이 계산
    final DateTime? birthDate = userViewModel.userModel?.birthday;

    int calculateAge(DateTime? birthDate) {
      if (birthDate == null) {
        return 0;
      }
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    }

    final int age = calculateAge(birthDate) + 2;

    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나이',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 16.h),
          Text(
            // TODO : 나이 변경 로직 으로 나이 계산해서 표시하기
            '$age',
            style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.line,
          )
        ],
      ),
    );
  }

  // MARK: - 주소
  Widget _address(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '주소',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 16.h),
          Text(
            '거주지',
            style:
                AppTextStyles.PR_R_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  //MARK: - 소속 분류
  Widget _classification(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '소속 분류',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 16.h),
          Text(
            '소속 분류',
            style:
                AppTextStyles.PR_R_16.copyWith(color: UsedColor.charcoal_black),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  //MARK: - 성격
  Widget _personality(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final List<dynamic> personalityListDynamic =
        userViewModel.userModel?.personality_self ?? [];
    final List<String> personalityList = personalityListDynamic.cast<String>();

    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '성격',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: personalityList.map((personality) {
              return Padding(
                padding: EdgeInsets.only(left: 8.0.w),
                child: Container(
                  width: 80.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: UsedColor.image_card,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      personality,
                      style: AppTextStyles.PR_R_14
                          .copyWith(color: UsedColor.text_3),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  // Widget _interests(BuildContext context) {}

  // Widget _meetingPurpose(BuildContext context) {}
}
