import 'package:flutter/material.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';

class NotificationToggle extends StatelessWidget {
  final String text;
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  const NotificationToggle(
      {super.key,
      required this.text,
      required this.initialValue,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_3),
        ),
        const Spacer(),
        // 토글 스위치
        Switch(
          value: initialValue,
          onChanged: onChanged,
          // 디자인
        ),
      ],
    );
  }
}
