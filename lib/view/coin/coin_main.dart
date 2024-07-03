import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class CoinMain extends StatelessWidget {
  final String from;

  const CoinMain({super.key, required this.from});

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
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 24.0.h),
                  _currentCoin(context),
                  SizedBox(height: 44.0.h),
                  _currentTicket(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '코인/만남권'),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            thickness: 0.3.w,
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

  Widget _currentCoin(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(left: 19.0.w, right: 19.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 9.w),
            child: Padding(
              padding: EdgeInsets.only(left: 12.0.w),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '코인 보유 현황',
                        style: AppTextStyles.SU_R_15
                            .copyWith(color: UsedColor.text_3),
                      ),
                      SizedBox(height: 13.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${userViewModel.userModel!.coin} C',
                            style: AppTextStyles.PR_SB_30
                                .copyWith(color: UsedColor.charcoal_black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 28.63.w,
                    top: 39.75.h,
                    child: Image.asset(
                      ImagePath.nextArrow,
                      width: 7.75.w,
                      height: 15.5.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 22.h),
          GestureDetector(
            onTap: () {
              switch (from) {
                case 'MeetMain':
                  context.goNamed('coinBuyFromMeetMain');
                  break;
                case 'MeetManageMain':
                  context.goNamed('coinBuyFromMeetManageMain');
                  break;
                case 'ProfileMain':
                  context.goNamed('coinBuyFromProfileMain');
                  break;
              }
            },
            child: Container(
              width: 332.w,
              height: 51.h,
              decoration: BoxDecoration(
                color: UsedColor.button,
                borderRadius: BorderRadius.circular(19.r),
              ),
              child: Center(
                child: Text(
                  '코인 구매',
                  style: AppTextStyles.PR_SB_18.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentTicket(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(left: 19.0.w, right: 19.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 9.w),
            child: Padding(
              padding: EdgeInsets.only(left: 12.0.w),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '만남권 보유 현황',
                        style: AppTextStyles.SU_R_15
                            .copyWith(color: UsedColor.text_3),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '만남권 ${userViewModel.userModel!.ticket}개',
                            style: AppTextStyles.PR_SB_26
                                .copyWith(color: UsedColor.charcoal_black),
                          ),
                          SizedBox(width: 12.w),
                          //MARK: - 정기권 혜택 적용 여부 컨테이너
                          if (userViewModel.userModel!.isFixedTicket)
                            Container(
                              width: 96.w,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: UsedColor.image_card,
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Center(
                                child: Text(
                                  '정기권 혜택 적용 중',
                                  style: AppTextStyles.SU_R_11
                                      .copyWith(color: UsedColor.violet),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 28.63.w,
                    top: 39.75.h,
                    child: Image.asset(
                      ImagePath.nextArrow,
                      width: 7.75.w,
                      height: 15.5.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 22.h),
          GestureDetector(
            onTap: () {
              switch (from) {
                case 'MeetMain':
                  context.goNamed('ticketBuyFromMeetMain');
                  break;
                case 'MeetManageMain':
                  context.goNamed('ticketBuyFromMeetManageMain');
                  break;
                case 'ProfileMain':
                  context.goNamed('ticketBuyFromProfileMain');
                  break;
              }
            },
            child: Container(
              width: 332.w,
              height: 51.h,
              decoration: BoxDecoration(
                color: UsedColor.button,
                borderRadius: BorderRadius.circular(19.r),
              ),
              child: Center(
                child: Text(
                  '만남권 구매',
                  style: AppTextStyles.PR_SB_18.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
