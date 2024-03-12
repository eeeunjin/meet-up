import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/view/widget/dob_date_picker_widget.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:provider/provider.dart';

class SignUpDetailContents extends StatelessWidget {
  const SignUpDetailContents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _gender(context),
        SizedBox(
          height: 55.h,
        ),
        _dateOfBirth(),
        SizedBox(
          height: 55.h,
        ),
        _address(),
        SizedBox(
          height: 55.h,
        ),
        _affiliation(),
      ],
    );
  }

  Widget _gender(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "성별을 선택해주세요.",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            "추후 수정이 불가합니다",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF868686)),
          ),
          SizedBox(height: 24.h),
          Consumer<SignUpDetailViewModel>(
            builder: (context, viewModel, child) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () => viewModel.selectGender(Gender.female),
                    child: Container(
                      width: 165.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: viewModel.selectedGender == Gender.female
                            ? const Color(0xFF7C4DFF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(19.r),
                        border: Border.all(
                            color: viewModel.selectedGender == Gender.female
                                ? const Color(0xFF7C4DFF)
                                : const Color(0xFFD2D8F8),
                            width: 2.5.w),
                      ),
                      child: Center(
                        child: Text(
                          '여성',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: viewModel.selectedGender == Gender.female
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => viewModel.selectGender(Gender.male),
                    child: Container(
                      width: 165.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: viewModel.selectedGender == Gender.male
                            ? const Color(0xFF7C4DFF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(19.r),
                        border: Border.all(
                            color: viewModel.selectedGender == Gender.male
                                ? const Color(0xFF7C4DFF)
                                : const Color(0xFFD2D8F8),
                            width: 2.5.w),
                      ),
                      child: Center(
                        child: Text(
                          '남성',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: viewModel.selectedGender == Gender.male
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dateOfBirth() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "생년월일을 선택해주세요.",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            "추후 수정이 불가합니다",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF868686)),
          ),
          SizedBox(height: 24.h),
          // datepicker
          Center(
            child: Container(
              width: 274.w,
              height: 114.h,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _address() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "거주지를 선택해주세요.",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24.h),
          // addresspicker
          Center(
            child: Container(
              width: 274.w,
              height: 114.h,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _affiliation() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "소속을 선택해주세요.",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
