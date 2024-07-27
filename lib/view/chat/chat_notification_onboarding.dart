import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:provider/provider.dart';

class ChatNotification extends StatelessWidget {
  const ChatNotification({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatViewModel(
        init: DateTime.now(),
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
      ),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 58.h,
              ),
              child: _header(context),
            ),
            Expanded(
              child: PageView(
                children: [
                  _page1(context),
                  _page2(context),
                  _page3(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '채팅 시 주의 사항'),
          SizedBox(
            height: 18.h,
          ),
          Divider(
            thickness: 0.3.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  Widget _page1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 21.w,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 51.h),
            WarningSection(
              title: '이탈 (일정 확정 전)',
              iconPath: ImagePath.chatNotification1,
              items: const ['하나의 만남권당 최대 3번까지 이탈 가능', '이후 이탈 만남권 소진'],
            ),
            SizedBox(
              height: 48.h,
            ),
            WarningSection(
              title: '이탈 (일정 확정 후)',
              iconPath: ImagePath.chatNotification2,
              items: const ['만남권 소진'],
            ),
            SizedBox(
              height: 40.h,
            ),
            WarningSection(
              title: '이탈 (일정 확정 후 당일 이탈)',
              iconPath: ImagePath.chatNotification3,
              items: const ['1회: 일주일 정지', '2회: 한 달 정지', '3회: 영구 정지 처리'],
            ),
            SizedBox(
              height: 40.h,
            ),
            WarningSection(
              title: '개인정보 유출 및 공유',
              iconPath: ImagePath.chatNotification4,
              items: const [
                '만남 이전, 연락처를 공유하거나 요구하는 경우',
                '다른 사람의 개인정보를 유출하는 경우'
              ],
            ),
            SizedBox(height: 132.h),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: UsedColor.button_g,
                  borderRadius: BorderRadius.circular(12.5.r),
                ),
                child: Text(
                  '최초 신고자 50coin 지급',
                  style:
                      AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_1),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIndicator(true),
                  _buildIndicator(false),
                  _buildIndicator(false),
                ],
              ),
            ),
            SizedBox(height: 86.h),
          ],
        ),
      ),
    );
  }

  Widget _page2(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 21.w,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 51.h),
            WarningSection(
              title: '특정 단체 관련 포교 행위',
              iconPath: ImagePath.chatNotification5,
              items: const ['종교나 특정 단체에 대한 포교 행위'],
            ),
            SizedBox(
              height: 40.h,
            ),
            WarningSection(
              title: '욕설, 비방, 폭력, 혐오 표현',
              iconPath: ImagePath.chatNotification6,
              items: const ['채팅 중에 욕설, 비방, 폭력, 혐오를 표현하는 경우'],
            ),
            SizedBox(
              height: 40.h,
            ),
            WarningSection(
              title: '불법 행위',
              iconPath: ImagePath.chatNotification7,
              items: const ['도박, 사기, 규제 상품 판매 등 불법적인 행위를 하는 경우'],
            ),
            SizedBox(
              height: 40.h,
            ),
            WarningSection(
              title: '허위 신고',
              iconPath: ImagePath.chatNotification8,
              items: const ['1회: 일주일 정지', '2회: 한 달 정지', '3회: 영구 정지 처리'],
            ),
            SizedBox(
              height: 124.h,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: UsedColor.button_g,
                  borderRadius: BorderRadius.circular(12.5.r),
                ),
                child: Text(
                  '최초 신고자 50coin 지급',
                  style:
                      AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_1),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIndicator(false),
                  _buildIndicator(true),
                  _buildIndicator(false),
                ],
              ),
            ),
            SizedBox(
              height: 86.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _page3(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 21.w,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 51.h),
            WarningSection(
              title: '노골적인 성적 표현',
              iconPath: ImagePath.chatNotification9,
              items: const ['성매매 유도나 성적 발언을 하는 참여자가 있을 경우'],
            ),
            SizedBox(
              height: 40.h,
            ),
            WarningSection(
              title: '장시간 채팅 불참',
              iconPath: ImagePath.chatNotification10,
              items: const ['12시간 이상 채팅에 참여하지 않는 경우'],
            ),
            SizedBox(height: 142.h),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  Color color;
                  if (index == 0) {
                    color = UsedColor.b_line;
                  } else if (index == 1) {
                    color = UsedColor.main;
                  } else {
                    color = UsedColor.violet;
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 189.h),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: UsedColor.main,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 108.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  '채팅 참여하기',
                  style: AppTextStyles.PR_SB_20.copyWith(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 56.h),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 38.w,
            right: 31.w,
            top: 72.h,
            bottom: 56.h,
          ),
          child: Consumer<ChatViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '채팅방 입장 전\n주의 사항을 확인해주세요!',
                    style: AppTextStyles.PR_SB_22.copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 35.67.h),
                  Row(
                    children: [
                      Icon(
                        viewModel.isChecked
                            ? Icons.check_circle
                            : Icons.check_circle,
                        color: viewModel.isChecked
                            ? UsedColor.violet
                            : UsedColor.text_5,
                      ),
                      SizedBox(width: 17.67.w),
                      Expanded(
                        child: Text(
                          '채팅 시 주의 사항을 모두 숙지해야 합니다.\n',
                          style: AppTextStyles.PR_R_17.copyWith(
                            color: viewModel.isChecked
                                ? Colors.black
                                : UsedColor.text_5,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          viewModel.toggleChecked();
                        },
                        child: Container(
                          width: 33.w,
                          height: 33.h,
                          decoration: BoxDecoration(
                            color: UsedColor.image_card,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: viewModel.isChecked
                                ? UsedColor.violet
                                : UsedColor.button_g,
                            size: 18.53.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '주의 사항 미숙지로 인한 규칙 위반 행위는\n이용에 제재를 받을 수 있습니다.',
                    style:
                        AppTextStyles.PR_R_17.copyWith(color: UsedColor.text_5),
                  ),
                  SizedBox(height: 57.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: viewModel.isChecked
                          ? () {
                              Navigator.pop(context);
                              // 다음 화면으로 이동하는 코드 추가
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: viewModel.isChecked
                            ? UsedColor.button
                            : UsedColor.button_g,
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 91.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        '동의하고 시작하기',
                        style: AppTextStyles.PR_SB_20
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          color: isActive ? UsedColor.main : UsedColor.b_line,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// WarningSection 위젯 정의
class WarningSection extends StatelessWidget {
  final String title;
  final String iconPath;
  final List<String> items;

  const WarningSection({
    super.key,
    required this.title,
    required this.iconPath,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35.w,
            backgroundColor: UsedColor.image_card,
            child: Image.asset(
              iconPath,
              width: 48.w,
              height: 48.h,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.PR_M_16.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
                SizedBox(height: 8.h),
                ...items.map((item) => Text(
                      '• $item',
                      style: AppTextStyles.PR_R_14.copyWith(
                        color: UsedColor.text_3,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
