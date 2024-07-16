import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/model/province_district_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:provider/provider.dart';

class ProvinceDistrictPicker extends StatelessWidget {
  const ProvinceDistrictPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpDetailViewModel>(context);
    final items = ProvinceDistrict.districts.keys.toList();

    return Container(
      padding:
          const EdgeInsets.only(left: 30.0, right: 75.0), // Adjust as needed
      child: Stack(
        children: [
          Positioned(
            top: 42.h,
            left: 13.w,
            child: Container(
              width: 255.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6.58.r),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 113.h,
                  child: ListWheelScrollView(
                    itemExtent: 32.5.h,
                    physics: const FixedExtentScrollPhysics(),
                    // diameterRatio: Render,
                    controller: viewModel.provinceScrollController,
                    children: items.map((String province) {
                      final isSelectedProvince =
                          (province == viewModel.selectedProvince);

                      return _buildItem(province, isSelectedProvince,
                          viewModel.selectedProvinceIndex, items);
                    }).toList(),
                    onSelectedItemChanged: (int index) {
                      viewModel.selectProvince(
                          ProvinceDistrict.districts.keys.elementAt(index));
                      viewModel.selectDistrict(ProvinceDistrict
                          .districts[viewModel.selectedProvince]![0]);
                      viewModel.districtScrollController.jumpTo(0);
                    },
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 113.h,
                  child: ListWheelScrollView(
                    itemExtent: 32.5.h,
                    physics: const FixedExtentScrollPhysics(),
                    // diameterRatio: 0.7,
                    controller: viewModel.districtScrollController,
                    children: (ProvinceDistrict
                                .districts[viewModel.selectedProvince] ??
                            [])
                        .map((String district) {
                      final isSelectedDistrict =
                          (district == viewModel.selectedDistrict);
                      return _buildItem(
                          district,
                          isSelectedDistrict,
                          viewModel.selectedDistrictIndex,
                          ProvinceDistrict
                              .districts[viewModel.selectedProvince]!);
                    }).toList(),
                    onSelectedItemChanged: (int index) {
                      viewModel.selectDistrict(ProvinceDistrict
                          .districts[viewModel.selectedProvince]![index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
      String text, bool isSelected, int selectedIndex, List<String> items) {
    int distanceFromSelected = (selectedIndex - items.indexOf(text)).abs();

    double scale;
    Color textColor;

    if (distanceFromSelected == 0) {
      scale = 1.0;
      textColor = Colors.black;
    } else if (distanceFromSelected == 1) {
      scale = 0.97;
      textColor = const Color(0xFF8D8D8D);
    } else {
      scale = 0.94;
      textColor = const Color(0xFFDFDFDF);
    }

    return Center(
      child: Transform.scale(
        scale: scale,
        child: Text(
          text,
          style: TextStyle(
            fontSize: isSelected ? 24.sp : 19.sp,
            color: textColor,
            fontFamily: 'Pretendard-M',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
