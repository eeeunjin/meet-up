import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/province_district_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/next_button.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/profile/profile_view_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    // user의 정보를 user view model에서 profile view model에 전달
    // 변경 사항에 따라 listen 하도록 설정
    // 변경 사항이 있을 시, rebuild
    final _ = Provider.of<ProfileViewModel>(context);

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
          Expanded(child: _main(context)),
        ],
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '프로필'),
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
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        profileViewModel.resetProfileInfo();
        context.pop();
      },
      child: Image.asset(
        ImagePath.back,
        width: 10.w,
        height: 20.h,
      ),
    );
  }

  Widget _main(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          _profileImage(context),
          SizedBox(height: 32.h),
          _nickname(context),
          SizedBox(height: 32.h),
          _gender(context),
          SizedBox(height: 32.h),
          _age(context),
          SizedBox(height: 32.h),
          _address(context),
          SizedBox(height: 32.h),
          _classification(context),
          SizedBox(height: 32.h),
          _personalitySelf(context),
          SizedBox(height: 32.h),
          _interests(context),
          SizedBox(height: 32.h),
          _meetingPurpose(context),
          SizedBox(height: 42.h),
          _saveButton(context),
        ],
      ),
    );
  }

  //MARK: - 프로필 사진
  Widget _profileImage(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    return Center(
      child: GestureDetector(
        onTap: () {
          showProfileEditDialog(context, profileViewModel);
        },
        child: Stack(
          children: [
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1.5.w, color: UsedColor.b_line),
              ),
              child: Image.asset(profileViewModel.selectedIconPath),
            ),
            //MARK: - 프로필 수정 버튼
            Positioned(
              bottom: 0,
              right: 2.w,
              child: Image.asset(
                ImagePath.profileImageEditIcon,
                width: 32.w,
                height: 32.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - 닉네임
  Widget _nickname(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '닉네임',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: profileViewModel.nickNameController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8.h),
              isDense: true,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: UsedColor.line, width: 0.5.h),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: UsedColor.line, width: 0.5.h),
              ),
            ),
            style:
                AppTextStyles.PR_R_16.copyWith(color: UsedColor.charcoal_black),
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  //MARK: - 성별
  Widget _gender(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '성별',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 16.h),
          Text(
            userViewModel.userModel?.gender == 'male' ? '남성' : '여성',
            style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.line,
          )
        ],
      ),
    );
  }

  // MARK: - 나이
  Widget _age(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    // 나이 계산
    final DateTime? birthDate = userViewModel.userModel?.birthday;

    int calculateAge(DateTime? birthDate) {
      if (birthDate == null) {
        return 0;
      }
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    }

    final int age = calculateAge(birthDate) + 2;

    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나이',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 16.h),
          Text(
            // TODO : 나이 변경 로직 으로 나이 계산해서 표시하기
            '$age',
            style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.line,
          )
        ],
      ),
    );
  }

  // MARK: - 거주지
  Widget _address(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: true);
    final String displayText =
        '${profileViewModel.selectedProvince} ${profileViewModel.selectedDistrict}';

    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '거주지',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {
              showAddressEditDialog(context, profileViewModel);
            },
            child: SizedBox(
              width: 328.w,
              child: Text(
                displayText,
                style: AppTextStyles.PR_R_16
                    .copyWith(color: UsedColor.charcoal_black),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

//MARK: - 소속 분류
  Widget _classification(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    String translationJob(String job) {
      switch (job) {
        case 'student':
          return '대학생';
        case 'freelancer':
          return '프리랜서';
        case 'unemployed':
          return '무직';
        case 'employee':
          return '직장인';
        default:
          return '알 수 없음';
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: GestureDetector(
        onTap: () {
          // 소속 분류 선택 창
          showClassificationEditDialog(context, profileViewModel);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '소속 분류',
              style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: 328.w,
              child: Text(
                translationJob(profileViewModel.selectedAffiliation!),
                style: AppTextStyles.PR_R_16
                    .copyWith(color: UsedColor.charcoal_black),
              ),
            ),
            SizedBox(height: 8.h),
            Divider(
              thickness: 0.5.h,
              height: 0.h,
              color: UsedColor.line,
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - 성격
  Widget _personalitySelf(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    final List<dynamic> personalityListDynamic =
        profileViewModel.selectedPersonalities;
    final List<String> personalityList = personalityListDynamic.cast<String>();

    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '성격',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              showPersonalityEditDialog(context, profileViewModel);
            },
            child: SizedBox(
              width: 328.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: personalityList.map((personality) {
                  return Padding(
                    padding: EdgeInsets.only(left: 8.0.w),
                    child: Container(
                      width: 80.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: UsedColor.image_card,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          personality,
                          style: AppTextStyles.PR_R_12
                              .copyWith(color: UsedColor.charcoal_black),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  // MARK: - 관심사
  Widget _interests(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    final List<dynamic> interestListDynamic =
        profileViewModel.selectedInterests;
    final List<String> interestList = interestListDynamic.cast<String>();

    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '관심사',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              showInterestsEditDialog(context, profileViewModel);
            },
            child: SizedBox(
              width: 328.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: interestList.map((personality) {
                  return Padding(
                    padding: EdgeInsets.only(left: 8.0.w),
                    child: Container(
                      width: 80.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: UsedColor.image_card,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          personality,
                          style: AppTextStyles.PR_R_12
                              .copyWith(color: UsedColor.charcoal_black),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

//MARK: - 만남 목적
  Widget _meetingPurpose(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    final List<dynamic> purposeListDynamic =
        profileViewModel.selectedMeetingPurposes;
    final List<String> purposeList = purposeListDynamic.cast<String>();

    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '만남 목적',
            style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              showMeetingPurposeEditDialog(context, profileViewModel);
            },
            child: SizedBox(
              width: 328.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: purposeList.map((personality) {
                  return Padding(
                    padding: EdgeInsets.only(left: 8.0.w),
                    child: Container(
                      width: 80.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: UsedColor.image_card,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          personality,
                          style: AppTextStyles.PR_R_12
                              .copyWith(color: UsedColor.charcoal_black),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

//MARK: - 저장 버튼
  Widget _saveButton(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(bottom: 56.0.h, left: 33.w, right: 32.w),
      child: NextButton(
        onTap: () async {
          logger.d('프로필 변경 저장 버튼 클릭');
          final updatedUserModel = await profileViewModel.updateProfileInfo(
            userViewModel.uid!,
            userViewModel.userModel!,
          );

          if (updatedUserModel != null) {
            logger.d('updatedUserModel: ${updatedUserModel.toJson()}');
            context.pop();
          } else {
            logger.e('변경된 사항이 없습니다.');
          }
        },
        height: 56.h,
        text: '저장',
      ),
    );
  }

//MARK: - 프로필 수정 오버레이
  void showProfileEditDialog(
      BuildContext context, ProfileViewModel profileViewModel) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.5), // 외부 색상
        transitionDuration:
            const Duration(milliseconds: 200), // 사라질 때 애니메이션 지속 시간
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: ChangeNotifierProvider.value(
              value: profileViewModel,
              child: Consumer<ProfileViewModel>(
                  builder: (context, profileViewModel, child) {
                return Container(
                  width: 328.w,
                  height: 312.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0.r),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 24..h, left: 28.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '변경할 프로필을 선택해주세요.',
                              style: AppTextStyles.PR_SB_16.copyWith(
                                  color: UsedColor.charcoal_black,
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(height: 32.h),
                            Padding(
                              padding: EdgeInsets.only(left: 16.w),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        profileViewModel.setChangedIconPath(
                                            ImagePath.cogySelect),
                                    child: Container(
                                      width: 72.w,
                                      height: 72.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            profileViewModel.changedIconPath ==
                                                    ImagePath.cogySelect
                                                ? Border.all(
                                                    color: UsedColor.b_line,
                                                    width: 2.5.w)
                                                : null,
                                      ),
                                      child: Image.asset(
                                          profileViewModel.changedIconPath ==
                                                  ImagePath.cogySelect
                                              ? ImagePath.cogySelect
                                              : ImagePath.cogyDeselect),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  GestureDetector(
                                    onTap: () =>
                                        profileViewModel.setChangedIconPath(
                                            ImagePath.piggySelect),
                                    child: Container(
                                      width: 72.w,
                                      height: 72.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            profileViewModel.changedIconPath ==
                                                    ImagePath.piggySelect
                                                ? Border.all(
                                                    color: UsedColor.b_line,
                                                    width: 2.5.w)
                                                : null,
                                      ),
                                      child: Image.asset(
                                        profileViewModel.changedIconPath ==
                                                ImagePath.piggySelect
                                            ? ImagePath.piggySelect
                                            : ImagePath.piggyDeselect,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  GestureDetector(
                                    onTap: () =>
                                        profileViewModel.setChangedIconPath(
                                            ImagePath.aengmuSelect),
                                    child: Container(
                                      width: 72.w,
                                      height: 72.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            profileViewModel.changedIconPath ==
                                                    ImagePath.aengmuSelect
                                                ? Border.all(
                                                    color: UsedColor.b_line,
                                                    width: 2.5.w)
                                                : null,
                                      ),
                                      child: Image.asset(
                                        profileViewModel.changedIconPath ==
                                                ImagePath.aengmuSelect
                                            ? ImagePath.aengmuSelect
                                            : ImagePath.aengmuDeselect,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Padding(
                              padding: EdgeInsets.only(left: 59.0.w),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        profileViewModel.setChangedIconPath(
                                            ImagePath.hamSelect),
                                    child: Container(
                                      width: 72.w,
                                      height: 72.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            profileViewModel.changedIconPath ==
                                                    ImagePath.hamSelect
                                                ? Border.all(
                                                    color: UsedColor.b_line,
                                                    width: 2.5.w)
                                                : null,
                                      ),
                                      child: Image.asset(
                                        profileViewModel.changedIconPath ==
                                                ImagePath.hamSelect
                                            ? ImagePath.hamSelect
                                            : ImagePath.hamDeselect,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  GestureDetector(
                                    onTap: () =>
                                        profileViewModel.setChangedIconPath(
                                            ImagePath.fedroSelect),
                                    child: Container(
                                      width: 72.w,
                                      height: 72.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            profileViewModel.changedIconPath ==
                                                    ImagePath.fedroSelect
                                                ? Border.all(
                                                    color: UsedColor.b_line,
                                                    width: 2.5.w)
                                                : null,
                                      ),
                                      child: Image.asset(
                                        profileViewModel.changedIconPath ==
                                                ImagePath.fedroSelect
                                            ? ImagePath.fedroSelect
                                            : ImagePath.fedroDeselect,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 27.h),
                          ],
                        ),
                      ),
                      Container(
                        width: 328.w,
                        height: 0.3.h,
                        color: UsedColor.b_line,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 53.h,
                              child: TextButton(
                                // !: -잉크 효과 이상해서 없애둠
                                style: const ButtonStyle(
                                    overlayColor: MaterialStatePropertyAll(
                                        Colors.transparent)),
                                onPressed: () {
                                  profileViewModel.setChangedIconPath('');
                                  context.pop();
                                },
                                child: Text(
                                  '취소',
                                  style: AppTextStyles.PR_M_14.copyWith(
                                      color: UsedColor.charcoal_black),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 53.h,
                            width: 0.3.w,
                            color: UsedColor.b_line,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 53.h,
                              child: TextButton(
                                style: const ButtonStyle(
                                    overlayColor: MaterialStatePropertyAll(
                                        Colors.transparent)),
                                onPressed: () async {
                                  // 저장 로직
                                  if (profileViewModel.changedIconPath != '') {
                                    profileViewModel.setSelectedIconPath(
                                        profileViewModel.changedIconPath);
                                    profileViewModel.setChangedIconPath('');
                                    context.pop();
                                  } else {
                                    logger.e("항목을 선택하세요 !!");
                                  }
                                },
                                child: Text(
                                  '저장',
                                  style: AppTextStyles.PR_M_14.copyWith(
                                      color: UsedColor.charcoal_black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }

//MARK: - 소속 수정 오버레이
  void showClassificationEditDialog(
      BuildContext context, ProfileViewModel profileViewModel) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.5), // 외부 색상
        transitionDuration:
            const Duration(milliseconds: 200), // 사라질 때 애니메이션 지속 시간
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: ChangeNotifierProvider.value(
              value: profileViewModel,
              child: Consumer<ProfileViewModel>(
                  builder: (context, viewModel, child) {
                return Container(
                  width: 328.w,
                  height: 312.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 24..h, left: 28.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '소속을 선택해주세요.',
                              style: AppTextStyles.PR_SB_16.copyWith(
                                  color: UsedColor.charcoal_black,
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              '본인의 소속을 1개 선택해주세요.',
                              style: AppTextStyles.SU_R_12.copyWith(
                                  color: UsedColor.text_3,
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(height: 26.h),
                            // TODO : 소속 선택 컨테이너 박스
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 12.h,
                              children: [
                                _buildAffiliationOption(viewModel, '대학생'),
                                _buildAffiliationOption(viewModel, '직장인'),
                                _buildAffiliationOption(viewModel, '프리랜서'),
                                _buildAffiliationOption(viewModel, '무직'),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 328.w,
                        height: 0.3.h,
                        color: UsedColor.b_line,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 53.h,
                              child: TextButton(
                                // 잉크 효과 이상해서 없애둠
                                style: const ButtonStyle(
                                    overlayColor: MaterialStatePropertyAll(
                                        Colors.transparent)),
                                onPressed: () {
                                  profileViewModel.setChangedAffiliation('');
                                  context.pop();
                                },
                                child: Text(
                                  '취소',
                                  style: AppTextStyles.PR_M_14.copyWith(
                                      color: UsedColor.charcoal_black),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 53.h,
                            width: 0.3.w,
                            color: UsedColor.b_line,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 53.h,
                              child: TextButton(
                                style: const ButtonStyle(
                                    overlayColor: MaterialStatePropertyAll(
                                        Colors.transparent)),
                                onPressed: () async {
                                  // 저장 로직
                                  if (profileViewModel.changedAffiliation !=
                                      null) {
                                    profileViewModel.selectAffiliation(
                                        profileViewModel.changedAffiliation!);
                                    profileViewModel.setChangedAffiliation('');
                                    context.pop();
                                  } else {
                                    logger.e('항목을 선택하세요 !!');
                                  }
                                },
                                child: Text(
                                  '저장',
                                  style: AppTextStyles.PR_M_14.copyWith(
                                      color: UsedColor.charcoal_black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }

// MARK: - 소속 선택 컨테이너
  Widget _buildAffiliationOption(
      ProfileViewModel viewModel, String affiliation) {
    String changedAffiliation = '';
    switch (viewModel.changedAffiliation) {
      case 'student':
        changedAffiliation = '대학생';
        break;
      case 'employee':
        changedAffiliation = '직장인';
        break;
      case 'freelancer':
        changedAffiliation = '프리랜서';
        break;
      case 'unemployed':
        changedAffiliation = '무직';
        break;
    }
    bool isSelected = changedAffiliation == affiliation;
    logger.d(
        "[test] changedAffiliation: $changedAffiliation // affiliation: $affiliation");
    return GestureDetector(
      onTap: () => viewModel.setChangedAffiliation(affiliation),
      child: Container(
        width: 80.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: isSelected ? UsedColor.button : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
              width: 1.5.w,
              color: isSelected ? UsedColor.button : UsedColor.b_line),
        ),
        child: Center(
          child: Text(
            affiliation,
            style: AppTextStyles.PR_M_12.copyWith(
                color: isSelected ? Colors.white : UsedColor.charcoal_black,
                decoration: TextDecoration.none),
          ),
        ),
      ),
    );
  }

//MARK: - 주소 수정 오버레이
  void showAddressEditDialog(
      BuildContext context, ProfileViewModel profileViewModel) {
    String? temporarySelectedProvince = profileViewModel.selectedProvince;
    String? temporarySelectedDistrict = profileViewModel.selectedDistrict;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            width: 328.w,
            height: 256.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 24.h, left: 28.w, right: 28.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '거주지를 선택해주세요.',
                        style: AppTextStyles.PR_SB_16.copyWith(
                          color: UsedColor.charcoal_black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      ProvinceDistrictPicker(
                        onProvinceChanged: (String province) {
                          temporarySelectedProvince = province;
                        },
                        onDistrictChanged: (String district) {
                          temporarySelectedDistrict = district;
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: 328.w,
                  height: 0.3.h,
                  color: UsedColor.b_line,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54.h,
                        child: TextButton(
                          style: const ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll(Colors.transparent),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '취소',
                            style: AppTextStyles.PR_R_16
                                .copyWith(color: UsedColor.charcoal_black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 54.h,
                      width: 0.3.w,
                      color: UsedColor.b_line,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 54.h,
                        child: TextButton(
                          style: const ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll(Colors.transparent),
                          ),
                          onPressed: () async {
                            profileViewModel
                                .selectProvince(temporarySelectedProvince!);
                            profileViewModel
                                .selectDistrict(temporarySelectedDistrict!);
                            Navigator.pop(context);
                          },
                          child: Text(
                            '확인',
                            style: AppTextStyles.PR_R_16
                                .copyWith(color: UsedColor.charcoal_black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // MARK: - 성격 수정 오버레이
  void showPersonalityEditDialog(
      BuildContext context, ProfileViewModel profileViewModel) {
    List<String> options = [
      "사교적인",
      "내향적인",
      "유머러스한",
      "조용한",
      "친절한",
      "열정적인",
      "활발한",
      "책임감 있는",
      "신중한",
      "독립적인",
      "낙천적인",
      "호기심 많은"
    ];
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5), // 외부 색상
      transitionDuration:
          const Duration(milliseconds: 200), // 사라질 때 애니메이션 지속 시간
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: ChangeNotifierProvider.value(
            value: profileViewModel,
            child: Consumer<ProfileViewModel>(
                builder: (context, viewModel, child) {
              return Container(
                width: 328.w,
                height: 312.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 24..h, left: 28.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '성격을 선택해주세요.',
                            style: AppTextStyles.PR_SB_16.copyWith(
                                color: UsedColor.charcoal_black,
                                decoration: TextDecoration.none),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            '나를 가장 잘 표현하는 키워드 3가지를 선택해주세요.',
                            style: AppTextStyles.SU_R_12.copyWith(
                                color: UsedColor.text_3,
                                decoration: TextDecoration.none),
                          ),
                          SizedBox(height: 26.h),
                          // 성격 컨테이너들
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: options.map((option) {
                              bool isSelected = viewModel.changedPersonalites
                                  .contains(option);
                              return GestureDetector(
                                onTap: () {
                                  profileViewModel
                                      .toggleChangedPersonality(option);
                                },
                                child: Container(
                                  width: 80.w,
                                  height: 24.h,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? UsedColor.button
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? UsedColor.button
                                          : UsedColor.b_line,
                                      width: 1.5.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      option,
                                      style: AppTextStyles.PR_M_12.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          decoration: TextDecoration.none),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 328.w,
                      height: 0.3.h,
                      color: UsedColor.b_line,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 53.h,
                            child: TextButton(
                              // !: -잉크 효과 이상해서 없애둠
                              style: const ButtonStyle(
                                  overlayColor: MaterialStatePropertyAll(
                                      Colors.transparent)),
                              onPressed: () {
                                profileViewModel.clearChangedPersonalities();
                                context.pop();
                              },
                              child: Text(
                                '취소',
                                style: AppTextStyles.PR_M_14
                                    .copyWith(color: UsedColor.charcoal_black),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 53.h,
                          width: 0.3.w,
                          color: UsedColor.b_line,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 53.h,
                            child: TextButton(
                              style: const ButtonStyle(
                                  overlayColor: MaterialStatePropertyAll(
                                      Colors.transparent)),
                              onPressed: () async {
                                // 저장 로직
                                if (profileViewModel
                                        .changedPersonalites.length ==
                                    3) {
                                  profileViewModel.setPersonality(
                                      profileViewModel.changedPersonalites);
                                  profileViewModel.clearChangedPersonalities();
                                  context.pop();
                                } else {
                                  logger.e("항목을 선택해주세요 !!");
                                }
                              },
                              child: Text(
                                '저장',
                                style: AppTextStyles.PR_M_14
                                    .copyWith(color: UsedColor.charcoal_black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

//MARK: - 관심사 수정 오버레이
  void showInterestsEditDialog(
      BuildContext context, ProfileViewModel profileViewModel) {
    List<String> options = [
      "운동",
      "음악",
      "영화",
      "독서",
      "대학",
      "취업",
      "친구",
      "맛집",
      "여행",
      "주식",
      "게임",
      "연예인"
    ];
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.5), // 외부 색상
        transitionDuration:
            const Duration(milliseconds: 200), // 사라질 때 애니메이션 지속 시간
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: ChangeNotifierProvider.value(
              value: profileViewModel,
              child: Consumer<ProfileViewModel>(
                  builder: (context, viewModel, child) {
                return Container(
                  width: 328.w,
                  height: 312.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 24..h, left: 28.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '관심사를 선택해주세요.',
                              style: AppTextStyles.PR_SB_16.copyWith(
                                  color: UsedColor.charcoal_black,
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              '가장 관심있는 분야 3가지를 선택해주세요.',
                              style: AppTextStyles.SU_R_12.copyWith(
                                  color: UsedColor.text_3,
                                  decoration: TextDecoration.none),
                            ),
                            SizedBox(height: 26.h),
                            // 관심사 컨테이너들
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 12.h,
                              children: options.map((option) {
                                bool isSelected =
                                    viewModel.changedInterests.contains(option);
                                return GestureDetector(
                                  onTap: () {
                                    viewModel.toggleChangedInterest(option);
                                  },
                                  child: Container(
                                    width: 80.w,
                                    height: 24.h,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? UsedColor.button
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? UsedColor.button
                                            : UsedColor.b_line,
                                        width: 1.5.w,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        option,
                                        style: AppTextStyles.PR_M_12.copyWith(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 328.w,
                        height: 0.3.h,
                        color: UsedColor.b_line,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 53.h,
                              child: TextButton(
                                // !: -잉크 효과 이상해서 없애둠
                                style: const ButtonStyle(
                                    overlayColor: MaterialStatePropertyAll(
                                        Colors.transparent)),
                                onPressed: () {
                                  profileViewModel.clearChangedInterests();
                                  context.pop();
                                },
                                child: Text(
                                  '취소',
                                  style: AppTextStyles.PR_M_14.copyWith(
                                      color: UsedColor.charcoal_black),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 53.h,
                            width: 0.3.w,
                            color: UsedColor.b_line,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 53.h,
                              child: TextButton(
                                style: const ButtonStyle(
                                    overlayColor: MaterialStatePropertyAll(
                                        Colors.transparent)),
                                onPressed: () async {
                                  // 저장 로직
                                  if (profileViewModel
                                          .changedInterests.length ==
                                      3) {
                                    profileViewModel.setInterest(
                                        profileViewModel.changedInterests);
                                    profileViewModel.clearChangedInterests();
                                    context.pop();
                                  } else {
                                    logger.e("항목을 선택해주세요 !!");
                                  }
                                },
                                child: Text(
                                  '저장',
                                  style: AppTextStyles.PR_M_14.copyWith(
                                      color: UsedColor.charcoal_black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }

//MARK: - 만남 목적 수정 오버레이
  void showMeetingPurposeEditDialog(
      BuildContext context, ProfileViewModel profileViewModel) {
    List<String> options = [
      "친목",
      "자기성찰",
      "기록",
      "취미 공유",
      "자기계발",
      "새로운 경험",
      "독서 모임",
      "여럿이 운동",
      "취업 스터디",
      "맛집 탐방",
      "기타",
    ];
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5), // 외부 색상
      transitionDuration:
          const Duration(milliseconds: 200), // 사라질 때 애니메이션 지속 시간
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: ChangeNotifierProvider.value(
            value: profileViewModel,
            child: Consumer<ProfileViewModel>(
                builder: (context, viewModel, child) {
              return Container(
                width: 328.w,
                height: 312.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 24..h, left: 28.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '만남 목적을 선택해주세요.',
                            style: AppTextStyles.PR_SB_16.copyWith(
                                color: UsedColor.charcoal_black,
                                decoration: TextDecoration.none),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            '만남을 가지는 목적을 1~3개 선택해주세요.',
                            style: AppTextStyles.SU_R_12.copyWith(
                                color: UsedColor.text_3,
                                decoration: TextDecoration.none),
                          ),
                          SizedBox(height: 26.h),
                          // 관심사 컨테이너들
                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: options.map((option) {
                              bool isSelected = viewModel.changedMeetingPurposes
                                  .contains(option);
                              return GestureDetector(
                                onTap: () {
                                  viewModel
                                      .toggleChangedMeetingPurposes(option);
                                },
                                child: Container(
                                  width: 80.w,
                                  height: 24.h,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? UsedColor.button
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? UsedColor.button
                                          : UsedColor.b_line,
                                      // color: UsedColor.b_line,
                                      width: 1.5.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      option,
                                      style: AppTextStyles.PR_M_12.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          decoration: TextDecoration.none),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 328.w,
                      height: 0.3.h,
                      color: UsedColor.b_line,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 53.h,
                            child: TextButton(
                              // !: -잉크 효과 이상해서 없애둠
                              style: const ButtonStyle(
                                  overlayColor: MaterialStatePropertyAll(
                                      Colors.transparent)),
                              onPressed: () {
                                profileViewModel.clearChangedMeetingPurposes();
                                context.pop();
                              },
                              child: Text(
                                '취소',
                                style: AppTextStyles.PR_M_14
                                    .copyWith(color: UsedColor.charcoal_black),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 53.h,
                          width: 0.3.w,
                          color: UsedColor.b_line,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 53.h,
                            child: TextButton(
                              style: const ButtonStyle(
                                  overlayColor: MaterialStatePropertyAll(
                                      Colors.transparent)),
                              onPressed: () async {
                                // 저장 로직
                                if (profileViewModel
                                        .changedMeetingPurposes.isNotEmpty &&
                                    profileViewModel
                                            .changedMeetingPurposes.length <=
                                        3) {
                                  profileViewModel.setMeetingPurpose(
                                      profileViewModel.changedMeetingPurposes);
                                  profileViewModel
                                      .clearChangedMeetingPurposes();
                                  context.pop();
                                } else {
                                  logger.e("항목을 선택해주세요 !!");
                                }
                              },
                              child: Text(
                                '저장',
                                style: AppTextStyles.PR_M_14
                                    .copyWith(color: UsedColor.charcoal_black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

//MARK: - 거주지 위젯
class ProvinceDistrictPicker extends StatelessWidget {
  final Function(String) onProvinceChanged;
  final Function(String) onDistrictChanged;

  const ProvinceDistrictPicker({
    super.key,
    required this.onProvinceChanged,
    required this.onDistrictChanged,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpDetailViewModel>(context);
    final items = ProvinceDistrict.districts.keys.toList();
    return Stack(
      children: [
        SizedBox(
          width: 274.w,
          height: 89.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 89.h,
                child: ListWheelScrollView(
                  itemExtent: 30.h,
                  physics: const FixedExtentScrollPhysics(),
                  controller: viewModel.provinceScrollController,
                  children: items.map((String province) {
                    final isSelectedProvince =
                        (province == viewModel.selectedProvince);

                    return _buildItem(province, isSelectedProvince,
                        viewModel.selectedProvinceIndex, items);
                  }).toList(),
                  onSelectedItemChanged: (int index) {
                    String selectedProvince =
                        ProvinceDistrict.districts.keys.elementAt(index);
                    onProvinceChanged(selectedProvince);
                    viewModel.selectProvince(selectedProvince);
                    String firstDistrict = ProvinceDistrict
                        .districts[viewModel.selectedProvince]![0];
                    onDistrictChanged(firstDistrict);
                    viewModel.selectDistrict(firstDistrict);
                    viewModel.districtScrollController.jumpTo(0);
                  },
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 89.h,
                child: ListWheelScrollView(
                  itemExtent: 30.h,
                  physics: const FixedExtentScrollPhysics(),
                  controller: viewModel.districtScrollController,
                  children:
                      (ProvinceDistrict.districts[viewModel.selectedProvince] ??
                              [])
                          .map((String district) {
                    final isSelectedDistrict =
                        (district == viewModel.selectedDistrict);
                    return _buildItem(
                        district,
                        isSelectedDistrict,
                        viewModel.selectedDistrictIndex,
                        ProvinceDistrict
                            .districts[viewModel.selectedProvince]!);
                  }).toList(),
                  onSelectedItemChanged: (int index) {
                    String selectedDistrict = ProvinceDistrict
                        .districts[viewModel.selectedProvince]![index];
                    onDistrictChanged(selectedDistrict);
                    viewModel.selectDistrict(selectedDistrict);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItem(
      String text, bool isSelected, int selectedIndex, List<String> items) {
    int distanceFromSelected = (selectedIndex - items.indexOf(text)).abs();

    double scale;
    Color textColor;

    if (distanceFromSelected == 0) {
      scale = 1.0;
      textColor = Colors.black;
    } else if (distanceFromSelected == 1) {
      scale = 0.97;
      textColor = const Color(0xFF8D8D8D);
    } else {
      scale = 0.94;
      textColor = const Color(0xFFDFDFDF);
    }

    return Center(
      child: Transform.scale(
        scale: scale,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24.sp,
            color: textColor,
            fontFamily: 'Pretendard-M',
            decoration: TextDecoration.none,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
