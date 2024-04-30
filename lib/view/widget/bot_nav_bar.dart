import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/chat/chat_main.dart';
import 'package:meet_up/view/meet/meet_main.dart';
import 'package:meet_up/view/profile/profile_main.dart';
import 'package:meet_up/view/reflect/reflect_main.dart';
import 'package:meet_up/view/schedule/schedule_main.dart';
import 'package:meet_up/view_model/bot_nav_view_model.dart';
import 'package:provider/provider.dart';

class BotNavBar extends StatelessWidget {
  const BotNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavViewModel =
        Provider.of<BottomNavigationBarViewModel>(context);

    return PopScope(
        // 뒤로가기
        canPop: true,
        onPopInvoked: (didPop) {
          // 로직구현
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false, // 키보드 픽셀 over 방지
          body: SafeArea(
            child: IndexedStack(
              index: bottomNavViewModel.currentIndex,
              children: const [
                MeetMain(),
                ChatMain(),
                ScheduleMain(),
                ReflectMain(),
                ProfileMain(),
              ],
            ),
          ),
          bottomNavigationBar: _bot_nav(context),
        ));
  }

  Widget _bot_nav(BuildContext context) {
    final bottomNavViewModel =
        Provider.of<BottomNavigationBarViewModel>(context);

    return Container(
      height: 95.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // 색상
            spreadRadius: 10.r, // 그림자 확산 범위
            blurRadius: 15, // 그림자의 흐림 정도, 값이 클수록 흐릿해지면서 가장자리가 부드러워짐
            offset: Offset(0, 8.h), // 그림자 위치 y축으로 아래로 1만큼 감.
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        child: Theme(
          // 터치 시 잉크 효과 제거
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: bottomNavViewModel.currentIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: UsedColor.charcoal_black, // 선택된 라벨 색상
            unselectedItemColor: UsedColor.text_5, // 선택되지 않은 라벨 색상: 회색
            selectedLabelStyle: AppTextStyles.SU_R_11,
            unselectedLabelStyle: AppTextStyles.SU_R_11,
            backgroundColor: Colors.white,
            // 터치 애니메이션 제거
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              // viewmodel
              bottomNavViewModel.updateCurrentPage(index);
              // 경로 이동
            },
            items: [
              // index - 0
              BottomNavigationBarItem(
                icon: Image.asset(ImagePath.meetOff,
                    width: 33.14.w, height: 33.14.h),
                activeIcon: Image.asset(ImagePath.meetOn,
                    width: 33.14.w, height: 33.14.h),
                label: '만남',
              ),
              // index - 1
              BottomNavigationBarItem(
                icon: Image.asset(ImagePath.chatOff,
                    width: 33.14.w, height: 33.14.h),
                activeIcon: Image.asset(ImagePath.chatOn,
                    width: 33.14.w, height: 33.14.h),
                label: '채팅',
              ),
              // index - 2
              BottomNavigationBarItem(
                icon: Image.asset(ImagePath.scheduleOff,
                    width: 33.14.w, height: 33.14.h),
                activeIcon: Image.asset(ImagePath.scheduleOn,
                    width: 33.14.w, height: 33.14.h),
                label: '일정',
              ),
              // index - 3
              BottomNavigationBarItem(
                icon: Image.asset(
                  ImagePath.refOff,
                  width: 33.14.w,
                  height: 33.14.h,
                ),
                activeIcon: Image.asset(ImagePath.refOn,
                    width: 33.14.w, height: 33.14.h),
                label: '성찰',
              ),
              // index - 4
              BottomNavigationBarItem(
                icon: Image.asset(ImagePath.profileOff,
                    width: 33.14.w, height: 33.14.h),
                activeIcon: Image.asset(ImagePath.profileOff,
                    width: 33.14.w, height: 33.14.h),
                label: '프로필',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
