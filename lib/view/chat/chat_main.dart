import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:meet_up/view_model/chat/chat_room_view_model.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ChatMain extends StatelessWidget {
  const ChatMain({super.key});

  // MARK: - 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Container(
              width: 1.sw,
              color: UsedColor.bg_color,
              child: _main(context),
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - 헤더
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(title: '채팅', back: null),
          SizedBox(
            height: 16.h,
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

  // MARK: - 메인
  Widget _main(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 33.h),
          Text(
            '채팅 목록',
            style: AppTextStyles.PR_SB_20.copyWith(
              color: UsedColor.charcoal_black,
            ),
          ),
          SizedBox(height: 16.3.h),
          // 이중 StreamBuilder 사용 (MyRoomModel, RoomModel의 비동기 변화 처리가 필요)
          StreamBuilder<QuerySnapshot<Object?>>(
            stream: chatViewModel.readMyRoomCollectionStream(
              uid: userViewModel.uid!,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<MyRoomModel> myRoomModels = snapshot.data?.docs.map(
                      (e) {
                        return MyRoomModel.fromJson(
                            e.data() as Map<String, dynamic>);
                      },
                    ).toList() ??
                    [];

                List<DocumentReference> roomModelDocumentList =
                    myRoomModels.map(
                  (e) {
                    return e.room_reference;
                  },
                ).toList();

                return roomModelDocumentList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data?.docs.length ?? 0,
                          padding: EdgeInsets.zero,
                          reverse: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return StreamBuilder<DocumentSnapshot>(
                              stream: roomModelDocumentList[index].snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  final roomModel = RoomModel.fromJson(
                                      snapshot.data!.data()
                                          as Map<String, dynamic>);
                                  return _chatRoomContainer(
                                    context,
                                    roomModel,
                                    index,
                                    myRoomModels,
                                    roomModelDocumentList,
                                  );
                                }
                              },
                            );
                          },
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 238.h),
                        child: Center(
                          child: Text(
                            '입장 중인 채팅 방이 없습니다.',
                            style: AppTextStyles.PR_R_15.copyWith(
                              color: UsedColor.text_2,
                            ),
                          ),
                        ),
                      );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _chatRoomContainer(
    BuildContext context,
    RoomModel roomModel,
    int index,
    List<MyRoomModel> myRoomModels,
    List<DocumentReference> roomModelDocumentList,
  ) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    // 테스트 메세지 카운트
    // final newMessageCount =
    //     Random().nextInt(18) + 1;
    // 테스트 최근 메세지
    final recentMessage = roomModel.recentMessage.replaceAll("\n", " ");
    // 만료 여부
    bool timeOver = roomModel.room_creation_date
            .toDate()
            .add(const Duration(days: 7))
            .compareTo(DateTime.now()) <
        0;
    // 일정 확정 여부
    bool isScheduleDecided = roomModel.isScheduleDecided;
    // 만남 일정
    bool isOwnerExit = roomModel.isOwnerExit;
    bool isRoomDeleted = roomModel.isRoomDeleted;
    bool isRoomEnd = isScheduleDecided &&
        roomModel.room_schedule!["date"].toDate().isBefore(DateTime.now());

    Timestamp roomSchedule = Timestamp.now();
    if (isScheduleDecided) {
      roomSchedule = roomModel.room_schedule!["date"] as Timestamp;
    }
    String participantLength = (roomModel.room_participant_reference.length +
            (roomModel.isOwnerExit ? 0 : 1))
        .toString();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            // 입장 하는 방의 상태 값 초기화
            chatRoomViewModel.resetState();

            // 입장 하려는 방에 정보 전달
            chatRoomViewModel.setRoomRef(roomModelDocumentList[index]);

            // 처음 입장하는 방인 경우
            if (myRoomModels[index].isNew) {
              // isNew 상태를 false로 변경
              await chatViewModel.updateMyRoomInfo(
                uid: userViewModel.uid!,
                roomId: myRoomModels[index].room_reference.id,
                data: {'isNew': false},
              );
              // 온 보딩 화면으로 전환
              if (context.mounted) {
                context.goNamed('first_enter_onboarding');
              }
            }
            // 처음 입장하는 방이 아닌 경우
            else {
              // 바로 채팅방으로 이동
              context.goNamed('chatRoom');
            }
          },
          child: Container(
            height: 80.h,
            width: 345.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 17.h,
                ),
                Row(
                  children: [
                    SizedBox(width: 20.w),
                    SizedBox(
                      width: 323.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            flex: 1,
                            child: Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 92.w,
                                  ),
                                  child: Text(
                                    roomModel.room_name,
                                    style: AppTextStyles.PR_SB_16.copyWith(
                                      color: UsedColor.charcoal_black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                SizedBox(
                                  height: 16.h,
                                  child: Text(
                                    participantLength,
                                    style: AppTextStyles.PR_SB_13
                                        .copyWith(color: UsedColor.violet),
                                  ),
                                ),
                                SizedBox(
                                  height: 14.h,
                                  child: Text(
                                    "/4명",
                                    style: AppTextStyles.PR_M_12
                                        .copyWith(color: UsedColor.text_5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Text(
                              textAlign: TextAlign.end,
                              isScheduleDecided
                                  ? isRoomEnd
                                      ? "${roomSchedule.toDate().toString().substring(0, 10).replaceAll('-', '.')} 만남 완료"
                                      : isOwnerExit
                                          ? "삭제됨"
                                          : "${roomSchedule.toDate().toString().substring(0, 10).replaceAll('-', '.')} 만남 예정"
                                  : isOwnerExit
                                      ? "삭제됨"
                                      : "${roomModel.room_creation_date.toDate().add(const Duration(days: 7)).toString().substring(0, 10).replaceAll('-', '.')} 만료",
                              style: AppTextStyles.PR_M_11.copyWith(
                                color: timeOver
                                    ? UsedColor.red
                                    : isScheduleDecided
                                        ? isOwnerExit
                                            ? UsedColor.red
                                            : UsedColor.main
                                        : isOwnerExit
                                            ? UsedColor.red
                                            : UsedColor.text_3,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Flexible(
                  flex: 1,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 186.w),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        recentMessage,
                        style: AppTextStyles.PR_R_14.copyWith(
                          color: UsedColor.text_3,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h)
      ],
    );
  }
}
