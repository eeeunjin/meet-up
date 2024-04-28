import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/model/province_district_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:provider/provider.dart';

class MeetLocation extends StatelessWidget {
  const MeetLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (Platform.isIOS)
              _header(context)
            else if (Platform.isAndroid)
              Padding(
                padding: EdgeInsets.only(
                  top: 15.h,
                ),
                child: _header(context),
              ),
            Expanded(child: _main(context)),
            Padding(
              padding: EdgeInsets.only(left: 33.w, right: 32.w, bottom: 56.h),
              child: _bottom(context),
            ),
          ],
        ),
      ),
    );
  }

// header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '지역 선택'),
          SizedBox(
            height: 22.h,
          ),
          Divider(
            height: 0.3.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 9.h),
      child: GestureDetector(
        onTap: () {
          // 정보 초기화
          final viewModel =
              Provider.of<MeetCreateViewModel>(context, listen: false);
          viewModel.backClearSelection();
          context.pop(context);
        },
        child: Image.asset(
          ImagePath.close,
          width: 40.w,
          height: 40.h,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 0.91.h,
      color: const Color(0xffd9d9d9),
    );
  }

  Widget _main(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _selectArea(context),
          _divider(),
          SizedBox(
            height: 13.h,
          ),
        ],
      ),
    );
  }

  Widget _selectArea(BuildContext context) {
    final viewModel = Provider.of<MeetCreateViewModel>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 56.h,
                  width: 140.w,
                  child: Container(
                    alignment: Alignment.center,
                    color: UsedColor.bg_color,
                    child: Text(
                      '시 · 도',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.PR_SB_17
                          .copyWith(color: UsedColor.charcoal_black),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: 419.h,
                    width: 140.w,
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: ProvinceDistrict.entireDistricts.keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        String province = ProvinceDistrict.entireDistricts.keys
                            .elementAt(index);
                        return InkWell(
                          onTap: () {
                            viewModel.selectedProvince = province;
                          },
                          child: ValueListenableBuilder<String>(
                            valueListenable: viewModel.selectedProvinceNotifier,
                            builder: (context, selectedProvince, child) {
                              bool isSelected = selectedProvince == province;
                              return Container(
                                height: 43.h,
                                width: 140.w,
                                color: isSelected
                                    ? UsedColor.main
                                    : Colors.transparent,
                                child: Center(
                                  child: Text(
                                    province,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.PR_R_15.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : UsedColor.charcoal_black),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(width: 0.3.w, height: 475.h, color: UsedColor.line),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 56.h,
                  width: 252.w,
                  child: Container(
                    alignment: Alignment.center,
                    color: UsedColor.bg_color,
                    child: Text(
                      '시 · 도 · 군',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.PR_SB_17
                          .copyWith(color: UsedColor.charcoal_black),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: ValueListenableBuilder<String>(
                    valueListenable: viewModel.selectedProvinceNotifier,
                    builder: (BuildContext context, String selectedProvince,
                        Widget? child) {
                      return ValueListenableBuilder<String>(
                        valueListenable: viewModel.selectedDistrictNotifier,
                        builder: (BuildContext context, String selectedDistrict,
                            Widget? child) {
                          return SizedBox(
                            height: 419.h,
                            width: 252.w,
                            child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: viewModel
                                  .getDistrictsByProvince(selectedProvince)
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                String district =
                                    viewModel.getDistrictsByProvince(
                                        selectedProvince)[index];

                                TextStyle textStyle = AppTextStyles.PR_R_15
                                    .copyWith(color: UsedColor.charcoal_black);
                                if (index == 0) {
                                  textStyle = AppTextStyles.PR_SB_15
                                      .copyWith(fontWeight: FontWeight.bold);
                                }
                                return InkWell(
                                  onTap: () {
                                    viewModel.selectedDistrict = district;
                                  },
                                  child: Container(
                                    height: 43.h,
                                    width: 250.w,
                                    color: selectedDistrict == district
                                        ? UsedColor.image_card
                                        : Colors.transparent,
                                    child: Center(
                                      child: Text(
                                        district,
                                        textAlign: TextAlign.center,
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        // SizedBox(height: 7.h),
        Divider(color: const Color(0xffd9d9d9), thickness: 0.91.h),
        Padding(
          padding: EdgeInsets.only(
            left: 26.w,
            top: 15.h,
          ),
          child: ValueListenableBuilder<String>(
            valueListenable: viewModel.selectedProvinceNotifier,
            builder:
                (BuildContext context, String selectedProvince, Widget? child) {
              return ValueListenableBuilder<String>(
                valueListenable: viewModel.selectedDistrictNotifier,
                builder: (BuildContext context, String selectedDistrict,
                    Widget? child) {
                  String displayText = selectedDistrict.contains("전체")
                      ? selectedProvince
                      : "$selectedProvince $selectedDistrict";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '선택 지역',
                        style: AppTextStyles.SU_R_12
                            .copyWith(color: UsedColor.text_1),
                      ),
                      SizedBox(height: 9.h),
                      Visibility(
                        visible: selectedProvince.isNotEmpty ||
                            selectedDistrict.isNotEmpty,
                        child: Container(
                          height: 31.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.r),
                            border: Border.all(
                                color: UsedColor.B_line, width: 1.5.w),
                          ),
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 9.w),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          displayText,
                                          style: AppTextStyles.PR_SB_14
                                              .copyWith(
                                                  color:
                                                      UsedColor.charcoal_black),
                                        ),
                                        SizedBox(width: 10.w),
                                        GestureDetector(
                                            onTap: () {
                                              viewModel.clearSelection();
                                            },
                                            child: Image.asset(ImagePath.close,
                                                width: 9.w, height: 9.h)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 23.h,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _bottom(BuildContext context) {
    return Consumer<MeetCreateViewModel>(
      builder: (context, viewModel, child) {
        return NextButton(
          onTap: () async {
            Navigator.of(context).pop();
          },
          height: 54.h,
          text: viewModel.isSelectionComplete ? '확인' : '다음',
          enable: viewModel.isSelectionComplete,
          backgroundColor: viewModel.isSelectionComplete
              ? UsedColor.button
              : UsedColor.button_g,
          textStyle: TextStyle(
            color:
                viewModel.isSelectionComplete ? Colors.white : UsedColor.text_2,
            fontSize: 20.sp,
          ),
        );
      },
    );
  }
}
