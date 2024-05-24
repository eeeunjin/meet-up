import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';

class RankMain extends StatelessWidget {
  const RankMain({super.key});

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
          header(back: _back(context), title: '등급'),
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
    return Container(
      color: UsedColor.bg_color,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.0.w),
              child: _profileRankBox(),
            ),
            SizedBox(height: 36.h),
            Padding(
              padding: EdgeInsets.only(left: 25.0.w),
              child: _rankInfo(),
            ),
          ],
        ),
      ),
    );
  }

  //MARK: - 프로필 랭크 박스
  Widget _profileRankBox() {
    return Container(
      width: 337.w,
      height: 216.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24.0.h, left: 20.w),
                // 프로필 사진
                child: Container(
                  width: 96.w,
                  height: 96.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 0.5.w, color: UsedColor.b_line),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // 텍스트
              Padding(
                padding: EdgeInsets.only(top: 44.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      // 사용자 닉네임
                      TextSpan(
                        text: '사용자 닉네임 님의\n이번 달 등급은 ',
                        style: AppTextStyles.PR_R_14
                            .copyWith(color: UsedColor.charcoal_black),
                        children: <TextSpan>[
                          TextSpan(
                            // 해당 등급
                            text: 'Novice',
                            style: AppTextStyles.PR_SB_14
                                .copyWith(color: UsedColor.charcoal_black),
                          ),
                          TextSpan(
                            text: '입니다!',
                            style: AppTextStyles.PR_R_14
                                .copyWith(color: UsedColor.charcoal_black),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Intermediate까지 -점 남았습니다.',
                      style: AppTextStyles.PR_R_10
                          .copyWith(color: UsedColor.text_3),
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 71.0.w, top: 16.h),
            child: Text(
              '등급 혜택을 확인하고 혜택을 받아보세요!',
              style: AppTextStyles.PR_R_10.copyWith(color: UsedColor.text_3),
            ),
          ),
          // 혜택 받기 버튼
          // TODO : - 바텀 간격 1픽셀 over 20- > 19로 해둠
          Padding(
            padding: EdgeInsets.only(left: 25.0.w, bottom: 19.h, top: 8.h),
            child: Container(
              width: 288.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: UsedColor.image_card,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  '혜택 받기',
                  style:
                      AppTextStyles.PR_R_12.copyWith(color: UsedColor.violet),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - 등급 안내
  Widget _rankInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '등급 안내',
          style:
              AppTextStyles.PR_R_16.copyWith(color: UsedColor.charcoal_black),
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.0.w, top: 12.h, bottom: 20.h),
          child: Row(
            children: [
              Container(width: 12.w, height: 12.w, color: UsedColor.main),
              SizedBox(width: 4.w),
              Text(
                '각 등급을 눌러 등급별 상세 혜택을 확인해보세요',
                style: AppTextStyles.PR_R_10.copyWith(color: UsedColor.text_2),
              ),
            ],
          ),
        ),
        // 등급 이미지
        // MARK: -혜택 내용
        //
        // Novice 등급
        Container(
          width: 344.w,
          height: 388.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(29.r),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 40.0.w, top: 32.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '혜택',
                      style:
                          AppTextStyles.PR_M_16.copyWith(color: UsedColor.main),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
