import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/coin_widget.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class MeetMain extends StatelessWidget {
  const MeetMain({super.key});

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
      // 만남방 개설하기 플로팅액션 버튼
      floatingActionButton: FloatingActionButton(
        heroTag: null, // 고유 태그 지정 - hero오류
        onPressed: () {
          // 만남권이 없는 경우 처리
          final userViewModel =
              Provider.of<UserViewModel>(context, listen: false);
          if (userViewModel.userModel?.ticket == 0) {
            _showNotPassedDialog(context, isTicketNotEough: true);
            return;
          }
          context.goNamed('meetCreate');
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // MARK: - 조건 검사 alert
  void _showNotPassedDialog(
    BuildContext context, {
    required bool isTicketNotEough,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Column(
          children: [
            Text(
              isTicketNotEough ? "소지하신 만남권이 부족하여" : "성비 별 자리가 부족하여",
              style: AppTextStyles.PR_SB_15
                  .copyWith(color: UsedColor.charcoal_black),
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              "만남 방을 개설할 수 없습니다.",
              style: AppTextStyles.PR_SB_15
                  .copyWith(color: UsedColor.charcoal_black),
            )
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              "확인",
              style: AppTextStyles.PR_M_13.copyWith(color: Colors.black),
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(title: '만남', back: null),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(height: 15.h),
            ),
            _coinWidget(context),
            SizedBox(height: 15.h),
            _event(),
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _manageMeetList(context),
            ),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _searchMeetList(context),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - 내가 만든 만남방
  Widget _manageMeetList(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed('meetManageMain');
      },
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                ImagePath.meetIcon1,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                '내가 만든 만남방을 관리해보세요!',
                style: AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: 353.w,
            height: 115.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19.r),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25.h,
                      ),
                      Row(
                        children: [
                          Text(
                            '내가 만든 ',
                            style: AppTextStyles.PR_SB_20
                                .copyWith(color: UsedColor.violet),
                          ),
                          Text('만남방', style: AppTextStyles.PR_SB_20),
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        '더보기 >',
                        style: AppTextStyles.SU_R_12
                            .copyWith(color: UsedColor.text_5),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 110.w,
                ),
                Image.asset(
                  ImagePath.meetImage1,
                  width: 70.w,
                  height: 70.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - 만남방 둘러보기
  Widget _searchMeetList(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed('meetBrowseMain');
      },
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                ImagePath.meetIcon2,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                '나에게 맞는 만남방을 찾아보세요!',
                style: AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: 353.w,
            height: 115.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19.r),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25.h,
                      ),
                      Row(
                        children: [
                          Text('만남방', style: AppTextStyles.PR_SB_20),
                          Text(
                            ' 둘러보기',
                            style: AppTextStyles.PR_SB_20
                                .copyWith(color: UsedColor.violet),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        '더보기 >',
                        style: AppTextStyles.SU_R_12
                            .copyWith(color: UsedColor.text_5),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 110.w,
                ),
                Image.asset(
                  ImagePath.meetImage2,
                  width: 70.w,
                  height: 70.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - 이벤트 배너
  Widget _event() {
    return SizedBox(
      width: double.infinity,
      height: 120.h,
      child: Image.asset(ImagePath.eventImage1),
    );
  }

  Widget _coinWidget(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(right: 8.0.h),
      child: GestureDetector(
        onTap: () {
          context.goNamed('coinMainFromMeetMain');
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: CoinWidget(
            coinAmount: userViewModel.userModel?.coin ?? -1,
            ticketAmount: userViewModel.userModel?.ticket ?? -1,
          ),
        ),
      ),
    );
  }
}
