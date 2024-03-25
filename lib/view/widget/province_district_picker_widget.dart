import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/model/province_district_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:provider/provider.dart';

class ProvinceDisctrictPicker extends StatelessWidget {
  const ProvinceDisctrictPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpDetailViewModel>(context);

    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 60.0),
      child: Stack(
        children: [
          Positioned(
            top: 65.h,
            left: 15.w,
            child: Container(
              width: 274.w,
              height: 26.3.h,
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
                  height: 165.h,
                  child: ListWheelScrollView(
                    itemExtent: 35.0,
                    physics: const FixedExtentScrollPhysics(),
                    diameterRatio: 0.5,
                    controller: viewModel.provinceScrollController,
                    children:
                        ProvinceDistrict.districts.keys.map((String province) {
                      final isSelectedselectedProvince =
                          (province == viewModel.selectedProvince);
                      return _buildItem(province, isSelectedselectedProvince);
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
                  height: 165.h,
                  child: ListWheelScrollView(
                    itemExtent: 35.0,
                    physics: const FixedExtentScrollPhysics(),
                    diameterRatio: 0.5,
                    controller: viewModel.districtScrollController,
                    children: (ProvinceDistrict
                                .districts[viewModel.selectedProvince] ??
                            [])
                        .map((String district) {
                      final isSelectedDistrict =
                          (district == viewModel.selectedDistrict);
                      return _buildItem(district, isSelectedDistrict);
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

  Widget _buildItem(String text, bool isSelected) {
    final double baseFontSize = isSelected ? 20.5.sp : 19.5.sp;
    final double scaleFactor = isSelected ? 1.15 : 1.05;
    final Color textColor = isSelected ? Colors.black : const Color(0xFF8D8D8D);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Transform.scale(
          scale: scaleFactor,
          child: Text(
            text,
            style: TextStyle(
              fontSize: baseFontSize,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
