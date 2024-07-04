import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/coin/coin_buy_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:provider/provider.dart';

class CoinBuySuccess extends StatelessWidget {
  final String from;

  const CoinBuySuccess({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    final coinBuyViewModel =
        Provider.of<CoinBuyViewModel>(context, listen: true);

    switch (coinBuyViewModel.purchaseStatus) {
      case 'init' || 'pending':
        return const Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      case 'purchased':
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // MARK: - 헤더
                Padding(
                  padding: EdgeInsets.only(
                    top: 58.h,
                  ),
                  child: _header(context),
                ),
                // MARK: - 바디
                SizedBox(
                  height: 140.h,
                ),
                Container(
                  height: 184.h,
                  width: 265.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    color: UsedColor.image_card,
                  ),
                  child: Image.asset(
                    ImagePath.purchaseCompleteIcon,
                    width: 93.17.w,
                    height: 93.17.h,
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  "결제가 완료되었어요!",
                  style: AppTextStyles.SU_R_20.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
                SizedBox(
                  height: 231.h,
                ),
                GestureDetector(
                  onTap: () {
                    // 코인/만남권 페이지로 이동
                    for (int i = 0; i < 3; i++) {
                      context.pop();
                    }
                    coinBuyViewModel.setPurchaseStatus('init');
                  },
                  child: Container(
                    width: 329.w,
                    height: 56.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: UsedColor.button,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      "확인",
                      style:
                          AppTextStyles.PR_SB_20.copyWith(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      case 'error' || 'canceled':
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // MARK: - 헤더
                Padding(
                  padding: EdgeInsets.only(
                    top: 58.h,
                  ),
                  child: _header(context),
                ),
                // MARK: - 바디
                SizedBox(
                  height: 140.h,
                ),
                Container(
                  height: 184.h,
                  width: 265.w,
                  decoration: BoxDecoration(
                    color: UsedColor.image_card,
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  coinBuyViewModel.purchaseStatus == 'error'
                      ? "결제 중 오류가 발생하였습니다."
                      : "결제가 취소되었습니다.",
                  style: AppTextStyles.SU_R_20.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
                SizedBox(
                  height: 231.h,
                ),
                GestureDetector(
                  onTap: () {
                    for (int i = 0; i < 2; i++) {
                      context.pop();
                    }
                    coinBuyViewModel.setPurchaseStatus('init');
                  },
                  child: Container(
                    width: 329.w,
                    height: 56.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: UsedColor.button,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      "뒤로가기",
                      style:
                          AppTextStyles.PR_SB_20.copyWith(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      default:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }

  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: null, title: '상품 결제'),
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
}
