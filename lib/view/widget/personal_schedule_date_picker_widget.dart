import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/view_model/schedule/schedule_add_personal_schdule_view_model.dart';
import 'package:provider/provider.dart';

class PersonalScheduleDatePicker extends StatelessWidget {
  const PersonalScheduleDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ScheduleAddPersonalScheduleViewModel>(context);
    FixedExtentScrollController yearScrollController =
        FixedExtentScrollController();
    FixedExtentScrollController monthScrollController =
        FixedExtentScrollController();
    FixedExtentScrollController dayScrollController =
        FixedExtentScrollController();

    if (viewModel.originalRoomModel != null) {
      logger.d(viewModel
          .getMonthList()
          .indexWhere((element) => element == viewModel.selectedDate.month));

      yearScrollController = FixedExtentScrollController(
          initialItem: viewModel
              .getYearList()
              .indexWhere((element) => element == viewModel.selectedDate.year));
      monthScrollController = FixedExtentScrollController(
          initialItem: viewModel.getMonthList().indexWhere(
              (element) => element == viewModel.selectedDate.month));
      dayScrollController = FixedExtentScrollController(
          initialItem: viewModel
              .getDayList()
              .indexWhere((element) => element == viewModel.selectedDate.day));
    }

    return ChangeNotifierProvider<ScheduleAddPersonalScheduleViewModel>.value(
      value: viewModel,
      child: Consumer<ScheduleAddPersonalScheduleViewModel>(
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
                        scrollController: yearScrollController,
                        initialItem: viewModel.selectedDate.year,
                        onChanged: (int v) {
                          viewModel
                              .updateYear(viewModel.getYearList().elementAt(v));
                          monthScrollController.jumpToItem(0);
                          dayScrollController.jumpToItem(0);
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
                      scrollController: monthScrollController,
                      initialItem: viewModel.selectedDate.month,
                      onChanged: (int v) {
                        viewModel
                            .updateMonth(viewModel.getMonthList().elementAt(v));
                        dayScrollController.jumpToItem(0);
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
                        scrollController: dayScrollController,
                        initialItem: viewModel.selectedDate.day,
                        onChanged: (int v) {
                          viewModel
                              .updateDay(viewModel.getDayList().elementAt(v));
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
  final FixedExtentScrollController scrollController;

  const _CustomPicker({
    required this.items,
    required this.initialItem,
    required this.onChanged,
    super.key,
    required this.type,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
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
    int distanceFromCenter = (initialItem - items[index]).abs();

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
