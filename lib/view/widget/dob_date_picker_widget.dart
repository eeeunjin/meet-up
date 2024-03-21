import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:provider/provider.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime dt) onChangeListener;
  final DateTime start;
  final DateTime end;
  final DateTime init;

  const CustomDatePicker(
      {super.key,
      required this.start,
      required this.end,
      required this.init,
      required this.onChangeListener});

  @override
  State<StatefulWidget> createState() {
    return _CustomDatePickerState();
  }
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<SignUpDetailViewModel>(context, listen: false);

    return ChangeNotifierProvider<SignUpDetailViewModel>.value(
      value: viewModel,
      child: Consumer<SignUpDetailViewModel>(
        builder: (context, viewModel, child) {
          return Stack(
            children: [
              Positioned(
                  top: (113.h - 26.3.h) / 2,
                  left: (360.w - 274.w) / 2,
                  child: Container(
                    width: 274.w,
                    height: 26.3.h,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(6.58.r)),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntrinsicWidth(
                    child: Container(
                      width: 80.w,
                      alignment: Alignment.centerRight,
                      child: _CustomPicker(
                        items: viewModel.getYearList(),
                        initialItem:
                            viewModel.currentDate.year - viewModel.start.year,
                        onChanged: (int v) {
                          viewModel.updateYear(viewModel.start.year + v);
                        },
                        type: '년',
                      ),
                    ),
                  ),
                  SizedBox(width: 30.w),
                  SizedBox(
                    width: 55.w,
                    child: _CustomPicker(
                      items: viewModel.getMonthList(),
                      initialItem: viewModel.currentDate.month - 1,
                      onChanged: (int v) {
                        viewModel.updateMonth(v + 1);
                      },
                      type: '월',
                    ),
                  ),
                  SizedBox(width: 30.w),
                  IntrinsicWidth(
                    child: Container(
                      width: 80.w,
                      alignment: Alignment.centerLeft,
                      child: _CustomPicker(
                        items: viewModel.getDayList(),
                        initialItem: viewModel.currentDate.day - 1,
                        onChanged: (int v) {
                          viewModel.updateDay(v + 1);
                        },
                        type: '일',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CustomPicker extends StatelessWidget {
  final List<int> items;
  final int initialItem;
  final Function(int) onChanged;
  final String type;

  const _CustomPicker({
    required this.items,
    required this.initialItem,
    required this.onChanged,
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: initialItem);

    return SizedBox(
      height: 113.h,
      child: ListWheelScrollView.useDelegate(
        controller: scrollController,
        itemExtent: 25.h,
        // 필요에 따라 magnification을 조정하여 중앙 항목의 크기를 키움
        // magnification: 1.1,
        // 휠의 곡률을 변경하려면 diameterRatio 조정
        // diameterRatio: 500.0,
        // 시각적 효과를 위해 perspective 조정
        // perspective: 0.002,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            return _buildItem(context, index, initialItem, type);
          },
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, int index, int initialItem, String type) {
    int distanceFromCenter = (initialItem - index).abs();

    double scale = 1.0;
    final double baseHeight = 29.h;
    double fontSize;

    Color textColor = Colors.black;
    // AutoSizeText 사용, presetFontSizes로 고정 폰트 크기 목록 제공
    if (distanceFromCenter == 0) {
      scale = 1.0;
      fontSize = 24.11.sp;
      textColor = Colors.black;
    } else if (distanceFromCenter == 1) {
      scale = 24.h / baseHeight;
      fontSize = 19.sp;
      textColor = const Color(0xFF8D8D8D);
    } else {
      scale = 18.h / baseHeight;
      fontSize = 17.sp;
      textColor = const Color(0xFFDFDFDF);
    }

    return Align(
      alignment: Alignment.center,
      child: Transform.scale(
        scale: scale,
        child: AutoSizeText(
          '${items[index]}$type',
          maxLines: 1,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            // fontFamily: ,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
