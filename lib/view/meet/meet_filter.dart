import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/meet_browse_view_model.dart';
import 'package:provider/provider.dart';

class MeetFilterMain extends StatelessWidget {
  const MeetFilterMain({super.key});

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
          ],
        ),
      ),
    );
  }
}

// header
Widget _header(BuildContext context) {
  return Center(
    child: Column(
      children: [
        header(back: _back(context), title: '필터'),
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
        Navigator.pop(context);
      },
      child: Image.asset(
        ImagePath.close,
        width: 40.w,
        height: 40.h,
      ),
    ),
  );
}

Widget _main(BuildContext context) {
  return Container(
    color: Colors.white,
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          children: [
            SizedBox(height: 32.36.h),
            _category(context),
            SizedBox(height: 32.65.h),
            Divider(
              height: 0.3.h,
              color: UsedColor.line,
            ),
            SizedBox(height: 33.48.h),
            _detailCategory(context),
            SizedBox(height: 33.73.h),
            Divider(
              height: 0.3.h,
              color: UsedColor.line,
            ),
            SizedBox(height: 32.91.h),
            _area(context),
            SizedBox(height: 32.09.h),
            Divider(
              height: 0.3.h,
              color: UsedColor.line,
            ),
            SizedBox(height: 31.96.h),
            _age(context),
            SizedBox(height: 32.h),
            Divider(
              height: 0.3.h,
              color: UsedColor.line,
            ),
            SizedBox(height: 33.51.h),
            _genderRatio(context),
            SizedBox(height: 33.51.h),
            Divider(
              height: 0.3.h,
              color: UsedColor.line,
            ),
            SizedBox(height: 33.51.h),
            _detailedRules(context),
            SizedBox(height: 42.89.h),
            // _bottom(context),
          ],
        ),
      ),
    ),
  );
}

Widget _category(BuildContext context) {
  var buttonWidth = 99.03.w;
  var buttonHeight = 32.44.h;
  final viewModel = Provider.of<MeetBrowseViewModel>(context, listen: false);
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
              '카테고리',
              style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
      SizedBox(height: 20.64.h),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0.w),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.selectedCategory = '취미';
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  minimumSize: Size(buttonWidth, buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.61),
                    side: BorderSide(color: UsedColor.B_line, width: 2.25.w),
                  ),
                ),
                child: const Text('취미'),
              ),
              SizedBox(width: 8.0.w),
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
                    side: BorderSide(color: UsedColor.B_line, width: 2.25.w),
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
                    side: BorderSide(color: UsedColor.B_line, width: 2.25.w),
                  ),
                ),
                child: const Text('공부/학업'),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0.w),
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
                    side: BorderSide(color: UsedColor.B_line, width: 2.25.w),
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
                    side: BorderSide(color: UsedColor.B_line, width: 2.25.w),
                  ),
                ),
                child: const Text('기타'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Widget _detailCategory(BuildContext context) {
  final viewModel = Provider.of<MeetBrowseViewModel>(context);
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

Widget _area(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 20.w, right: 7.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.circle, color: UsedColor.main, size: 12),
                SizedBox(width: 14.46.w),
                Text(
                  '지역',
                  style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
            ),
          ],
        ),
      )
    ],
  );
}

Widget _age(BuildContext context) {
  final buttonWidth = 74.43.w;
  final buttonHeight = 28.h;
  List<String> ageGroups = ['20대', '30대', '40대', '50대'];

  return Consumer<MeetBrowseViewModel>(
    builder: (context, viewModel, _) {
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
                  '나이',
                  style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 22.h),
            child: Row(
              children: [
                for (int i = 0; i < ageGroups.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                        right: i != ageGroups.length - 1 ? 7.62.w : 0),
                    child: ElevatedButton(
                      onPressed: () {
                        viewModel.toggleSelection(i);
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          return viewModel.isSelected[i]
                              ? Colors.white
                              : Colors.black;
                        }),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          return viewModel.isSelected[i]
                              ? UsedColor.button
                              : Colors.white;
                        }),
                        minimumSize: MaterialStateProperty.all(
                            Size(buttonWidth, buttonHeight)),
                        shape: MaterialStateProperty.resolveWith<
                            RoundedRectangleBorder>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed) ||
                                states.contains(MaterialState.selected)) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19),
                              );
                            } else {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19),
                                side: BorderSide(
                                  color: UsedColor.B_line,
                                  width: 1.75.w,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      child: Text(ageGroups[i], style: AppTextStyles.PR_M_12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Widget _genderRatio(BuildContext context) {
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
              '성비',
              style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
      SizedBox(height: 14.h),
      Padding(
        padding: EdgeInsets.only(left: 38.w),
        child: Row(
          children: [
            SizedBox(width: 4.64.w),
            Image.asset(
              ImagePath.grW4Empty,
              width: 76.w,
              height: 76.h,
            ),
            SizedBox(width: 24.w),
            Image.asset(
              ImagePath.grW2M2Empty,
              width: 76.w,
              height: 76.h,
            ),
            SizedBox(width: 24.w),
            Image.asset(
              ImagePath.grM4Empty,
              width: 76.w,
              height: 76.h,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _detailedRules(BuildContext context) {
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
              '세부 규칙',
              style: AppTextStyles.PR_SB_15.copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
      SizedBox(height: 19.1.h),

      // 규칙 1
      Padding(
        padding: EdgeInsets.only(left: 35.46.w, right: 21.35.w),
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Text(
              '만남 시 대화 녹음',
              style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
            ),
            const Spacer(),
            const Icon(Icons.check, color: UsedColor.text_5, size: 14.67),
          ],
        ),
      ),
      SizedBox(height: 20.38.h),
      // 규칙 2
      Padding(
        padding: EdgeInsets.only(left: 35.46.w, right: 21.35.w),
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Text(
              '만남 후 앱을 통해 연락처 공유',
              style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
            ),
            const Spacer(),
            const Icon(Icons.check, color: UsedColor.text_5, size: 14.67),
          ],
        ),
      ),
      SizedBox(height: 20.38.h),
      // 규칙 3
      Padding(
        padding: EdgeInsets.only(left: 35.46.w, right: 21.35.w),
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Text(
              '아는 지인과 동반 신청',
              style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
            ),
            const Spacer(),
            const Icon(Icons.check, color: UsedColor.text_5, size: 14.67),
          ],
        ),
      ),
      SizedBox(height: 20.38.h),
      // 규칙 4
      Padding(
        padding: EdgeInsets.only(left: 35.46.w, right: 21.35.w),
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Text(
              '첫 만남에 2차 이동',
              style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
            ),
            const Spacer(),
            const Icon(Icons.check, color: UsedColor.text_5, size: 14.67),
          ],
        ),
      ),
      SizedBox(height: 20.38.h),
      // 규칙 5
      Padding(
        padding: EdgeInsets.only(left: 35.46.w, right: 21.35.w),
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Text(
              '귀가 시 동성과 동행',
              style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
            ),
            const Spacer(),
            const Icon(Icons.check, color: UsedColor.text_5, size: 14.67),
          ],
        ),
      ),
    ],
  );
}

// Widget _bottom(BuildContext context) {}
