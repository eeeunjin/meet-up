import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/view/widget/dob_date_picker_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view/widget/province_district_picker_widget.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:provider/provider.dart';

class SignUpDetailOneContents extends StatelessWidget {
  const SignUpDetailOneContents({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpDetailViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 47.h,
        ),
        _gender(context),
        SizedBox(
          height: 46.h,
        ),
        _dateOfBirth(context, viewModel),
        SizedBox(
          height: 55.h,
        ),
        _address(),
        SizedBox(
          height: 55.h,
        ),
        _affiliation(context),
        SizedBox(
          height: 88.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0.w),
          child: NextButton(
            width: 328.w,
            height: 56.h,
            text: '다음',
            onTap: () {
              context.goNamed('signUpDetailTwo');
            },
            enable: viewModel.selectedAllComponents,
            backgroundColor: viewModel.selectedAllComponents
                ? UsedColor.button
                : UsedColor.grey1,
            textStyle: TextStyle(
              color:
                  viewModel.selectedAllComponents ? Colors.white : Colors.black,
              fontSize: 18.sp,
            ),
          ),
        ),
        SizedBox(
          height: 56.h,
        )
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
            style: AppTextStyles.PR_B_22.copyWith(color: Colors.black),
          ),
          SizedBox(height: 8.h),
          Text(
            "추후 수정이 불가합니다",
            style: AppTextStyles.SU_R_12.copyWith(color: UsedColor.text_3),
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
                            ? UsedColor.button
                            : Colors.white,
                        borderRadius: BorderRadius.circular(19.r),
                        border: Border.all(
                            color: viewModel.selectedGender == Gender.female
                                ? UsedColor.button
                                : UsedColor.b_line,
                            width: 2.5.w),
                      ),
                      child: Center(
                        child: Text(
                          '여성',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontFamily: "Pretendard-SB",
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
                            ? UsedColor.button
                            : Colors.white,
                        borderRadius: BorderRadius.circular(19.r),
                        border: Border.all(
                            color: viewModel.selectedGender == Gender.male
                                ? UsedColor.button
                                : UsedColor.b_line,
                            width: 2.5.w),
                      ),
                      child: Center(
                        child: Text(
                          '남성',
                          style: TextStyle(
                            fontFamily: "Pretendard-SB",
                            fontSize: 17.sp,
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

  Widget _dateOfBirth(BuildContext context, SignUpDetailViewModel viewModel) {
    void onDateChange(DateTime newDate) {
      viewModel.updateDate(
          newDate); // This will notify all the listeners about date change.
    }

    return Padding(
      padding: EdgeInsets.only(left: 25.0.w, right: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "생년월일을 선택해주세요.",
            style: AppTextStyles.PR_B_22.copyWith(color: Colors.black),
          ),
          SizedBox(height: 8.h),
          Text(
            "추후 수정이 불가합니다",
            style: AppTextStyles.SU_R_12.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 24.h),
          // Mark - datepicker
          DobDatePicker(
            onChangeListener: onDateChange,
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
            style: AppTextStyles.PR_B_22.copyWith(color: Colors.black),
          ),
          SizedBox(height: 10.h),
          const ProvinceDistrictPicker(),
        ],
      ),
    );
  }

  Widget _affiliation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "소속을 선택해주세요.",
            style: AppTextStyles.PR_B_22.copyWith(color: Colors.black),
          ),
          SizedBox(height: 46.h),
          Consumer<SignUpDetailViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            viewModel.selectAffiliation(Affiliation.student),
                        child: Container(
                          width: 165.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: viewModel.selectedAffiliation ==
                                    Affiliation.student
                                ? UsedColor.button
                                : Colors.white,
                            borderRadius: BorderRadius.circular(19.r),
                            border: Border.all(
                              color: viewModel.selectedAffiliation ==
                                      Affiliation.student
                                  ? UsedColor.button
                                  : UsedColor.b_line,
                              width: 2.5.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '대학생',
                              style: TextStyle(
                                fontFamily: 'Pretendard-SB',
                                fontSize: 17.sp,
                                color: viewModel.selectedAffiliation ==
                                        Affiliation.student
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () =>
                            viewModel.selectAffiliation(Affiliation.employee),
                        child: Container(
                          width: 165.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: viewModel.selectedAffiliation ==
                                    Affiliation.employee
                                ? UsedColor.button
                                : Colors.white,
                            borderRadius: BorderRadius.circular(19.r),
                            border: Border.all(
                              color: viewModel.selectedAffiliation ==
                                      Affiliation.employee
                                  ? UsedColor.button
                                  : UsedColor.b_line,
                              width: 2.5.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '직장인',
                              style: TextStyle(
                                fontFamily: 'Pretendard-SB',
                                fontSize: 17.sp,
                                color: viewModel.selectedAffiliation ==
                                        Affiliation.employee
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            viewModel.selectAffiliation(Affiliation.freelancer),
                        child: Container(
                          width: 165.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: viewModel.selectedAffiliation ==
                                    Affiliation.freelancer
                                ? UsedColor.button
                                : Colors.white,
                            borderRadius: BorderRadius.circular(19.r),
                            border: Border.all(
                              color: viewModel.selectedAffiliation ==
                                      Affiliation.freelancer
                                  ? UsedColor.button
                                  : UsedColor.b_line,
                              width: 2.5.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '프리랜서',
                              style: TextStyle(
                                fontFamily: 'Pretendard-SB',
                                fontSize: 17.sp,
                                color: viewModel.selectedAffiliation ==
                                        Affiliation.freelancer
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () =>
                            viewModel.selectAffiliation(Affiliation.unemployed),
                        child: Container(
                          width: 165.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: viewModel.selectedAffiliation ==
                                    Affiliation.unemployed
                                ? UsedColor.button
                                : Colors.white,
                            borderRadius: BorderRadius.circular(19.r),
                            border: Border.all(
                              color: viewModel.selectedAffiliation ==
                                      Affiliation.unemployed
                                  ? UsedColor.button
                                  : UsedColor.b_line,
                              width: 2.5.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '무직',
                              style: TextStyle(
                                fontFamily: 'Pretendard-SB',
                                fontSize: 17.sp,
                                color: viewModel.selectedAffiliation ==
                                        Affiliation.unemployed
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
