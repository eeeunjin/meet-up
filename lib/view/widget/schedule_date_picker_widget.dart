import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:provider/provider.dart';

class ScheduleDatePicker extends StatelessWidget {
  final Function(DateTime dt) onChangeListener;

  const ScheduleDatePicker({
    super.key,
    required this.onChangeListener,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context);

    return ChangeNotifierProvider<ChatViewModel>.value(
      value: viewModel,
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Stack(
            children: [
              Positioned(
                  top: (132.h - 29.h) / 2,
                  left: 12.w,
                  child: Container(
                    width: 255.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(6.58.r)),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntrinsicWidth(
                    child: Container(
                      width: 75.w,
                      alignment: Alignment.centerRight,
                      child: _CustomPicker(
                        items: viewModel.getYearList(),
                        initialItem:
                            viewModel.selectedDate.year - viewModel.start.year,
                        onChanged: (int v) {
                          viewModel.updateYear(viewModel.start.year + v);
                        },
                        type: '년',
                      ),
                    ),
                  ),
                  SizedBox(width: 26.w),
                  SizedBox(
                    width: 50.w,
                    child: _CustomPicker(
                      items: viewModel.getMonthList(),
                      initialItem: viewModel.selectedDate.month - 1,
                      onChanged: (int v) {
                        viewModel.updateMonth(v + 1);
                      },
                      type: '월',
                    ),
                  ),
                  SizedBox(width: 26.w),
                  IntrinsicWidth(
                    child: Container(
                      width: 75.w,
                      alignment: Alignment.centerLeft,
                      child: _CustomPicker(
                        items: viewModel.getDayList(),
                        initialItem: viewModel.selectedDate.day - 1,
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
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: initialItem);

    return SizedBox(
      height: 113.h,
      child: ListWheelScrollView.useDelegate(
        controller: scrollController,
        itemExtent: 29.h,
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
    final double baseHeight = 24.h;

    Color textColor = Colors.black;
    // AutoSizeText 사용
    if (distanceFromCenter == 0) {
      scale = 1.0;
      textColor = Colors.black;
    } else if (distanceFromCenter == 1) {
      scale = 20.h / baseHeight;
      textColor = const Color(0xFF8D8D8D);
    } else {
      scale = 16.h / baseHeight;
      textColor = const Color(0xFFDFDFDF);
    }

    return Align(
      alignment: Alignment.center,
      child: Transform.scale(
        scale: scale,
        child: Text(
          '${items[index]}$type',
          maxLines: 1,
          style: TextStyle(
            fontSize: 20.sp,
            color: textColor,
            fontFamily: 'Pretendard-M',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
