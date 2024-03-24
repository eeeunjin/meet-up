import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:provider/provider.dart';

class SignUpDetailTwo extends StatelessWidget {
  const SignUpDetailTwo({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SignUpDetailViewModel>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _nickname(context),
        SizedBox(
          height: 55.h,
        ),
        _profile(context),
        SizedBox(
          height: 55.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0.w),
          child: NextButton(
            text: '다음',
            onTap: () {
              final signUpDetailViewModel =
                  Provider.of<SignUpDetailViewModel>(context, listen: false);

              // 닉네임과 프로필 이미지가 입력/선택되었는지 확인
              if (signUpDetailViewModel.isNicknameValid &&
                  signUpDetailViewModel.selectedImagePath != null) {
                // 다음 페이지로 이동
                context.goNamed('signUpDetailThree');
              } else {
                // 닉네임이 올바르게 입력되었는지 확인하고 에러 메시지 표시
                signUpDetailViewModel.validateNickname(
                    signUpDetailViewModel.nicknameController.text);
                // 프로필 이미지 선택 여부 확인하고 에러 메시지 표시
                if (signUpDetailViewModel.selectedImagePath == null) {
                  // 프로필 이미지가 선택되지 않았을 경우 에러 메시지 표시
                  signUpDetailViewModel.setProfileImageError('프로필 이미지를 선택하세요.');
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

Widget _nickname(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 25.0.w,
      right: 25.0.w,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "닉네임을 입력해주세요.",
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.h),
        Text(
          "프로필에 표시되는 이름으로 언제든 변경할 수 있습니다.",
          style: TextStyle(fontSize: 12.sp),
        ),
        SizedBox(height: 20.h),

        // 닉네임 입력 창
        Padding(
          padding: EdgeInsets.only(top: 10.h, right: 1.w),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: 400.w,
                  height: 20.h,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: Consumer<SignUpDetailViewModel>(
                    builder: (context, model, child) {
                      return TextField(
                        //maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        controller: model.nicknameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          model.validateNickname(value);
                        },
                        // maxLength: 12,
                        // 최대 글자 수 강제 여부
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      // 닉네임 입력창의 내용 지우기
                      Provider.of<SignUpDetailViewModel>(context, listen: false)
                          .nicknameController
                          .clear();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 5.h),
        Consumer<SignUpDetailViewModel>(
          builder: (context, model, child) {
            return Row(
              children: [
                model.errorMessage.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Text(
                          model.errorMessage,
                          style: TextStyle(
                            color: model.errorMessage.contains('사용 가능한 닉네임입니다.')
                                ? Colors.green
                                : Colors.red,
                            fontSize: 12.sp,
                          ),
                        ),
                      )
                    : Text(
                        '4~12자의 한글, 영문 대소문자, 숫자만 사용 가능합니다.',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                Expanded(
                  child: Text(
                    '${model.nicknameController.text.length}/12',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    ),
  );
}

Widget _profile(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "프로필을 선택해주세요.",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileImage(context, 'assets/images/image1.jpg'),
            _buildProfileImage(context, 'assets/images/image2.jpg'),
            _buildProfileImage(context, 'assets/images/image3.jpg'),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileImage(context, 'assets/images/image4.jpg'),
            _buildProfileImage(context, 'assets/images/image5.jpg'),
          ],
        ),
      ],
    ),
  );
}

Widget _buildProfileImage(BuildContext context, String imagePath) {
  final imageSelectionProvider = Provider.of<SignUpDetailViewModel>(context);
  final isSelected = imageSelectionProvider.selectedImagePath == imagePath;

  return GestureDetector(
    onTap: () {
      imageSelectionProvider.selectImage(imagePath);
      print('선택된 이미지 경로: $imagePath');
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: Image.asset(
            imagePath,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}
