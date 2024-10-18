import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';

class CoinWidget extends StatelessWidget {
  final int coinAmount;
  final int ticketAmount;

  const CoinWidget({
    super.key,
    required this.coinAmount,
    required this.ticketAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      height: 28.h,
      decoration: BoxDecoration(
        color: UsedColor.charcoal_black,
        borderRadius: BorderRadius.circular(19.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // dollar icon
          Image.asset(ImagePath.coinDollarIcon, width: 12.5.w, height: 12.h),
          SizedBox(width: 1.w),
          // 충전된 달러 양
          Text(
            coinAmount.toString(),
            style: AppTextStyles.PR_R_11.copyWith(color: UsedColor.coin),
          ),
          SizedBox(width: 4.3.w),
          // wallet icon
          Image.asset(ImagePath.coinWalletIcon, width: 14.w, height: 14.h),
          SizedBox(width: 1.w),
          // 입장권 개수
          Text(
            ticketAmount.toString(),
            style: AppTextStyles.PR_R_11.copyWith(color: UsedColor.coin),
          ),
        ],
      ),
    );
  }
}
