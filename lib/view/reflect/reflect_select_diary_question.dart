import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/reflect/reflect_write_diary_view_model.dart';
import 'package:provider/provider.dart';

class ReflectSelectDiaryQuestion extends StatelessWidget {
  const ReflectSelectDiaryQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        final reflectWriteDiaryViewModel =
            Provider.of<ReflectWriteDiaryViewModel>(context, listen: false);
        if (!reflectWriteDiaryViewModel.addQeustion) {
          reflectWriteDiaryViewModel.resetState();
        }
        reflectWriteDiaryViewModel.resetSelectedImages();
        reflectWriteDiaryViewModel.setAddQuestion(false);
        context.pop();
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 58.h,
              ),
              child: _header(context),
            ),
            Expanded(child: _main(context)),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(
            title: '일기 쓰기',
            back: _back(context),
          ),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final reflectWriteDiaryViewModel =
            Provider.of<ReflectWriteDiaryViewModel>(context, listen: false);
        if (!reflectWriteDiaryViewModel.addQeustion) {
          reflectWriteDiaryViewModel.resetState();
        }
        reflectWriteDiaryViewModel.setAddQuestion(false);
        reflectWriteDiaryViewModel.resetSelectedImages();
        context.pop();
      },
      child: Image.asset(
        ImagePath.close,
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  Widget _main(BuildContext context) {
    return Consumer<ReflectWriteDiaryViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 30.h,
              left: 27.w,
              right: 26.w,
              bottom: 56.h,
            ),
            child: Center(
              child: Container(
                width: 340.w,
                // height: 683.h,
                padding: EdgeInsets.only(
                  top: 28.h,
                  bottom: 28.h,
                  right: 24.w,
                  left: 24.w,
                ),
                decoration: BoxDecoration(
                  color: UsedColor.image_card,
                  borderRadius: BorderRadius.circular(29.r),
                ),
                child: Column(
                  children: [
                    Text(
                      '어떤 질문에 일기를 작성하고 싶으신가요?',
                      style: AppTextStyles.PR_SB_16.copyWith(
                        color: UsedColor.text_2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '작성하고 싶은 질문을 자유롭게 선택해 보세요.\n최대 3개의 질문에 대한 일기를 작성하실 수 있습니다.',
                      style: AppTextStyles.PR_M_13.copyWith(
                        color: UsedColor.text_4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 19.h),
                    _selectOptions(viewModel),
                    _bottom(context, viewModel),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//MARK: - 이미지 선택
  Widget _selectOptions(ReflectWriteDiaryViewModel viewModel) {
    final List<String> imagePaths = [
      ImagePath.reflect1,
      ImagePath.reflect2,
      ImagePath.reflect3,
      ImagePath.reflect4,
      ImagePath.reflect5,
    ];

    final List<String> selectedImagePaths = [
      ImagePath.reflect1Selected,
      ImagePath.reflect2Selected,
      ImagePath.reflect3Selected,
      ImagePath.reflect4Selected,
      ImagePath.reflect5Selected,
    ];

    final List<String> completedImagePaths = [
      ImagePath.reflectDone1,
      ImagePath.reflectDone2,
      ImagePath.reflectDone3,
      ImagePath.reflectDone4,
      ImagePath.reflectDone5,
    ];

    return Column(
      children: List.generate(imagePaths.length, (index) {
        return Column(
          children: [
            GestureDetector(
              onTap: viewModel.completedSelection.contains(index)
                  ? null
                  : () => viewModel.toggleSelection(index),
              child: Image.asset(
                viewModel.completedSelection.contains(index)
                    ? completedImagePaths[index]
                    : (viewModel.isSelected(index)
                        ? selectedImagePaths[index]
                        : imagePaths[index]),
                width: 292.w,
                height: 83.h,
              ),
            ),
            SizedBox(height: 16.h),
          ],
        );
      }),
    );
  }

//MARK: - bottom
  Widget _bottom(BuildContext context, ReflectWriteDiaryViewModel viewModel) {
    return GestureDetector(
      onTap: viewModel.selectedImages.isNotEmpty
          ? () {
              viewModel.markAsCompleted();

              if (viewModel.addQeustion) {
                viewModel.setAddQuestion(false);
                viewModel.resetSelectedImages();
                context.pop();
              } else {
                if (viewModel.isFromDiaryMore) {
                  context.goNamed('reflectWriteDiary_diaryMore');
                } else {
                  context.goNamed('reflectWriteDiary');
                }
              }
            }
          : null,
      child: Container(
        width: 292.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: viewModel.selectedImages.isNotEmpty
              ? UsedColor.button
              : UsedColor.button_g,
          borderRadius: BorderRadius.circular(18.5.r),
        ),
        alignment: Alignment.center,
        child: Text(
          '다음',
          style: AppTextStyles.PR_SB_20.copyWith(
            color: viewModel.selectedImages.isNotEmpty
                ? Colors.white
                : UsedColor.text_2,
          ),
        ),
      ),
    );
  }
}
