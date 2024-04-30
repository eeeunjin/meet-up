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
        _divider(),
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

Widget _divider() {
  return Divider(
    height: 0.91.h,
    color: const Color(0xffd9d9d9),
  );
}

Widget _main(BuildContext context) {
  return Container(
    color: Colors.white,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 32.36.h),
          _category(context),
          SizedBox(height: 32.65.h),
          _divider(),
          SizedBox(height: 33.48.h),
          _detailCategory(context),
          SizedBox(height: 33.73.h),
          _divider(),
          SizedBox(height: 32.91.h),
          _area(context),
          SizedBox(height: 32.09.h),
          _divider(),
          SizedBox(height: 31.96.h),
          _age(context),
          SizedBox(height: 32.h),
          _divider(),
          SizedBox(height: 33.51.h),
          _genderRatio(context),
          SizedBox(height: 33.51.h),
          _divider(),
          SizedBox(height: 33.51.h),
          _detailedRules(context),
          SizedBox(height: 42.89.h),
          // _bottom(context),
        ],
      ),
    ),
  );
}

Widget _category(BuildContext context) {
  var buttonWidth = 99.03.w;
  var buttonHeight = 32.44.h;
  List<String> selectedCategories = [];

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category); // 이미 선택된 카테고리일 경우 제거
    } else {
      selectedCategories.add(category); // 선택되지 않은 카테고리일 경우 추가
    }
  }

  return Consumer<MeetBrowseViewModel>(
    builder: (context, viewModel, _) {
      Color getButtonBackgroundColor(String category) {
        return viewModel.selectedCategory == category
            ? UsedColor.button
            : Colors.white;
      }

      Color getButtonBorderColor(String category) {
        return viewModel.selectedCategory == category
            ? UsedColor.button
            : UsedColor.b_line;
      }

      // void toggleCategory(String category) {
      //   viewModel.selectedCategory = category;
      // }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 33.w),
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
          SizedBox(height: 21.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40.0.w),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleCategory('취미');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: getButtonBackgroundColor('취미'),
                      minimumSize: Size(buttonWidth, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.61),
                        side: BorderSide(
                            color: getButtonBorderColor('취미'), width: 2.25.w),
                      ),
                    ),
                    child: const Text('취미'),
                  ),
                  SizedBox(width: 8.0.w),
                  ElevatedButton(
                    onPressed: () {
                      toggleCategory('운동');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: getButtonBackgroundColor('운동'),
                      minimumSize: Size(buttonWidth, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.61),
                        side: BorderSide(
                            color: getButtonBorderColor('운동'), width: 2.25.w),
                      ),
                    ),
                    child: const Text('운동'),
                  ),
                  SizedBox(width: 8.0.w),
                  ElevatedButton(
                    onPressed: () {
                      toggleCategory('공부/학업');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: getButtonBackgroundColor('공부/학업'),
                      minimumSize: Size(buttonWidth, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.61),
                        side: BorderSide(
                            color: getButtonBorderColor('공부/학업'),
                            width: 2.25.w),
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
                    padding: EdgeInsets.only(left: 40.0.w),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleCategory('휴식/친목');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: getButtonBackgroundColor('휴식/친목'),
                      minimumSize: Size(buttonWidth, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.61),
                        side: BorderSide(
                            color: getButtonBorderColor('휴식/친목'),
                            width: 2.25.w),
                      ),
                    ),
                    child: const Text('휴식/친목'),
                  ),
                  SizedBox(width: 8.0.w),
                  ElevatedButton(
                    onPressed: () {
                      toggleCategory('기타');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: getButtonBackgroundColor('기타'),
                      minimumSize: Size(buttonWidth, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.61),
                        side: BorderSide(
                            color: getButtonBorderColor('기타'), width: 2.25.w),
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
    },
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
            color: UsedColor.b_line,
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
          SizedBox(height: 19.h),
          Column(
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 40.0.w)),
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
                  Padding(padding: EdgeInsets.only(left: 40.0.w)),
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
          SizedBox(height: 19.h),
          Column(
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 40.0.w)),
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
                  Padding(padding: EdgeInsets.only(left: 40.0.w)),
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
                  Padding(padding: EdgeInsets.only(left: 40.0.w)),
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
          SizedBox(height: 19.h),
          Column(
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 40.0.w)),
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
                  Padding(padding: EdgeInsets.only(left: 40.0.w)),
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
          SizedBox(height: 19.h),
          Column(
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 40.0.w)),
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
            padding: EdgeInsets.only(left: 55.76.w, bottom: 8.h),
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
        padding: EdgeInsets.only(left: 33.w),
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
      SizedBox(height: 8.h),
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
        padding: EdgeInsets.only(left: 33.w),
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
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 26.w),
              child: GestureDetector(
                onTap: () {
                  context.goNamed('meetFilterArea');
                },
                child: SizedBox(child: Image.asset(ImagePath.nextArrow)),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Widget _age(BuildContext context) {
  List<String> options = ['20대', '30대', '40대', '50대'];

  return Consumer<MeetBrowseViewModel>(
    builder: (context, viewModel, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 33.w),
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
          SizedBox(
            height: 22.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 36.w),
            child: Wrap(
              spacing: 7.62.w,
              runSpacing: 7.62.h,
              children: options.map((option) {
                bool isSelected = viewModel.selectedAge.contains(option);
                return GestureDetector(
                  onTap: () {
                    viewModel.selectAge(option);
                  },
                  child: Container(
                    width: 74.38.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: isSelected ? UsedColor.button : Colors.white,
                      borderRadius: BorderRadius.circular(19.r),
                      border: Border.all(
                        color: isSelected
                            ? UsedColor.button
                            : const Color(0xFFD2D8F8),
                        width: 1.75.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: AppTextStyles.PR_M_12.copyWith(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    },
  );
}

Widget _genderRatio(BuildContext context) {
  MeetBrowseViewModel viewModel =
      Provider.of<MeetBrowseViewModel>(context, listen: true);

  return Padding(
    padding: EdgeInsets.only(left: 27.0.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.0.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: UsedColor.main),
              ),
              SizedBox(
                width: 13.85.w,
              ),
              // title
              Container(
                alignment: Alignment.center,
                child: Text(
                  '성비',
                  style: AppTextStyles.PR_SB_16,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Padding(
          padding: EdgeInsets.only(left: 25.0.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => viewModel.selectWomen4(),
                child: Image.asset(
                  viewModel.isWomen4Selected
                      ? ImagePath.grW4
                      : ImagePath.grW4Empty,
                  width: 76.w,
                  height: 76.h,
                ),
              ),
              SizedBox(width: 24.w),
              GestureDetector(
                onTap: () => viewModel.selectWomen2Men2(),
                child: Image.asset(
                  viewModel.isWomen2Men2Selected
                      ? ImagePath.grW2M2
                      : ImagePath.grW2M2Empty,
                  width: 76.w,
                  height: 76.h,
                ),
              ),
              SizedBox(width: 24.w),
              GestureDetector(
                onTap: () => viewModel.selectMen4(),
                child: Image.asset(
                  viewModel.isMen4Selected
                      ? ImagePath.grM4
                      : ImagePath.grM4Empty,
                  width: 76.w,
                  height: 76.h,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _detailedRules(BuildContext context) {
  final List<bool> selectedRules = List.generate(5, (_) => false);

  void toggleRule(int index) {
    selectedRules[index] = !selectedRules[index];
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 33.w),
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
      InkWell(
        onTap: () {
          toggleRule(0);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 55.w, right: 41.w),
          child: Row(
            children: [
              Text(
                '만남 시 대화 녹음',
                style: AppTextStyles.PR_R_14.copyWith(
                    color:
                        selectedRules[0] ? UsedColor.violet : UsedColor.text_5),
              ),
              const Spacer(),
              const Icon(Icons.check, color: UsedColor.text_5, size: 14.67),
            ],
          ),
        ),
      ),
      SizedBox(height: 23.h),
      // 규칙 2
      Padding(
        padding: EdgeInsets.only(left: 55.w, right: 41.w),
        child: Row(
          children: [
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
        padding: EdgeInsets.only(left: 55.w, right: 41.w),
        child: Row(
          children: [
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
        padding: EdgeInsets.only(left: 55.w, right: 41.w),
        child: Row(
          children: [
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
        padding: EdgeInsets.only(left: 55.w, right: 41.w),
        child: Row(
          children: [
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
