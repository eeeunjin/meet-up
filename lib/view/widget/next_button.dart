import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextButton extends StatefulWidget {
  final String text;
  final Function() onTap;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool whiteButton;
  final TextStyle? textStyle;
  final bool enable;
  const NextButton(
      {super.key,
      required this.onTap,
      this.text = "",
      this.width,
      this.height,
      this.fontSize,
      this.whiteButton = false,
      this.textStyle,
      this.enable = true,
      Color? backgroundColor});
  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isLoading || !widget.enable) {
          return;
        }

        try {
          dynamic ret = widget.onTap();
          if (ret is Future) {
            setState(() {
              isLoading = true;
            });
            await ret;
          }
        } catch (_) {}

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 40.h,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: widget.whiteButton
              ? Colors.white
              : (widget.enable
                  ? const Color(0xFF76E84E)
                  : const Color(0xFFE6E6E6)),
          shape: RoundedRectangleBorder(
              side: widget.whiteButton
                  ? BorderSide(width: 1.r, color: const Color(0xFFE6E6E6))
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(19.r)),
        ),
        child: Visibility(
          visible: !isLoading,
          replacement: const CircularProgressIndicator(),
          child: Text(
            widget.text,
            style: widget.textStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize ?? 20.sp,
                  fontFamily: 'Pretendard',
                ),
          ),
        ),
      ),
    );
  }
}
