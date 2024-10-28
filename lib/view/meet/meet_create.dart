import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/model/good_history_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/bot_nav_view_model.dart';
import 'package:meet_up/view_model/coin/ticket_buy_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class MeetCreate extends StatelessWidget {
  const MeetCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        final viewModel =
            Provider.of<MeetCreateViewModel>(context, listen: false);
        viewModel.backClearSelection();
        context.pop();
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _main(context),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 33.w, right: 32.w, bottom: 56.h),
                        child: _bottom(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(
            back: _back(context),
            title: '만남방 개설하기',
          ),
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
        // 정보 초기화
        final viewModel =
            Provider.of<MeetCreateViewModel>(context, listen: false);
        viewModel.backClearSelection();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  // main contents
  Widget _main(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 33.h),
        _naming(context),
        SizedBox(height: 31.h),
        _divider(),
        _category(context),
        _divider(),
        _location(context),
        _divider(),
        _keyword(context),
        _divider(),
        SizedBox(height: 32.31.h),
        _detail(context),
        SizedBox(height: 22.h),
        _age(context),
        SizedBox(height: 33.h),
        _divider(),
        SizedBox(height: 32.h),
        _genderRatio(context),
        SizedBox(height: 32.7.h),
        _divider(),
        SizedBox(height: 32.h),
        _rules(context),
        SizedBox(height: 72.2.h),
      ],
    );
  }

  // 구분선
  Widget _divider() {
    return Divider(
      thickness: 0.91.h,
      height: 0.h,
      color: const Color(0xffd9d9d9),
    );
  }

  // MARK - 방 명
  Widget _naming(BuildContext context) {
    final viewModel = Provider.of<MeetCreateViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 파란 동그라미
          Container(
            width: 8.w,
            height: 8.w,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: UsedColor.main),
          ),
          SizedBox(
            width: 23.w,
          ),
          // title
          Container(
            alignment: Alignment.center,
            child: Text(
              '방 명',
              style: AppTextStyles.PR_SB_16,
            ),
          ),
          SizedBox(width: 37.w),
          // text field
          Container(
            alignment: Alignment.center,
            width: 190.w,
            height: 19.h,
            child: TextField(
              maxLength: 16,
              controller: viewModel.roomNamingTextController,
              onChanged: (_) {
                viewModel.setNamingCount();
              },
              decoration: const InputDecoration(
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: '방 명을 입력해주세요',
                hintStyle: TextStyle(color: UsedColor.text_5),
              ),
              style: AppTextStyles.PR_R_15.copyWith(color: UsedColor.text_5),
            ),
          ),
          const Spacer(),
          Text(
            viewModel.namingCount,
            style: AppTextStyles.PR_SB_11
                .copyWith(color: UsedColor.text_3), // 임의 색상
          ),
          SizedBox(
            width: 26.w,
          ),
        ],
      ),
    );
  }

  // MARK: - 카테고리
  Widget _category(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 파란 동그라미
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: UsedColor.main,
            ),
          ),
          SizedBox(
            width: 23.w,
          ),
          // title
          Container(
            alignment: Alignment.center,
            child: Text(
              '카테고리',
              style: AppTextStyles.PR_SB_16,
            ),
          ),
          SizedBox(
            width: 13.w,
          ),
          _selectedCategory(context),
          const Spacer(),
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              context.goNamed('meetCategory');
            },
            child: Container(
              width: 66.w,
              height: 83.h,
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Image.asset(
                ImagePath.nextArrow,
                width: 9.w,
                height: 17.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedCategory(BuildContext context) {
    return Consumer<MeetCreateViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.selectedMainCategory.isEmpty) {
          return const SizedBox.shrink();
        }
        String categoryText = viewModel.selectedSubCategory.isEmpty
            ? viewModel.selectedMainCategory
            : '${viewModel.selectedMainCategory} > ${viewModel.selectedSubCategory}';

        return Text(
          categoryText,
          style: AppTextStyles.PR_R_15.copyWith(color: UsedColor.text_5),
        );
      },
    );
  }

  // MARK: - 지역
  Widget _location(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 파란 동그라미
          Container(
            width: 8.w,
            height: 8.w,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: UsedColor.main),
          ),
          SizedBox(
            width: 23.w,
          ),
          // title
          Container(
            alignment: Alignment.center,
            child: Text(
              '지역',
              style: AppTextStyles.PR_SB_16,
            ),
          ),
          SizedBox(width: 41.w),
          _selectedLocation(context),
          const Spacer(),
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              context.goNamed('meetLocation');
            },
            child: Container(
              width: 66.w,
              height: 83.h,
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Image.asset(
                ImagePath.nextArrow,
                width: 9.w,
                height: 17.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedLocation(BuildContext context) {
    return Consumer<MeetCreateViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.selectedProvince.isEmpty) {
          return const SizedBox.shrink();
        }
        String locationText = viewModel.selectedProvince.isEmpty
            ? viewModel.selectedProvince
            : '${viewModel.selectedProvince} > ${viewModel.selectedDistrict}';

        return Text(
          locationText,
          style: AppTextStyles.PR_R_15.copyWith(color: UsedColor.text_5),
        );
      },
    );
  }

