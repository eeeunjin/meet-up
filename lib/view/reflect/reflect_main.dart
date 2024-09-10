import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/reflect/reflect_writing_diary.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';

class ReflectMain extends StatelessWidget {
  const ReflectMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Container(
                padding: EdgeInsets.only(
                  left: 27.w,
                  right: 26.w,
                  bottom: 28.h,
                ),
                color: UsedColor.bg_color,
                child: Column(
                  children: [
                    SizedBox(height: 28.h),
                    _myRecordSection(),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImagePath.reflectDiary,
                          width: 28.w,
                          height: 28.h,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          '일기를 작성하면 등급을 올릴 수 있어요!',
                          style: AppTextStyles.PR_M_13.copyWith(
                            color: UsedColor.text_4,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _diaryListContainer(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(title: '성찰', back: null),
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

//MARK: -  나의 기록
  Widget _myRecordSection() {
    return Container(
      width: 340.w,
      height: 130.h,
      padding: EdgeInsets.only(
        left: 28.w,
        right: 28.w,
        top: 20.h,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(29.r)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '나의 기록',
                style: AppTextStyles.PR_SB_20.copyWith(
                  color: UsedColor.charcoal_black,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '00개 작성',
                style: AppTextStyles.PR_M_14.copyWith(
                  color: UsedColor.text_3,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  '더보기 >',
                  style: AppTextStyles.PR_M_14.copyWith(
                    color: UsedColor.text_4,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            radius: 45.w,
            backgroundColor: Colors.transparent,
            child: Image.asset(ImagePath.cogySelect),
          ),
        ],
      ),
    );
  }

//MARK: -  작성 가능한 일기 컨테이너
  Widget _diaryListContainer(BuildContext context) {
    return Container(
      width: 340.w,
      // height: 460.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 19.h,
              left: 26.w,
              right: 26.w,
              bottom: 20.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '작성 가능한 일기',
                  style: AppTextStyles.PR_SB_18.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    '더보기 >',
                    style: AppTextStyles.PR_M_14.copyWith(
                      color: UsedColor.text_4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.h,
            thickness: 0.3.h,
            color: UsedColor.line,
          ),
          _diaryList(context),
        ],
      ),
    );
  }

//MARK: -  작성 가능한 일기 리스트
  Widget _diaryList(BuildContext context) {
    final diaryEntries = [
      {'title': '초보 클밍 모임', 'date': '2024.02.07. (수) 오후 7:30'},
      {'title': '돼지 파티', 'date': '2024.02.09. (금) 오후 7:30'},
      {'title': '제로부터 시작하는 오타쿠', 'date': '2024.02.07. (수) 오후 7:30'},
      {'title': '인생 상담', 'date': '2024.02.07. (수) 오후 7:30'},
    ];

    return Column(
      children: diaryEntries.asMap().entries.map((entry) {
        int index = entry.key;
        var data = entry.value;
        bool isLast = index == diaryEntries.length - 1;

        return Column(
          children: [
            _diaryEntry(
              context: context,
              title: data['title']!,
              date: data['date']!,
            ),
            if (!isLast)
              Divider(
                height: 0.h,
                thickness: 0.3.h,
                color: UsedColor.line,
              ),
          ],
        );
      }).toList(),
    );
  }

//MARK: - 개별 일기 항목
  Widget _diaryEntry({
    required BuildContext context,
    required String title,
    required String date,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: 28.h,
        bottom: 28.h,
        left: 28.w,
        right: 25.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.PR_SB_16.copyWith(
                  color: UsedColor.charcoal_black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                date,
                style: AppTextStyles.PR_SB_14.copyWith(
                  color: UsedColor.text_3,
                ),
              ),
            ],
          ),
          _buildWriteDiaryButton(context),
        ],
      ),
    );
  }

//MARK: -   일기 쓰기 버튼
  Widget _buildWriteDiaryButton(BuildContext context) {
    return SizedBox(
      width: 77.w,
      height: 24.h,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ReflectWritingDiary()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF1F3FD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.88.r),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        ),
        child: Text(
          '일기 쓰기',
          style: AppTextStyles.SU_R_12.copyWith(
            color: UsedColor.charcoal_black,
          ),
        ),
      ),
    );
  }
}
