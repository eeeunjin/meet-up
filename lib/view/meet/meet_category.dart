import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_create_view_model.dart';
import 'package:provider/provider.dart';

class MeetCategory extends StatelessWidget {
  const MeetCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
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
        ],
      )),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '카테고리 선택'),
          SizedBox(
            height: 11.h,
          ),
          _divider(),
          SizedBox(height: 33.h),
          _main(context),
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
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  // 구분선
  Widget _divider() {
    return Divider(
      height: 0.3.h,
      color: UsedColor.line,
    );
  }

  Widget _main(BuildContext context) {
    var buttonWidth = 99.03.w;
    var buttonHeight = 32.44.h;
    final viewModel = Provider.of<MeetCreateViewModel>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 33.w),
          child: Column(
            children: [
              Row(
                children: [
                  // 파란 동그라미
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: UsedColor.main),
                  ),
                  SizedBox(width: 14.46.w),
                  Text(
                    '카테고리',
                    style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 20.64.h),
              Padding(
                padding: EdgeInsets.only(left: 7.0.w),
                child: Row(
                  children: [
                    // 변경
                    GestureDetector(
                      onTap: () {
                        viewModel.selectedCategory = '취미';
                      },
                      child: Container(
                        width: 99.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.61.r),
                          border: Border.all(
                            color: UsedColor.B_line,
                            width: 2.25.w,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '취미',
                            style: AppTextStyles.PR_SB_14.copyWith(
                              color: UsedColor.charcoal_black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0.w),
                    // 기존 코드
                    ElevatedButton(
                      onPressed: () {
                        viewModel.selectedCategory = '운동';
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: Size(buttonWidth, buttonHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.61),
                          side: BorderSide(
                              color: UsedColor.B_line, width: 2.25.w),
                        ),
                      ),
                      child: const Text('운동'),
                    ),
                    SizedBox(width: 8.0.w),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.selectedCategory = '공부/학업';
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: Size(buttonWidth, buttonHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.61),
                          side: BorderSide(
                              color: UsedColor.B_line, width: 2.25.w),
                        ),
                      ),
                      child: const Text('공부/학업'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 7.w),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.selectedCategory = '휴식/친목';
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: Size(buttonWidth, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.61),
                        side:
                            BorderSide(color: UsedColor.B_line, width: 2.25.w),
                      ),
                    ),
                    child: const Text('휴식/친목'),
                  ),
                  SizedBox(width: 8.0.w),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.selectedCategory = '기타';
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      minimumSize: Size(buttonWidth, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.61),
                        side:
                            BorderSide(color: UsedColor.B_line, width: 2.25.w),
                      ),
                    ),
                    child: const Text('기타'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailCategory(BuildContext context) {
    final viewModel = Provider.of<MeetCreateViewModel>(context);
    final selectedCategory = viewModel.selectedCategory;

    Widget buildButton(String text, Function onPressed) {
      final buttonWidth = 99.03.w;
      final buttonHeight = 32.44.h;

      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          minimumSize: Size(buttonWidth, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.61),
            side: BorderSide(
              color: UsedColor.B_line,
              width: 2.25.w,
            ),
          ),
        ),
        child: Text(text),
      );
    }

    List<Widget> buildButtons(String selectedCategory) {
      switch (selectedCategory) {
        case '취미':
          return [
            // SizedBox(height: 19.52.h),
            Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.0.w)),
                    buildButton('여행', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('맛집', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('연예인', () {}),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.0.w)),
                    buildButton('사진', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('영화', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('게임', () {}),
                  ],
                ),
              ],
            ),
          ];
        case '운동':
          return [
            // SizedBox(height: 19.52.h),
            Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.0.w)),
                    buildButton('축구', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('야구', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('농구', () {}),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.0.w)),
                    buildButton('테니스', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('요가', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('헬스', () {}),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.0.w)),
                    buildButton('탁구', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('조깅', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('배드민턴', () {}),
                  ],
                ),
              ],
            ),
          ];
        case '공부/학업':
          return [
            // SizedBox(height: 19.52.h),
            Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.0.w)),
                    buildButton('취업', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('독서', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('대학', () {}),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.0.w)),
                    buildButton('미라클 모닝', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('자격증', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('아르바이트', () {}),
                  ],
                ),
              ],
            ),
          ];
        case '휴식/친목':
          return [
            // SizedBox(height: 19.52.h),
            Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.0.w)),
                    buildButton('카페', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('산책', () {}),
                    SizedBox(width: 8.0.w),
                    buildButton('저녁 식사', () {}),
                  ],
                ),
              ],
            ),
          ];
        case '기타':
          return [];
        default:
          return [
            Padding(
              padding: EdgeInsets.only(left: 20.0.w),
              child: Text(
                '상위 카테고리를 먼저 선택해주세요.',
                style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
              ),
            ),
          ];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Row(
            children: [
              Icon(Icons.circle, color: UsedColor.main, size: 12),
              SizedBox(width: 14.46.w),
              Text(
                '상세 카테고리',
                style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
        SizedBox(height: 19.52.h),
        Row(
          children: buildButtons(selectedCategory ?? ''),
        ),
      ],
    );
  }
}
