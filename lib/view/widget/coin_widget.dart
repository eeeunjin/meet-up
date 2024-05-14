import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';

class CoinWidget extends StatelessWidget {
  final int coinAmount;
  final int ticketAmount;
  final bool isFixed;

  const CoinWidget({
    Key? key,
    required this.coinAmount,
    required this.ticketAmount,
    required this.isFixed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      height: 24.h,
      decoration: BoxDecoration(
        color: UsedColor.charcoal_black,
        borderRadius: BorderRadius.circular(19.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // dollar icon
          Image.asset(ImagePath.coinDollarIcon, width: 10.5.w, height: 10.h),
          SizedBox(width: 1.2.w),
          // 충전된 달러 양
          Text(
            coinAmount.toString(),
            style: AppTextStyles.PR_R_9.copyWith(color: UsedColor.coin),
          ),
          SizedBox(width: 4.3.w),
          // wallet icon
          Image.asset(ImagePath.coinWalletIcon,
              width: 11.5.w, height: 11.5.h),
          SizedBox(width: 1.18.w),
          // 입장권 개수
          Text(
            ticketAmount.toString(),
            style: AppTextStyles.PR_R_9.copyWith(color: UsedColor.coin),
          ),
          if (isFixed) SizedBox(width: 3.w),
          // 정기권 여부
          if (isFixed)
            Container(
              width: 30.w,
              height: 10.h,
              decoration: BoxDecoration(
                  color: UsedColor.charcoal_black,
                  borderRadius: BorderRadius.circular(13.41.r),
                  border: Border.all(width: 0.69.w, color: UsedColor.coin)),
              child: Center(
                child: Text(
                  '정기권',
                  style: AppTextStyles.SU_R_7.copyWith(color: UsedColor.coin),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
