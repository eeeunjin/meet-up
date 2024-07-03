import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/good_history_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/coin/coin_purchase_history_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class CoinPurchaseHistory extends StatelessWidget {
  const CoinPurchaseHistory({super.key});

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

  //header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '코인 이용 내역'),
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

  Widget _main(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final coinPurchaseHistoryViewModel =
        Provider.of<CoinPurchaseHistoryViewModel>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 58.0.h,
          ),
          Text(
            '코인 보유 현황',
            style: AppTextStyles.SU_R_12.copyWith(
              color: UsedColor.text_3,
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          Text(
            "${userViewModel.userModel!.coin} C".replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},'),
            style: AppTextStyles.PR_SB_36.copyWith(
              color: UsedColor.charcoal_black,
            ),
          ),
          SizedBox(
            height: 16.0.h,
          ),
          Divider(
            thickness: 1.5.w,
            height: 0.h,
            color: UsedColor.b_line,
          ),
          SizedBox(
            height: 32.h,
          ),
          Expanded(
            child: FutureBuilder(
              future: coinPurchaseHistoryViewModel.getAllGoodHistory(
                  uid: userViewModel.uid!, type: GoodHistoryType.coin.name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('오류가 발생했습니다.'),
                  );
                } else {
                  // 날짜로 그룹화
                  Map<String, List<GoodHistoryModel>> groupedByDate = {};
                  for (var gh in snapshot.data as List<GoodHistoryModel>) {
                    var timestamp = gh.gh_change_date;
                    var date = timestamp.toDate();
                    String formattedDate =
                        DateFormat('yyyy.MM.dd').format(date);
                    groupedByDate[formattedDate] ??= [];
                    groupedByDate[formattedDate]!.add(gh);
                  }

                  List<Widget> dateSections = [];
                  groupedByDate.forEach(
                    (date, goodhistories) {
                      dateSections.add(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date,
                              style: AppTextStyles.SU_R_12.copyWith(
                                color: UsedColor.text_3,
                              ),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            Column(
                              children: goodhistories.map(
                                (goodHistoryModel) {
                                  String transactionTitle = "";
                                  bool changingAmountLessThanZero =
                                      goodHistoryModel.gh_change_coin_amount <
                                          0;
                                  String changeContent = changingAmountLessThanZero
                                      ? '${goodHistoryModel.gh_change_coin_amount} C'
                                      : '+${goodHistoryModel.gh_change_coin_amount} C';

                                  if (goodHistoryModel.gh_type == 'coin') {
                                    switch (
                                        goodHistoryModel.gh_type_transaction) {
                                      case 'purchase':
                                        transactionTitle = '코인 충전';
                                      case 'obtain':
                                        transactionTitle = '코인 획득';
                                      case 'refund':
                                        transactionTitle = '코인 환불';
                                      case 'default':
                                        logger.e("[코인 내역] 오류");
                                        transactionTitle = '오류';
                                    }
                                  } else {
                                    switch (
                                        goodHistoryModel.gh_type_transaction) {
                                      case 'purchase':
                                        transactionTitle =
                                            '단일권 ${goodHistoryModel.gh_change_ticket_amount}개 구매';
                                      case 'refund':
                                        transactionTitle =
                                            '단일권 ${goodHistoryModel.gh_change_ticket_amount}개 환불';
                                      default:
                                        logger.e("[코인 내역] 오류");
                                        transactionTitle = '오류';
                                    }
                                  }

                                  return Container(
                                    width: 329.w,
                                    height: 72.h,
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          transactionTitle,
                                          style: AppTextStyles.PR_SB_15
                                              .copyWith(
                                                  color:
                                                      UsedColor.charcoal_black),
                                        ),
                                        const Spacer(),
                                        Text(
                                          changeContent,
                                          style: AppTextStyles.PR_SB_15
                                              .copyWith(
                                                  color:
                                                      changingAmountLessThanZero
                                                          ? UsedColor.red
                                                          : UsedColor.violet),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                            SizedBox(height: 18.h),
                          ],
                        ),
                      );
                    },
                  );

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                    child: SingleChildScrollView(
                      child: Column(
                        children: dateSections,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
