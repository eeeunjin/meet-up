import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/schedule/schedule_main_view_model.dart';
import 'package:provider/provider.dart';

class AddMemberPersonal extends StatelessWidget {
  const AddMemberPersonal({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScheduleMainViewModel>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 58.h,
            ),
            child: _header(context),
          ),
          SizedBox(height: 63.h),
          _main(context, viewModel),
          const Spacer(),
          // _bottom(context),
        ],
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '참여자 입력'),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            thickness: 0.3.h,
            height: 0.h,
            color: UsedColor.line,
          )
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 정보 초기화
        final viewModel =
            Provider.of<ScheduleMainViewModel>(context, listen: false);
        // viewModel.keywordClearSelection();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  Widget _main(BuildContext context, ScheduleMainViewModel viewModel) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            // '#' 텍스트
            Text(
              '#',
              style: AppTextStyles.PR_SB_22.copyWith(color: UsedColor.button),
            )
          ],
        )
      ],
    );
  }
}
