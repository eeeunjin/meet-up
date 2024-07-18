import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/good_history_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/coin/ticket_buy_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TicketBuy extends StatelessWidget {
  final String from;

  const TicketBuy({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
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
          SizedBox(height: 36.h),
          Padding(
            padding: EdgeInsets.only(left: 34.w),
            child: Text(
              '코인 보유 현황',
              style: AppTextStyles.SU_R_12.copyWith(color: UsedColor.text_3),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(left: 34.w),
            child: Text(
              '${userViewModel.userModel!.coin} C'.replaceAllMapped(
                  RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[0]},'),
              style: AppTextStyles.PR_SB_36
                  .copyWith(color: UsedColor.charcoal_black),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 36.h),
          // 단일권
          Padding(
            padding: EdgeInsets.only(left: 32.w),
            child: _ticketPriceContainer(
              context: context,
              isFixed: false,
            ),
          ),
          SizedBox(height: 24.h),
          // 정기권
          Padding(
            padding: EdgeInsets.only(left: 32.w),
            child: _ticketPriceContainer(
              context: context,
              isFixed: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '만남권 구매'),
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
    final ticketBuyViewModel =
        Provider.of<TicketBuyViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        ticketBuyViewModel.resetState();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  Widget _ticketPriceContainer({
    required BuildContext context,
    required bool isFixed,
  }) {
    final ticketBuyViewModel = Provider.of<TicketBuyViewModel>(context);
    return GestureDetector(
      onTap: () {
        ticketBuyViewModel.setTicketKind(isFixed);
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            final ticketBuyViewModel = Provider.of<TicketBuyViewModel>(context);
            return _bottomSheetPage(context, ticketBuyViewModel);
          },
        ).then(
          (value) {
            ticketBuyViewModel.resetState();
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 329.w,
            height: 61.h,
            decoration: BoxDecoration(
              color: ticketBuyViewModel.isFixed == isFixed
                  ? UsedColor.button
                  : Colors.white,
              borderRadius: BorderRadius.circular(21.r),
              border: Border.all(
                color: ticketBuyViewModel.isFixed == isFixed
                    ? UsedColor.button
                    : UsedColor.b_line,
                width: 2.5.h,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 28.w,
                right: 16.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    isFixed == false ? "단일권 1매" : "정기권 1매",
                    style: AppTextStyles.PR_M_18.copyWith(
                        color: ticketBuyViewModel.isFixed == isFixed
                            ? Colors.white
                            : UsedColor.charcoal_black),
                  ),
                  const Spacer(),
                  Text(
                    isFixed == false ? "1,000 C" : "4,000 C",
                    style: AppTextStyles.PR_SB_18.copyWith(
                      color: ticketBuyViewModel.isFixed == isFixed
                          ? Colors.white
                          : UsedColor.violet,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (ticketBuyViewModel.isFixed != null &&
              ticketBuyViewModel.isFixed == isFixed)
            Padding(
              padding: EdgeInsets.only(
                top: 12.h,
                left: 13.h,
              ),
              child: Text(
                ticketBuyViewModel.isFixed == false
                    ? ' - 단일권 1개 제공\n - 한 번에 3개까지 구매 가능 합니다.'
                    : ' - 만남 방 1회 생성 혹은 참여 가능\n - (추가 혜택 필요)',
                style: AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
                textAlign: TextAlign.start,
              ),
            ),
        ],
      ),
    );
  }

  Widget _bottomSheetPage(
      BuildContext context, TicketBuyViewModel ticketBuyViewModel) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Container(
      height: 318.h,
      width: 393.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(19.r),
          topRight: Radius.circular(19.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: UsedColor.selected,
              borderRadius: BorderRadius.circular(18.28.r),
            ),
          ),
          SizedBox(height: 40.h),
          Container(
            width: 321.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: UsedColor.image_card,
              borderRadius: BorderRadius.circular(19.r),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  ticketBuyViewModel.isFixed == false ? "단일권" : "정기권",
                  style: AppTextStyles.PR_R_16.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (ticketBuyViewModel.selectedNum > 1) {
                      ticketBuyViewModel
                          .setSelectedNum(ticketBuyViewModel.selectedNum - 1);
                    }
                  },
                  child: Image.asset(
                    ImagePath.minusButton,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                SizedBox(
                  width: 21.w,
                  child: Text(
                    ticketBuyViewModel.selectedNum.toString(),
                    style: AppTextStyles.PR_R_16.copyWith(
                      color: UsedColor.charcoal_black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                GestureDetector(
                  onTap: () {
                    if (ticketBuyViewModel.selectedNum < 3) {
                      ticketBuyViewModel
                          .setSelectedNum(ticketBuyViewModel.selectedNum + 1);
                    }
                  },
                  child: Image.asset(
                    ImagePath.plusButton,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              SizedBox(width: 47.w),
              Text(
                "총 수량",
                style: AppTextStyles.PR_R_16.copyWith(
                  color: UsedColor.text_3,
                ),
              ),
              SizedBox(
                width: 22.w,
              ),
              Text(
                "${ticketBuyViewModel.selectedNum}개",
                style: AppTextStyles.PR_R_16.copyWith(
                  color: UsedColor.charcoal_black,
                ),
              ),
              const Spacer(),
              Text(
                "총 금액",
                style: AppTextStyles.PR_R_16.copyWith(
                  color: UsedColor.text_3,
                ),
              ),
              SizedBox(
                width: 4.w,
              ),
              SizedBox(
                width: 78.w,
                child: Text(
                  ticketBuyViewModel.isFixed == false
                      ? "${ticketBuyViewModel.selectedNum * 1000}C"
                          .replaceAllMapped(
                              RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[0]},')
                      : "${ticketBuyViewModel.selectedNum * 4000}C"
                          .replaceAllMapped(
                              RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[0]},'),
                  style: AppTextStyles.PR_R_16.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                width: 36.h,
              )
            ],
          ),
          SizedBox(height: 36.h),
          GestureDetector(
            onTap: () async {
              final int totalCoin = ticketBuyViewModel.selectedNum *
                  (ticketBuyViewModel.isFixed == false ? 1000 : 4000);

              logger.d('총 결제 코인: $totalCoin');

              // MARK: - 만남권 결제
              // 유저 코인이 결제 코인보다 적은 경우
              if (totalCoin > userViewModel.userModel!.coin) {
                logger.e("유저의 코인이 부족합니다.");
                return;
              }

              // 유저 정보 업데이트
              int userCoin = userViewModel.userModel!.coin;
              int resultCoin = userCoin - totalCoin;
              int userTicket = userViewModel.userModel!.ticket;
              int resultTicket = userTicket +
                  ticketBuyViewModel.selectedNum *
                      ((ticketBuyViewModel.isFixed == false) ? 1 : 4);

              // DB에 정보 업데이트 및 view model 업데이트
              await userViewModel.updateUserInfo(
                data: {
                  "coin": resultCoin,
                  "ticket": resultTicket,
                  // if (ticketBuyViewModel.isFixed == true) "isFixedTicket": true,
                },
              );

              // GoodHistory Model 생성 및 DB에 저장
              final GoodHistoryModel goodHistoryModel = GoodHistoryModel(
                gh_type: GoodHistoryType.ticket.name,
                gh_type_transaction: GoodHistoryTypeOfTransaction.purchase.name,
                gh_uid: userViewModel.uid!,
                gh_result_coin: resultCoin,
                gh_result_ticket: resultTicket,
                gh_change_coin_amount: -totalCoin,
                gh_change_ticket_amount: ticketBuyViewModel.selectedNum *
                    ((ticketBuyViewModel.isFixed == false) ? 1 : 4),
                gh_product_id: '',
                gh_change_date: Timestamp.now(),
              );

              await ticketBuyViewModel.createGoodHistory(
                  goodHistoryModel: goodHistoryModel);

              // 결제 완료 페이지로 이동
              switch (from) {
                case 'MeetMain':
                  context.goNamed('ticketBuySuccessFromMeetMain');
                  break;
                case 'MeetManageMain':
                  context.goNamed('ticketBuySuccessFromMeetManageMain');
                  break;
                case 'ProfileMain':
                  context.goNamed('ticketBuySuccessFromProfileMain');
                  break;
              }
            },
            child: Container(
              width: 329.w,
              height: 56.h,
              decoration: BoxDecoration(
                color: UsedColor.button,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  "결제",
                  style: AppTextStyles.PR_SB_20.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
