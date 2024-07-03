import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/purchase.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/coin/coin_buy_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:provider/provider.dart';

class CoinBuy extends StatelessWidget {
  final String from;

  const CoinBuy({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 58.h,
            ),
            child: _header(context),
          ),
          SizedBox(height: 28.h),
          _coinPriceContainer(
              context: context, coinAmount: CoinAmount.oneThousand),
          SizedBox(height: 24.h),
          _coinPriceContainer(
              context: context, coinAmount: CoinAmount.fourThousand),
          SizedBox(height: 28.h),
          Text(
            "하나의 상품은 최대 3개까지 구매 가능합니다.",
            style: AppTextStyles.PR_B_12.copyWith(
              color: UsedColor.text_5,
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
    final coinBuyViewModel =
        Provider.of<CoinBuyViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        coinBuyViewModel.resetState();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  Widget _coinPriceContainer({
    required BuildContext context,
    required CoinAmount coinAmount,
  }) {
    final coinBuyViewModel = Provider.of<CoinBuyViewModel>(context);
    return GestureDetector(
      onTap: () {
        coinBuyViewModel.setCoinAmount(coinAmount);
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            final coinBuyViewModel = Provider.of<CoinBuyViewModel>(context);
            return _bottomSheetPage(context, coinBuyViewModel);
          },
        ).then(
          (value) {
            coinBuyViewModel.resetState();
          },
        );
      },
      child: Container(
        width: 329.w,
        height: 61.h,
        decoration: BoxDecoration(
          color: coinBuyViewModel.coinAmount == coinAmount
              ? UsedColor.button
              : Colors.white,
          borderRadius: BorderRadius.circular(21.r),
          border: Border.all(
            color: coinBuyViewModel.coinAmount == coinAmount
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
                coinAmount == CoinAmount.oneThousand ? "1,000 C" : "4,000 C",
                style: AppTextStyles.PR_M_18.copyWith(
                    color: coinBuyViewModel.coinAmount == coinAmount
                        ? Colors.white
                        : UsedColor.charcoal_black),
              ),
              SizedBox(
                width: 12.w,
              ),
              Text(
                coinAmount == CoinAmount.oneThousand ? "(단일권 1매)" : "(정기권 1매)",
                style: AppTextStyles.SU_R_12.copyWith(
                    color: coinBuyViewModel.coinAmount == coinAmount
                        ? Colors.white
                        : UsedColor.main),
              ),
              const Spacer(),
              Text(
                coinAmount == CoinAmount.oneThousand ? "600원" : "2400원",
                style: AppTextStyles.PR_SB_18.copyWith(
                  color: coinBuyViewModel.coinAmount == coinAmount
                      ? Colors.white
                      : UsedColor.violet,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomSheetPage(
      BuildContext context, CoinBuyViewModel coinBuyViewModel) {
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
                  coinBuyViewModel.coinAmount == CoinAmount.oneThousand
                      ? "1,000 C"
                      : "4,000 C",
                  style: AppTextStyles.PR_R_16.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (coinBuyViewModel.selectedNum > 1) {
                      coinBuyViewModel
                          .setSelectedNum(coinBuyViewModel.selectedNum - 1);
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
                    coinBuyViewModel.selectedNum.toString(),
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
                    if (coinBuyViewModel.selectedNum < 3) {
                      coinBuyViewModel
                          .setSelectedNum(coinBuyViewModel.selectedNum + 1);
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
                "${coinBuyViewModel.selectedNum}개",
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
                  coinBuyViewModel.coinAmount == CoinAmount.oneThousand
                      ? "${coinBuyViewModel.selectedNum * 600}원"
                          .replaceAllMapped(
                              RegExp(r'\d{1,3}(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[0]},')
                      : "${coinBuyViewModel.selectedNum * 2400}원"
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
              logger.d("결제 버튼 클릭");

              final int totalCoin = coinBuyViewModel.selectedNum *
                  (coinBuyViewModel.coinAmount == CoinAmount.oneThousand
                      ? 1000
                      : 4000);

              // MARK: - 인앱 결제 로직 구현
              // 코인 정보 가져오기
              final response = await getProductsInfo(totalCoin);

              // 결제 시도
              await initiatePurchase(response);

              // 결제 완료 시
              switch (from) {
                case 'MeetMain':
                  context.goNamed('coinBuySuccessFromMeetMain');
                  break;
                case 'MeetManageMain':
                  context.goNamed('coinBuySuccessFromMeetManageMain');
                  break;
                case 'ProfileMain':
                  context.goNamed('coinBuySuccessFromProfileMain');
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
