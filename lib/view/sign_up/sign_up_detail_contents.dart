import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
        _affiliation(context),
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

          CupertinoAddressPicker(districts: districts),
          // Center(
          //   child: Container(
          //     width: 274.w,
          //     height: 114.h,
          //     color: Colors.black,
          //   ),
          // ),
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
                                ? const Color(0xFF7C4DFF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(19.r),
                            border: Border.all(
                              color: viewModel.selectedAffiliation ==
                                      Affiliation.student
                                  ? const Color(0xFF7C4DFF)
                                  : const Color(0xFFD2D8F8),
                              width: 2.5.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '대학생',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
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
                                ? const Color(0xFF7C4DFF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(19.r),
                            border: Border.all(
                              color: viewModel.selectedAffiliation ==
                                      Affiliation.employee
                                  ? const Color(0xFF7C4DFF)
                                  : const Color(0xFFD2D8F8),
                              width: 2.5.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '직장인',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
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
                                ? const Color(0xFF7C4DFF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(19.r),
                            border: Border.all(
                              color: viewModel.selectedAffiliation ==
                                      Affiliation.freelancer
                                  ? const Color(0xFF7C4DFF)
                                  : const Color(0xFFD2D8F8),
                              width: 2.5.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '프리랜서',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
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
                                ? const Color(0xFF7C4DFF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(19.r),
                            border: Border.all(
                              color: viewModel.selectedAffiliation ==
                                      Affiliation.unemployed
                                  ? const Color(0xFF7C4DFF)
                                  : const Color(0xFFD2D8F8),
                              width: 2.5.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '무직',
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
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

class CupertinoAddressPicker extends StatefulWidget {
  final Map<String, List<String>> districts;

  const CupertinoAddressPicker({Key? key, required this.districts})
      : super(key: key);

  @override
  _CupertinoAddressPickerState createState() => _CupertinoAddressPickerState();
}

final Map<String, List<String>> districts = {
  '서울특별시': [
    '종로구',
    '중구',
    '용산구',
    '성동구',
    '광진구',
    '동대문구',
    '중랑구',
    '성북구',
    '강북구',
    '도봉구',
    '노원구',
    '은평구',
    '서대문구',
    '마포구',
    '양천구',
    '강서구',
    '구로구',
    '금천구',
    '영등포구',
    '동작구',
    '관악구',
    '서초구',
    '강남구',
    '송파구',
    '강동구'
  ],
  '부산광역시': [
    '중구',
    '서구',
    '동구',
    '영도구',
    '부산진구',
    '동래구',
    '남구',
    '북구',
    '해운대구',
    '사하구',
    '금정구',
    '강서구',
    '연제구',
    '수영구',
    '사상구',
    '기장군'
  ],
  '대구광역시': ['중구', '동구', '서구', '남구', '북구', '수성구', '달서구', '달성군'],
  '인천광역시': ['중구', '동구', '미추홀구', '연수구', '남동구', '부평구', '계양구', '서구', '강화군', '옹진군'],
  '광주광역시': ['동구', '서구', '남구', '북구', '광산구'],
  '대전광역시': ['동구', '중구', '서구', '유성구', '대덕구'],
  '울산광역시': ['중구', '남구', '동구', '북구', '울주군'],
  '세종특별자치시': ['세종특별자치시'],
  '경기도': [
    '수원시',
    '성남시',
    '의정부시',
    '안양시',
    '부천시',
    '광명시',
    '평택시',
    '동두천시',
    '안산시',
    '고양시',
    '과천시',
    '구리시',
    '남양주시',
    '오산시',
    '시흥시',
    '군포시',
    '의왕시',
    '하남시',
    '용인시',
    '파주시',
    '이천시',
    '안성시',
    '김포시',
    '화성시',
    '광주시',
    '양주시',
    '포천시',
    '여주시',
    '연천군',
    '가평군',
    '양평군'
  ],
  '강원도': [
    '춘천시',
    '원주시',
    '강릉시',
    '동해시',
    '태백시',
    '속초시',
    '삼척시',
    '홍천군',
    '횡성군',
    '영월군',
    '평창군',
    '정선군',
    '철원군',
    '화천군',
    '양구군',
    '인제군',
    '고성군',
    '양양군'
  ],
  '충청북도': [
    '청주시',
    '충주시',
    '제천시',
    '보은군',
    '옥천군',
    '영동군',
    '증평군',
    '진천군',
    '괴산군',
    '음성군',
    '단양군'
  ],
  '충청남도': [
    '천안시',
    '공주시',
    '보령시',
    '아산시',
    '서산시',
    '논산시',
    '계룡시',
    '당진시',
    '금산군',
    '부여군',
    '서천군',
    '청양군',
    '홍성군',
    '예산군',
    '태안군'
  ],
  '전라북도': [
    '전주시',
    '군산시',
    '익산시',
    '정읍시',
    '남원시',
    '김제시',
    '완주군',
    '진안군',
    '무주군',
    '장수군',
    '임실군',
    '순창군',
    '고창군',
    '부안군'
  ],
  '전라남도': [
    '목포시',
    '여수시',
    '순천시',
    '나주시',
    '광양시',
    '담양군',
    '곡성군',
    '구례군',
    '고흥군',
    '보성군',
    '화순군',
    '장흥군',
    '강진군',
    '해남군',
    '영암군',
    '무안군',
    '함평군',
    '영광군',
    '장성군',
    '완도군',
    '진도군',
    '신안군'
  ],
  '경상북도': [
    '포항시',
    '경주시',
    '김천시',
    '안동시',
    '구미시',
    '영주시',
    '영천시',
    '상주시',
    '문경시',
    '경산시',
    '군위군',
    '의성군',
    '청송군',
    '영양군',
    '영덕군',
    '청도군',
    '고령군',
    '성주군',
    '칠곡군',
    '예천군',
    '봉화군',
    '울진군',
    '울릉군'
  ],
  '경상남도': [
    '창원시',
    '진주시',
    '통영시',
    '사천시',
    '김해시',
    '밀양시',
    '거제시',
    '양산시',
    '의령군',
    '함안군',
    '창녕군',
    '고성군',
    '남해군',
    '하동군',
    '산청군',
    '함양군',
    '거창군',
    '합천군'
  ],
  '제주특별자치도': ['제주시', '서귀포시'],
};

class _CupertinoAddressPickerState extends State<CupertinoAddressPicker> {
  String? selectedCity; // 선택된 도시
  String? selectedDistrict; // 선택된 구/군

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 35.0,
              backgroundColor: Colors.grey.withOpacity(0.1),
              onSelectedItemChanged: (int index) {
                setState(() {
                  selectedCity = widget.districts.keys.elementAt(index);
                  selectedDistrict = null;
                });
              },
              children: widget.districts.keys.map((String city) {
                return Text(city); // 도시 목록을 텍스트 위젯으로 변환하여 출력
              }).toList(),
            ),
          ),
          Expanded(
            child: selectedCity != null
                ? SingleChildScrollView(
                    child: CupertinoPicker(
                      itemExtent: 35.0,
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          selectedDistrict =
                              widget.districts[selectedCity!]?[index];
                        });
                      },
                      children: (widget.districts[selectedCity!] ?? [])
                          .map((String district) {
                        return Text(district);
                      }).toList(),
                    ),
                  )
                : Container(), // 선택된 도시가 없을 때
          ),
        ],
      ),
    );
  }
}
