import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_browse_view_model.dart';
import 'package:provider/provider.dart';

class MeetBrowseMain extends StatelessWidget {
  const MeetBrowseMain({super.key});

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
            // _main(context),
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
          header(back: _back(context), title: '만남방 둘러보기'),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 9.h),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image.asset(
          ImagePath.back,
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
      child: Column(children: [
        SizedBox(height: 29.h),
        _search(context),
        SizedBox(height: 22.h),
        _filter(context),
        SizedBox(height: 22.h),
        _divider(),
        SizedBox(height: 28.h),
        // _meetingRoom(context),
      ]),
    );
  }

  Widget _search(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return SizedBox(
      width: 352.w,
      height: 37.h,
      child: Container(
        decoration: BoxDecoration(
          color: UsedColor.bg_color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10.0.h),
            hintText: '만남방의 이름을 검색해 보세요.',
            prefixIcon: Image.asset(
              ImagePath.search,
              width: 10.w,
              height: 10.h,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                controller.clear();
              },
              child: Image.asset(
                ImagePath.close,
                width: 23.w,
                height: 23.h,
              ),
            ),
            // Remove border
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,

            hintStyle: AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
          ),
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget _filter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0.w),
      child:
          Consumer<MeetBrowseViewModel>(builder: (context, viewModel, child) {
        List<Widget> filterWidgets = [
          _filterButton(
            context,
            onTap: () {
              if (viewModel.selectedFilters.isNotEmpty) {
                viewModel.clearAllFilters();
              } else {
                context.goNamed('meetFilterMain');
              }
            },
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  viewModel.selectedFilters.isNotEmpty ? '초기화' : '필터 설정',
                  style:
                      AppTextStyles.PR_M_12.copyWith(color: UsedColor.text_2),
                ),
                SizedBox(width: 5.w),
                Image.asset(
                  viewModel.selectedFilters.isNotEmpty
                      ? ImagePath.resetIcon
                      : ImagePath.filterIcon,
                  width: 14.w,
                  height: 11.h,
                ),
              ],
            ),
            borderColor: UsedColor.button_g,
            backgroundColor: Colors.white,
          ),
        ];

        for (var filter in viewModel.selectedFilters) {
          filterWidgets.add(SizedBox(width: 4.0.w));
          filterWidgets.add(
            _filterContainer(
              context,
              filter,
              UsedColor.b_line,
              UsedColor.image_card,
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: (MediaQuery.of(context).size.width) *
                    1.5.w, // 지정안하면 스크롤 오버플로우 오류남
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: filterWidgets,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _filterButton(BuildContext context,
      {required Widget content,
      required Color borderColor,
      required Color backgroundColor,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(width: 1.5.w, color: borderColor),
          color: backgroundColor,
        ),
        child: content,
      ),
    );
  }

  Widget _filterContainer(BuildContext context, String filterText,
      Color borderColor, Color backgroundColor) {
    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(width: 1.5.w, color: borderColor),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            filterText,
            style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
          ),
        ],
      ),
    );
  }

  // Widget _selectedMainCategory(BuildContext context) {
  //   return Consumer<MeetBrowseViewModel>(
  //     builder: (context, viewModel, child) {
  //       if (viewModel.selectedMainCategory.isNotEmpty) {
  //         return Text(
  //           viewModel.selectedMainCategory,
  //           style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
  //         );
  //       } else {
  //         return const SizedBox.shrink();
  //       }
  //     },
  //   );
  // }

  // Widget _selectedSubCategory(BuildContext context) {
  //   return Consumer<MeetBrowseViewModel>(
  //     builder: (context, viewModel, child) {
  //       if (viewModel.selectedMainCategory.isNotEmpty &&
  //           viewModel.selectedSubCategory.isNotEmpty) {
  //         return Text(
  //           viewModel.selectedSubCategory,
  //           style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
  //         );
  //       } else {
  //         return const SizedBox.shrink();
  //       }
  //     },
  //   );
  // }

  // Widget _selectedLocation(BuildContext context) {
  //   return Consumer<MeetBrowseViewModel>(
  //     builder: (context, viewModel, child) {
  //       if (viewModel.selectedProvince.isEmpty) {
  //         return const SizedBox.shrink();
  //       }
  //       String locationText = viewModel.selectedProvince.isEmpty
  //           ? viewModel.selectedMainCategory
  //           : '${viewModel.selectedProvince} > ${viewModel.selectedDistrict}';

  //       return Text(
  //         locationText,
  //         style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
  //       );
  //     },
  //   );
  // }

  // Widget _selectedAge(BuildContext context) {
  //   return Consumer<MeetBrowseViewModel>(
  //     builder: (context, viewModel, child) {
  //       if (viewModel.selectedAge.isEmpty) {
  //         return const SizedBox.shrink();
  //       }
  //       return Text(
  //         viewModel.selectedAge,
  //         style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
  //       );
  //     },
  //   );
  // }

  // Widget _selectedGender(BuildContext context) {
  //   return Consumer<MeetBrowseViewModel>(
  //     builder: (context, viewModel, child) {
  //       String genderText = "";
  //       if (viewModel.isWomen4Selected) {
  //         genderText = "여성 4";
  //       } else if (viewModel.isWomen2Men2Selected) {
  //         genderText = "남성 2 / 여성 2";
  //       } else if (viewModel.isMen4Selected) {
  //         genderText = "남성 4";
  //       }

  //       if (genderText.isNotEmpty) {
  //         return Text(
  //           genderText,
  //           style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
  //         );
  //       } else {
  //         return const SizedBox.shrink();
  //       }
  //     },
  //   );
  // }

  // Widget _selectedRules(BuildContext context) {
  //   return Consumer<MeetBrowseViewModel>(
  //     builder: (context, viewModel, child) {
  //       if (viewModel.numberOfSelectedRules == 0) {
  //         return const SizedBox.shrink();
  //       }
  //       return Text(
  //         '세부규칙 ${viewModel.numberOfSelectedRules}',
  //         style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
  //       );
  //     },
  //   );
  // }

// Widget _meetingRoom(BuildContext context) {}
}
