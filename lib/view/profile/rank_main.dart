import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/profile/profile_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

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
              child: _profileRankBox(context),
            ),
            SizedBox(height: 36.h),
            Padding(
              padding: EdgeInsets.only(left: 25.0.w),
              child: _rankInfo(context),
            ),
          ],
        ),
      ),
    );
  }

  //MARK: - 프로필 랭크 박스
  Widget _profileRankBox(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final profileIcon = userViewModel.userModel?.profile_icon ?? 'fedro_1';
    final profileIconName = profileIcon.split('/').last.split('_').first;
    String path = '';
    switch (profileIconName) {
      case "fedro":
        path = ImagePath.fedroSelect;
      case "cogy":
        path = ImagePath.cogySelect;
      case "piggy":
        path = ImagePath.piggySelect;
      case "ham":
        path = ImagePath.hamSelect;
      case "aengmu":
        path = ImagePath.annumSelect;
    }

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
                  child: Image.asset(path),
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
                      TextSpan(
                        text:
                            '${userViewModel.userModel?.nickname ?? ''} 님의\n이번 달 등급은 ',
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
  Widget _rankInfo(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        final benefits = viewModel.rankBenefits[viewModel.selectedRank] ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '등급 안내',
              style: AppTextStyles.PR_R_16
                  .copyWith(color: UsedColor.charcoal_black),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.0.w, top: 12.h, bottom: 20.h),
              child: Row(
                children: [
                  Container(width: 12.w, height: 12.w, color: UsedColor.main),
                  SizedBox(width: 4.w),
                  Text(
                    '각 등급을 눌러 등급별 상세 혜택을 확인해보세요',
                    style:
                        AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_2),
                  ),
                ],
              ),
            ),
            // MARK: - 등급 이미지
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _rankTier(
                  context: context,
                  viewModel: viewModel,
                  rank: 'Master',
                  imagePathOn: ImagePath.rankMasterOn,
                  imagePathOff: ImagePath.rankMasterOff,
                  width: 48.w,
                  height: 236.h,
                ),
                SizedBox(width: 20.w),
                _rankTier(
                  context: context,
                  viewModel: viewModel,
                  rank: 'Advanced',
                  imagePathOn: ImagePath.rankAdvancedOn,
                  imagePathOff: ImagePath.rankAdvancedOff,
                  width: 48.w,
                  height: 190.h,
                ),
                SizedBox(width: 20.w),
                _rankTier(
                  context: context,
                  viewModel: viewModel,
                  rank: 'Intermediate',
                  imagePathOn: ImagePath.rankIntermediateOn,
                  imagePathOff: ImagePath.rankIntermediateOff,
                  width: 48.w,
                  height: 135.h,
                ),
                SizedBox(width: 20.w),
                _rankTier(
                  context: context,
                  viewModel: viewModel,
                  rank: 'Novice',
                  imagePathOn: ImagePath.rankNoviceOn,
                  imagePathOff: ImagePath.rankNoviceOff,
                  width: 48.w,
                  height: 74.h,
                ),
                SizedBox(width: 20.w),
                _rankTier(
                  context: context,
                  viewModel: viewModel,
                  rank: 'Beginner',
                  imagePathOn: ImagePath.rankBeginnerOn,
                  imagePathOff: ImagePath.rankBeginnerOff,
                  width: 48.w,
                  height: 45.h,
                ),
              ],
            ),
            SizedBox(height: 22.h),
            // MARK: -혜택 내용

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
                    // 혜택
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '혜택',
                          style: AppTextStyles.PR_M_16
                              .copyWith(color: UsedColor.main),
                        ),
                        SizedBox(width: 24.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: benefits
                              .map((benefit) => Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: Text(
                                      benefit,
                                      style: AppTextStyles.PR_R_12
                                          .copyWith(color: UsedColor.text_3),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 44.h),
                    // 기준
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '기준',
                          style: AppTextStyles.PR_M_16
                              .copyWith(color: UsedColor.main),
                        ),
                        SizedBox(width: 24.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Beginner',
                                  style: AppTextStyles.PR_SB_12
                                      .copyWith(color: UsedColor.text_3),
                                ),
                                SizedBox(width: 37.w),
                                Text(
                                  '10점 미만',
                                  style: AppTextStyles.PR_R_13
                                      .copyWith(color: UsedColor.text_3),
                                )
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  'Novice',
                                  style: AppTextStyles.PR_SB_12
                                      .copyWith(color: UsedColor.text_3),
                                ),
                                SizedBox(width: 49.w),
                                Text(
                                  '10점 이상, 30점 미만',
                                  style: AppTextStyles.PR_R_13
                                      .copyWith(color: UsedColor.text_3),
                                )
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  'Intermediate',
                                  style: AppTextStyles.PR_SB_12
                                      .copyWith(color: UsedColor.text_3),
                                ),
                                SizedBox(width: 14.w),
                                Text(
                                  '30점 이상, 60점 미만',
                                  style: AppTextStyles.PR_R_13
                                      .copyWith(color: UsedColor.text_3),
                                )
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  'Advanced',
                                  style: AppTextStyles.PR_SB_12
                                      .copyWith(color: UsedColor.text_3),
                                ),
                                SizedBox(width: 30.w),
                                Text(
                                  '60점 이상, 100점 미만',
                                  style: AppTextStyles.PR_R_13
                                      .copyWith(color: UsedColor.text_3),
                                )
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  'Master',
                                  style: AppTextStyles.PR_SB_12
                                      .copyWith(color: UsedColor.text_3),
                                ),
                                SizedBox(width: 48.w),
                                Text(
                                  '100점 이상',
                                  style: AppTextStyles.PR_R_13
                                      .copyWith(color: UsedColor.text_3),
                                )
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0.h, right: 8.w),
                                  child: Container(
                                    width: 8.w,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: UsedColor.main,
                                    ),
                                  ),
                                ),
                                Text(
                                  '상호평가 1명당 2점 획득',
                                  style: AppTextStyles.PR_R_13
                                      .copyWith(color: UsedColor.text_4),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0.h, right: 8.w),
                                  child: Container(
                                    width: 8.w,
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: UsedColor.main,
                                    ),
                                  ),
                                ),
                                Text(
                                  '성찰 하루 최소 1회 작성 시 2점 획득',
                                  style: AppTextStyles.PR_R_13
                                      .copyWith(color: UsedColor.text_4),
                                ),
                              ],
                            ),
                            SizedBox(height: 35.h),
                          ],
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '주의',
                          style: AppTextStyles.PR_M_16
                              .copyWith(color: UsedColor.main),
                        ),
                        SizedBox(width: 24.w),
                        Text(
                          '한달 동안 1번 이상의 만남을 가지면\n등급이 유지되며, 그렇지 않은 경우\n1단계씩 등급 하락',
                          style: AppTextStyles.PR_R_13
                              .copyWith(color: UsedColor.text_4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 29.h)
          ],
        );
      },
    );
  }

  Widget _rankTier({
    required BuildContext context,
    required ProfileViewModel viewModel,
    required String rank,
    required String imagePathOn,
    required String imagePathOff,
    required double width,
    required double height,
  }) {
    final isSelected = viewModel.selectedRank == rank;
    final imagePath = isSelected ? imagePathOn : imagePathOff;

    return GestureDetector(
      onTap: () => viewModel.selectRank(rank),
      child: Column(
        children: [
          Image.asset(imagePath, width: width, height: height),
          Padding(
            padding: EdgeInsets.only(top: 4.0.h, left: 4.w, right: 4.w),
            child: Text(
              rank,
              style: AppTextStyles.PR_R_10.copyWith(color: UsedColor.text_3),
            ),
          ),
        ],
      ),
    );
  }
}
