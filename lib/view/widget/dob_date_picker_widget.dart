import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DOBDatePicker extends StatelessWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const DOBDatePicker({
    Key? key,
    required this.initialDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double itemExtent = 50.0;

    Widget overlay = Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white, width: 2),
          bottom: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      child: Center(
        child: Container(
          height: itemExtent,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.8),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.05, 0.5, 0.95],
            ),
          ),
        ),
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: initialDate,
          onDateTimeChanged: onDateChanged,
          use24hFormat: true,
          itemExtent: itemExtent,
          backgroundColor: Colors.transparent,
        ),
        overlay,
      ],
    );
  }
}
