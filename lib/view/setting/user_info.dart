import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/setting/setting_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          header(back: _back(context), title: '회원 정보'),
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

  Widget _main(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final settingViewModel =
        Provider.of<SettingViewModel>(context, listen: false);

    String formattedPhoneNumber = settingViewModel
        .formatPhoneNumber(userViewModel.userModel!.phone_number);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0.h),
        Padding(
          padding: EdgeInsets.only(left: 33.w),
          child: Text(
            '연동된 연락처',
            style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_3),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.only(left: 33.w),
          child: Text(
            formattedPhoneNumber,
            style: AppTextStyles.PR_M_20
                .copyWith(color: UsedColor.charcoal_black), // 원하는 스타일로 변경
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.only(left: 27.0.w, right: 26.w),
          child: Divider(
            thickness: 0.3.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ),
        const Spacer(),
        // MARK: - 로그아웃, 회원탈퇴
        Padding(
          padding: EdgeInsets.only(
            bottom: 75.0.h,
            left: 118.w,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await userViewModel.logout();
                  while (context.canPop()) {
                    context.pop();
                  }
                },
                child: SizedBox(
                  width: 52.w,
                  height: 24.h,
                  child: Text(
                    '로그아웃',
                    style:
                        AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
                  ),
                ),
              ),
              SizedBox(width: 54.w),
              SizedBox(
                width: 52.w,
                height: 24.h,
                child: Text(
                  '회원탈퇴',
                  style:
                      AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
