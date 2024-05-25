import 'package:flutter/cupertino.dart';
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
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        _profileImage(context),
        SizedBox(height: 32.h),
        // MARK: - 닉네임
        Text(
          '닉네임',
          style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
        ),
      ],
    );
  }

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
    return //MARK: - 프로필 사진
        Center(
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
}
