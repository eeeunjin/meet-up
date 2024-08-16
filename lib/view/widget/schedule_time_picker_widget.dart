import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/view_model/chat/chat_room_schedule_host_view_model.dart';
import 'package:provider/provider.dart';

class ScheduleTimePicker extends StatelessWidget {
  final Function(TimeOfDay) onTimeChanged;

  const ScheduleTimePicker({
    super.key,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatRoomSchduleHostViewModel>(context);

    return Stack(
      children: [
        Positioned(
            top: (132.h - 40.h) / 2,
            left: 12.w,
            right: 12.w,
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
            SizedBox(
              width: 50.w,
              child: _TimePicker(
                items: List<int>.generate(24, (index) => index),
                initialItem: viewModel.selectedTime.hour,
                onChanged: (int hour) {
                  viewModel.updateTime(TimeOfDay(
                      hour: hour, minute: viewModel.selectedTime.minute));
                },
                type: 'hour',
              ),
            ),
            SizedBox(width: 30.w),
            SizedBox(
              width: 50.w,
              child: _TimePicker(
                items: List<int>.generate(12, (index) => index * 5),
                initialItem: viewModel.selectedTime.minute ~/ 5,
                onChanged: (int minute) {
                  viewModel.updateTime(TimeOfDay(
                      hour: viewModel.selectedTime.hour, minute: minute * 5));
                },
                type: 'minute',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimePicker extends StatelessWidget {
  final List<int> items;
  final int initialItem;
  final Function(int) onChanged;
  final String type;

  const _TimePicker({
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
        itemExtent: 25.h,
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
    double fontSize = 20.sp;
    Color textColor = Colors.black;

    if (distanceFromCenter == 0) {
      // 중앙 항목
      scale = 1.0;
      textColor = Colors.black;
      fontSize = 20.sp;
    } else if (distanceFromCenter == 1) {
      // 중앙에서 한 칸 떨어진 항목
      textColor = const Color(0xFF8D8D8D);
      fontSize = 18.sp;
    } else {
      // 중앙에서 두 칸 떨어진 항목
      textColor = const Color(0xFFDFDFDF);
      fontSize = 16.sp;
    }

    return Align(
      alignment: Alignment.center,
      child: Transform.scale(
        scale: scale,
        child: Text(
          items[index].toString().padLeft(2, '0'), // 두 자리 수로 표시
          maxLines: 1,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontFamily: 'Pretendard-M',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
