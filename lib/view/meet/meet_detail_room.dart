import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_manage_view_model.dart';
import 'package:meet_up/view_model/meet/meet_detail_room_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class MeetDetailRoom extends StatelessWidget {
  const MeetDetailRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final meetDetailRoomViewModel =
        Provider.of<MeetDetailRoomViewModel>(context);
    final meetManageViewModel = Provider.of<MeetManageViewModel>(context);
    final decodedRoomModel = meetManageViewModel.decodingRoomModel(
      roomModel: meetDetailRoomViewModel.currentRoomModel!,
    );

    logger.d(
        "${decodedRoomModel.room_name}의 room id는 [${decodedRoomModel.roomId}] 입니다 ~");

    String ageString = decodedRoomModel.room_age.join(", "); // 나이 리스트를 문자열로 결합

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
          Expanded(
            child: _main(context, decodedRoomModel, ageString),
          ),
        ],
      ),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(back: _back(context), title: '세부 정보'),
          SizedBox(
            height: 11.h,
          ),
          Divider(
            height: 0.3.h,
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
        width: 40.w,
        height: 40.h,
      ),
    );
  }

  Widget _main(
      BuildContext context, RoomModel decodedRoomModel, String ageString) {
    MeetManageViewModel viewModel = Provider.of<MeetManageViewModel>(context);
    MeetDetailRoomViewModel meetDetailRoomViewModel =
        Provider.of<MeetDetailRoomViewModel>(context, listen: false);
    return Container(
      width: double.infinity,
      height: 131.h,
      color: UsedColor.bg_color,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 30.w, top: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                decodedRoomModel.room_name,
                style: AppTextStyles.PR_SB_22
                    .copyWith(color: UsedColor.charcoal_black),
              ),
              SizedBox(height: 10.h),
              // detail
              Text(
                decodedRoomModel.room_description,
                style: AppTextStyles.PR_R_14.copyWith(color: UsedColor.text_5),
              ),
              SizedBox(height: 21.h),
              // keywords
              Wrap(
                spacing: 7.w,
                children: decodedRoomModel.room_keyword
                    .map<Widget>((keyword) => _keywordContainer(keyword))
                    .toList(),
              ),
              SizedBox(height: 28.h),
              _etcBox(context, decodedRoomModel, ageString),
              SizedBox(height: 16.h),
              // MARK: - 세부규칙
              Container(
                width: 340.w,
                height: 250.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 17.0.h, left: 24.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: UsedColor.main),
                          ),
                          SizedBox(
                            width: 17.w,
                          ),
                          Text(
                            '세부 규칙',
                            style: AppTextStyles.PR_SB_12
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // 세부 규칙 리스트
                      ...List.generate(viewModel.rulesDescriptions.length,
                          (index) {
                        String ruleDescription =
                            viewModel.rulesDescriptions[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 20.0.w, right: 44.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(ruleDescription, // 질문/규칙 설명 표시
                                        style: AppTextStyles.PR_R_12
                                            .copyWith(color: UsedColor.text_5)),
                                  ),
                                  _responseBox(
                                      context,
                                      decodedRoomModel.room_rules[index],
                                      true), // '가능' 버튼
                                  SizedBox(width: 7.12.w),
                                  _responseBox(
                                      context,
                                      decodedRoomModel.room_rules[index],
                                      false), // '불가능' 버튼
                                ],
                              ),
                              Divider(color: UsedColor.line, thickness: 0.3.h),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // MARK: - 참여 중인 인원
              FutureBuilder(
                future: meetDetailRoomViewModel.getParticipantInfo(),
                builder: (context, snapshot) {
                  List<UserModel>? userModels = snapshot.data;
                  if (userModels == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container(
                    width: 340.w,
                    height: 175.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 24.w, top: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: UsedColor.main),
                              ),
                              SizedBox(
                                width: 17.w,
                              ),
                              SizedBox(
                                height: 14.h,
                                child: Text(
                                  '참여 중인 인원',
                                  style: AppTextStyles.PR_SB_12
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Text(
                                "${meetDetailRoomViewModel.currentRoomModel!.room_participant_reference.length + 1}",
                                style: AppTextStyles.PR_SB_12
                                    .copyWith(color: UsedColor.violet),
                              ),
                              Text(
                                '/4',
                                style: AppTextStyles.PR_SB_12
                                    .copyWith(color: UsedColor.text_3),
                              ),
                              SizedBox(
                                width: 3.0.w,
                              ),
                              Text(
                                // '(여자 1자리, 남자 1자리 남음)',
                                meetDetailRoomViewModel.calRestParticipantNum(
                                    userModels: userModels),
                                style: AppTextStyles.PR_SB_12
                                    .copyWith(color: UsedColor.text_5),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 17.0.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: SizedBox(
                              width: 252.w,
                              height: 97.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: userModels.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 24.w), // 간격 조절
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // 눌렀을 때 프로필 상세 정보로 넘어가기
                                      logger.d(
                                        "nickname: ${userModels[index].nickname}\nbirthday: ${userModels[index].birthday}\ngender: ${userModels[index].gender}\njob: ${userModels[index].job}",
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 45.w,
                                          height: 45.h,
                                          child: (index == 0)
                                              ? Stack(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  children: [
                                                    Image.asset(
                                                      userModels[index]
                                                          .profile_icon,
                                                    ),
                                                    Image.asset(
                                                      width: 19.w,
                                                      height: 19.h,
                                                      ImagePath.crownIcon,
                                                    ),
                                                  ],
                                                )
                                              : Image.asset(
                                                  userModels[index]
                                                      .profile_icon,
                                                ),
                                        ),
                                        SizedBox(
                                          height: 12.h,
                                        ),
                                        SizedBox(
                                          height: 14.h,
                                          child: Text(
                                            userModels[index].nickname,
                                            style: AppTextStyles.PR_SB_12
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Container(
                                          width: 45.w,
                                          height: 18.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.5.r),
                                            color: UsedColor.image_card,
                                          ),
                                          child: Center(
                                            child: Text(
                                              userModels[index].gender == 'male'
                                                  ? '남성'
                                                  : '여성',
                                              style: AppTextStyles.SU_M_10
                                                  .copyWith(
                                                      color: UsedColor.violet),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 48.h),
              _removeButton(context),
            ],
          ),
        ),
      ),
    );
  }

// 세부 규칙 - 예, 아니요 컨테이너
  Widget _responseBox(BuildContext context, bool isSelected, bool response) {
    return Container(
      width: 43.w,
      height: 19.h,
      decoration: BoxDecoration(
          color: (isSelected == response) ? UsedColor.button : Colors.white,
          borderRadius: BorderRadius.circular(9.9.r),
          border: Border.all(
              color: (isSelected == response)
                  ? UsedColor.button
                  : UsedColor.b_line,
              width: 1.41.h)),
      child: Center(
        child: Text(
          response ? '가능' : '불가능',
          style: AppTextStyles.PR_SB_11.copyWith(
            color: (isSelected == response)
                ? Colors.white
                : UsedColor.charcoal_black,
          ),
        ),
      ),
    );
  }

  //MARK: - 키워드
  Widget _keywordContainer(String keyword) {
    return Container(
      width: 68.w,
      height: 19.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Center(
        child: Text(
          '#$keyword',
          style: AppTextStyles.SU_SB_9.copyWith(color: UsedColor.violet),
        ),
      ),
    );
  }

  // MARK: - 카테고리, 지역, 나이, 성비
  Widget _etcBox(
      BuildContext context, RoomModel decodedRoomModel, String ageString) {
    return Container(
      width: 340.w,
      height: 131.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, top: 17.h),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(
                  width: 11.w,
                ),
                Text(
                  '카테고리',
                  style: AppTextStyles.PR_SB_12.copyWith(color: Colors.black),
                ),
                SizedBox(width: 14.w),
                Text(
                  '${decodedRoomModel.room_category} > ${decodedRoomModel.room_category_detail}',
                  style:
                      AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // 지역
            Row(
              children: [
                // 파란 동그라미
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(
                  width: 11.w,
                ),
                Text(
                  '지역',
                  style: AppTextStyles.PR_SB_12.copyWith(color: Colors.black),
                ),
                SizedBox(width: 10.w),
                Text(
                  '${decodedRoomModel.room_region_district} ${decodedRoomModel.room_region_province}',
                  style:
                      AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // 나이
            Row(
              children: [
                // 파란 동그라미
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(
                  width: 11.w,
                ),
                Text(
                  '나이',
                  style: AppTextStyles.PR_SB_12.copyWith(color: Colors.black),
                ),
                SizedBox(width: 10.w),
                Text(
                  ageString,
                  style:
                      AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            // 성비
            Row(
              children: [
                // 파란 동그라미
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: UsedColor.main),
                ),
                SizedBox(
                  width: 11.w,
                ),
                Text(
                  '성비',
                  style: AppTextStyles.PR_SB_12.copyWith(color: Colors.black),
                ),
                SizedBox(width: 10.w),
                Text(
                  decodedRoomModel.room_gender_ratio,
                  style:
                      AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //MARK: - 삭제 or 참여 요청 버튼
  Widget _removeButton(BuildContext context) {
    final meetDetailRoomViewModel =
        Provider.of<MeetDetailRoomViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(bottom: 56.h, left: 6.w, right: 6.w),
      child: GestureDetector(
        onTap: () async {
          if (meetDetailRoomViewModel.isMyRoom!) {
            // 삭제 or 참여 요청 버튼
            await meetDetailRoomViewModel.deleteRoom(myUid: userViewModel.uid!);
            // 삭제가 완료 되면 뒤로 가기
            if (context.mounted) context.pop();
          }
        },
        child: Container(
          width: 327.w,
          height: 56.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19.r),
              color: UsedColor.charcoal_black),
          child: Center(
            child: Text(
              meetDetailRoomViewModel.isMyRoom! ? '삭제' : '참여하기',
              style: AppTextStyles.PR_SB_20.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