// MARK: - 키워드
  Widget _keyword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 파란 동그라미
          Container(
            width: 8.w,
            height: 8.w,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: UsedColor.main),
          ),
          SizedBox(
            width: 23.w,
          ),
          // title
          Container(
            alignment: Alignment.center,
            child: Text(
              '키워드',
              style: AppTextStyles.PR_SB_16,
            ),
          ),
          SizedBox(width: 27.w),
          // 선택한 키워드 보이도록
          _selectedKeywords(context),
          const Spacer(),
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              context.goNamed('meetKeyWord');
            },
            child: Container(
              width: 66.w,
              height: 83.h,
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Image.asset(
                ImagePath.nextArrow,
                width: 9.w,
                height: 17.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedKeywords(BuildContext context) {
    return Consumer<MeetCreateViewModel>(
      builder: (context, viewModel, child) {
        List<String> keywords = viewModel.selectedKeywords;
        String resultString = '';
        for (String keyword in keywords) {
          resultString += '#$keyword ';
        }
        return SizedBox(
          width: 190.w,
          child: Text(
            resultString,
            style: AppTextStyles.PR_R_15.copyWith(color: UsedColor.text_5),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

// MARK: - 설명
  Widget _detail(BuildContext context) {
    final viewModel = Provider.of<MeetCreateViewModel>(context);
    return Padding(
      padding: EdgeInsets.only(left: 27.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 6.0.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 파란 동그라미
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(
                  width: 23.w,
                ),
                // title
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '설명',
                    style: AppTextStyles.PR_SB_16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.09.w),
          // 설명 입력란
          Container(
            width: 340.w,
            height: 176.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: UsedColor.b_line, width: 2.h),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 28.0.w,
                top: 15.h,
                right: 28.0.h,
                bottom: 15.h,
              ),
              child: TextField(
                maxLines: 10,
                controller: viewModel.descriptionTextController,
                maxLength: 50,
                decoration: const InputDecoration(
                    counterText: '',
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: '만남 목표를 간단히 입력해 주세요. (50자 제한)',
                    hintStyle: TextStyle(color: UsedColor.text_5)),
                onChanged: (text) {
                  viewModel.setTextCount();
                },
                style: AppTextStyles.PR_R_15.copyWith(color: UsedColor.text_5),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          //글자수 표시
          Padding(
            padding: EdgeInsets.only(left: 307.w),
            child: Text(
              viewModel.textCount,
              style: AppTextStyles.PR_SB_11
                  .copyWith(color: UsedColor.text_3), // 임의 색상
            ),
          ),
        ],
      ),
    );
  }

// MARK: - age
  Widget _age(BuildContext context) {
    final viewModel = Provider.of<MeetCreateViewModel>(context, listen: true);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (!viewModel.selectedAges.contains(userViewModel.getAgeRange())) {
      viewModel.selectAge(userViewModel.getAgeRange(), false);
    }

    List<String> options = [
      "20대",
      "30대",
      "40대",
      "50대",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 33.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 파란 동그라미
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: UsedColor.main),
              ),
              SizedBox(
                width: 23.w,
              ),
              // title
              Container(
                alignment: Alignment.center,
                child: Text(
                  '나이',
                  style: AppTextStyles.PR_SB_16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 21.h),
        Padding(
          padding: EdgeInsets.only(left: 36.w),
          child: Wrap(
            spacing: 7.62.w,
            runSpacing: 7.62.h,
            children: options.map((option) {
              bool isSelected = viewModel.selectedAges.contains(option);
              return GestureDetector(
                onTap: () {
                  // 나의 나이대는 선택으로 고정
                  if (userViewModel.getAgeRange() == option) return;
                  viewModel.selectAge(option, true);
                },
                child: Container(
                  width: 74.38.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: isSelected ? UsedColor.button : Colors.white,
                    borderRadius: BorderRadius.circular(19.r),
                    border: Border.all(
                      color: isSelected
                          ? UsedColor.button
                          : const Color(0xFFD2D8F8),
                      width: 1.75.w,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: AppTextStyles.PR_M_12.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

// MARK: - gender ratio
  Widget _genderRatio(BuildContext context) {
    MeetCreateViewModel viewModel = Provider.of<MeetCreateViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(left: 27.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 6.0.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 파란 동그라미
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(
                  width: 13.85.w,
                ),
                // title
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '성비',
                    style: AppTextStyles.PR_SB_16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 13.3.h),
          Padding(
            padding: EdgeInsets.only(left: 31.0.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => userViewModel.userModel?.gender == 'male'
                      ? null
                      : viewModel.selectWomen4(),
                  child: Image.asset(
                    userViewModel.userModel?.gender == 'male'
                        ? ImagePath.grW4Blur
                        : viewModel.roomGenderRatio == RoomGenderRatio.womanOnly
                            ? ImagePath.grW4
                            : ImagePath.grW4Empty,
                    width: 76.w,
                    height: 76.h,
                  ),
                ),
                SizedBox(width: 24.w),
                GestureDetector(
                  onTap: () => viewModel.selectWomen2Men2(),
                  child: Image.asset(
                    viewModel.roomGenderRatio == RoomGenderRatio.mixed
                        ? ImagePath.grW2M2
                        : ImagePath.grW2M2Empty,
                    width: 76.w,
                    height: 76.h,
                  ),
                ),
                SizedBox(width: 24.w),
                GestureDetector(
                  onTap: () => userViewModel.userModel?.gender == 'female'
                      ? null
                      : viewModel.selectMen4(),
                  child: Image.asset(
                    userViewModel.userModel?.gender == 'female'
                        ? ImagePath.grW4Blur
                        : viewModel.roomGenderRatio == RoomGenderRatio.manOnly
                            ? ImagePath.grM4
                            : ImagePath.grM4Empty,
                    width: 76.w,
                    height: 76.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// MARK: - 세부 규칙
  Widget _rules(BuildContext context) {
    MeetCreateViewModel viewModel = Provider.of<MeetCreateViewModel>(context);

    return Padding(
      padding: EdgeInsets.only(left: 27.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 6.0.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 파란 동그라미
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(
                  width: 14.46.w,
                ),
                // title
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '세부 규칙',
                    style: AppTextStyles.PR_SB_16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 27.1.h),
          // contents
          ...viewModel.rules.entries.map((entry) {
            bool isSelected = entry.value;
            return Padding(
              padding: EdgeInsets.only(left: 28.46.w, right: 39.12.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(entry.key,
                            style: isSelected
                                ? AppTextStyles.PR_M_15
                                    .copyWith(color: Colors.black)
                                : AppTextStyles.PR_R_15
                                    .copyWith(color: UsedColor.text_5)),
                      ),
                      _responseButton(context, entry.key, true),
                      SizedBox(width: 7.12.w),
                      _responseButton(context, entry.key, false),
                    ],
                  ),
                  SizedBox(
                    height: 22.58.h,
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

// 세부 규칙 - 예, 아니요 컨테이너
  Widget _responseButton(BuildContext context, String rule, bool response) {
    MeetCreateViewModel viewModel =
        Provider.of<MeetCreateViewModel>(context, listen: false);
    bool isSelected = viewModel.rules[rule] == response;

    return GestureDetector(
      onTap: () {
        viewModel.setRuleQuestion(rule, response);
      },
      child: Container(
        width: 43.w,
        height: 19.h,
        decoration: BoxDecoration(
            color: isSelected ? UsedColor.button : Colors.white,
            borderRadius: BorderRadius.circular(9.9.r),
            border: Border.all(
                color: isSelected ? UsedColor.button : UsedColor.b_line,
                width: 1.41.h)),
        child: Center(
          child: Text(response ? '가능' : '불가능',
              style: AppTextStyles.PR_SB_11.copyWith(
                color: isSelected ? Colors.white : UsedColor.charcoal_black,
              )),
        ),
      ),
    );
  }

// MARK: - bottom
  Widget _bottom(BuildContext context) {
    return Consumer<MeetCreateViewModel>(
      builder: (context, viewModel, child) {
        return NextButton(
          onTap: () async {
            // if (!viewModel.allCheckCompleted) return;
            if (viewModel.allCheckCompleted) {
              _checkBottomSheet(context);
            }
          },
          height: 56.h,
          text: '만남방 개설',
          enable: viewModel.allCheckCompleted,
          backgroundColor: viewModel.allCheckCompleted
              ? UsedColor.button
              : UsedColor.button_g,
          textStyle: AppTextStyles.PR_SB_20.copyWith(
              color: viewModel.allCheckCompleted
                  ? Colors.white
                  : UsedColor.text_2),
        );
      },
    );
  }

  // MARK: - 바텀시트
  void _checkBottomSheet(BuildContext context) {
    final ticketBuyViewModel =
        Provider.of<TicketBuyViewModel>(context, listen: false);
    final bottomNavigationBarViewModel =
        Provider.of<BottomNavigationBarViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final userViewModel = Provider.of<UserViewModel>(context);
        return Consumer<MeetCreateViewModel>(
            builder: (context, viewModel, child) {
          return Container(
            // 높이 501.h
            height: 501.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(19.r),
                topRight: Radius.circular(19.r),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 18.h),
                // 바텀시트 상위 바
                Center(
                  child: Container(
                    width: 58.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.r),
                      color: UsedColor.button_g,
                    ),
                  ),
                ),
                // title
                Padding(
                  padding: EdgeInsets.only(top: 51.h, left: 38.w, right: 31.w),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '만남방 개설 전',
                            style: AppTextStyles.PR_SB_22,
                          ),
                          SizedBox(
                            height: 7.0.h,
                          ),
                          Text(
                            '안내사항을 확인해주세요!',
                            style: AppTextStyles.PR_SB_22,
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          viewModel.setAllAgreed(!viewModel.allAgreed);
                        },
                        child: viewModel.allAgreed
                            ? Image.asset(ImagePath.checkBoxOn,
                                width: 33.w, height: 33.h)
                            : Image.asset(ImagePath.checkBoxOff,
                                width: 33.w, height: 33.h),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                // 개별 체크
                Padding(
                  padding: EdgeInsets.only(left: 38.w),
                  child: GestureDetector(
                    onTap: () {
                      viewModel.setIndividualAgreement1(
                          !viewModel.individualAgreement1);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check,
                          color: viewModel.individualAgreement1
                              ? UsedColor.violet
                              : UsedColor.text_5,
                          size: 20.w,
                        ),
                        SizedBox(
                          width: 17.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '방장이 만남방 이탈 혹은 삭제시 만남방과',
                              style: AppTextStyles.PR_R_17.copyWith(
                                  color: viewModel.individualAgreement1
                                      ? Colors.black
                                      : UsedColor.text_4),
                            ),
                            SizedBox(
                              height: 4.0.h,
                            ),
                            Text(
                              '채팅방은 완전히 삭제됩니다.',
                              style: AppTextStyles.PR_R_17.copyWith(
                                  color: viewModel.individualAgreement1
                                      ? Colors.black
                                      : UsedColor.text_4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(left: 38.w),
                  child: GestureDetector(
                    onTap: () {
                      viewModel.setIndividualAgreement2(
                          !viewModel.individualAgreement2);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check,
                          color: viewModel.individualAgreement2
                              ? UsedColor.violet
                              : UsedColor.text_5,
                          size: 20.w,
                        ),
                        SizedBox(
                          width: 17.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '만남방 개설 후, 7일 이내에 일정 등록이',
                              style: AppTextStyles.PR_R_17.copyWith(
                                  color: viewModel.individualAgreement2
                                      ? Colors.black
                                      : UsedColor.text_4),
                            ),
                            SizedBox(
                              height: 4.0.h,
                            ),
                            Text(
                              '되지 않으면 만남방이 삭제되고, 만남권은',
                              style: AppTextStyles.PR_R_17.copyWith(
                                  color: viewModel.individualAgreement2
                                      ? Colors.black
                                      : UsedColor.text_4),
                            ),
                            SizedBox(
                              height: 4.0.h,
                            ),
                            Text(
                              '환불됩니다.',
                              style: AppTextStyles.PR_R_17.copyWith(
                                  color: viewModel.individualAgreement2
                                      ? Colors.black
                                      : UsedColor.text_4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(left: 38.w),
                  child: GestureDetector(
                    onTap: () {
                      viewModel.setIndividualAgreement3(
                          !viewModel.individualAgreement3);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check,
                          color: viewModel.individualAgreement3
                              ? UsedColor.violet
                              : UsedColor.text_5,
                          size: 20.w,
                        ),
                        SizedBox(
                          width: 17.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '만남방 개설 시, 방장이 이탈 혹은',
                              style: AppTextStyles.PR_R_17.copyWith(
                                  color: viewModel.individualAgreement3
                                      ? Colors.black
                                      : UsedColor.text_4),
                            ),
                            SizedBox(
                              height: 4.0.h,
                            ),
                            Text(
                              '방 삭제 시 만남권은 환불되지 않습니다.',
                              style: AppTextStyles.PR_R_17.copyWith(
                                  color: viewModel.individualAgreement3
                                      ? Colors.black
                                      : UsedColor.text_4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 33.w, right: 33.w),
                  child: NextButton(
                    onTap: () async {
                      // 방 만들기 로직
                      await viewModel.createRoom(uid: userViewModel.uid!);

                      // 만남권 소진 로직
                      await userViewModel.updateUserInfo(data: {
                        'ticket': userViewModel.userModel!.ticket - 1
                      });

                      // 영수증 발급 로직
                      final goodHistoryModel = GoodHistoryModel(
                          gh_type: GoodHistoryType.ticket.name,
                          gh_type_transaction:
                              GoodHistoryTypeOfTransaction.use.name,
                          gh_uid: userViewModel.uid!,
                          gh_result_coin: userViewModel.userModel!.coin,
                          gh_result_ticket: userViewModel.userModel!.ticket,
                          gh_change_coin_amount: 0,
                          gh_change_ticket_amount: -1,
                          gh_product_id: '',
                          gh_change_date: Timestamp.now());

                      await ticketBuyViewModel.createGoodHistory(
                          goodHistoryModel: goodHistoryModel);

                      // meetCreateViewModel 초기화
                      viewModel.backClearSelection();

                      // 첫 화면으로 이동 후, 채팅 탭으로 이동
                      while (context.canPop()) {
                        context.pop();
                      }
                      bottomNavigationBarViewModel.changeIndex(1);
                    },
                    height: 56.h,
                    text: '동의하고 시작하기',
                    enable: viewModel.isAllAgreed,
                    backgroundColor: viewModel.isAllAgreed
                        ? UsedColor.button
                        : UsedColor.button_g,
                    textStyle: AppTextStyles.PR_SB_20.copyWith(
                      color: viewModel.isAllAgreed
                          ? Colors.white
                          : UsedColor.text_2,
                    ),
                  ),
                ),
                SizedBox(height: 56.h),
              ],
            ),
          );
        });
      },
    );
  }
}
