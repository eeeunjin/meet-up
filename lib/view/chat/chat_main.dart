import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                                  // 테스트 메세지 카운트
                                  final newMessageCount =
                                      Random().nextInt(18) + 1;
                                  // 테스트 최근 메세지
                                  final recentMessage = roomModel.recentMessage;
                                  // 만료 여부
                                  bool timeOver = roomModel.room_creation_date
                                          .toDate()
                                          .add(const Duration(days: 7))
                                          .compareTo(DateTime.now()) <
                                      0;
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          logger.d(
                                              roomModelDocumentList[index].id);
                                          // 입장 하는 방의 상태 값 초기화
                                          chatRoomViewModel.resetState();

                                          // 입장 하려는 방에 정보 전달
                                          chatRoomViewModel.setRoomRef(
                                              roomModelDocumentList[index]);

                                          // 처음 입장하는 방인 경우
                                          if (myRoomModels[index].isNew) {
                                            // isNew 상태를 false로 변경
                                            await chatViewModel
                                                .updateMyRoomInfo(
                                              uid: userViewModel.uid!,
                                              roomId: myRoomModels[index]
                                                  .room_reference
                                                  .id,
                                              data: {'isNew': false},
                                            );
                                            // 온 보딩 화면으로 전환
                                            context.goNamed(
                                                'first_enter_onboarding');
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
                                            borderRadius:
                                                BorderRadius.circular(15.r),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 17.h,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: 20.w),
                                                  SizedBox(
                                                    height: 19.h,
                                                    width: 92.w,
                                                    child: Text(
                                                      roomModel.room_name,
                                                      style: AppTextStyles
                                                          .PR_SB_16
                                                          .copyWith(
                                                        color: UsedColor
                                                            .charcoal_black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  SizedBox(
                                                    height: 16.h,
                                                    child: Text(
                                                      roomModel.isRoomDeleted
                                                          ? "${roomModel.room_participant_reference.length}"
                                                          : "${roomModel.room_participant_reference.length + 1}",
                                                      style: AppTextStyles
                                                          .PR_SB_13
                                                          .copyWith(
                                                              color: UsedColor
                                                                  .violet),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 14.h,
                                                    child: Text(
                                                      "/4명",
                                                      style: AppTextStyles
                                                          .PR_M_12
                                                          .copyWith(
                                                              color: UsedColor
                                                                  .text_5),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  const Spacer(),
                                                  Text(
                                                    "${roomModel.room_creation_date.toDate().add(const Duration(days: 7)).toString().substring(0, 10).replaceAll('-', '.')} 만료",
                                                    style: AppTextStyles.PR_M_11
                                                        .copyWith(
                                                      color: timeOver
                                                          ? UsedColor.red
                                                          : UsedColor.text_3,
                                                    ),
                                                  ),
                                                  SizedBox(width: 19.w),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8.h,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(width: 20.w),
                                                  recentMessage.length > 18
                                                      ? SizedBox(
                                                          height: 17.h,
                                                          width: 186.w,
                                                          child: Text(
                                                            recentMessage,
                                                            style: AppTextStyles
                                                                .PR_R_14
                                                                .copyWith(
                                                              color: UsedColor
                                                                  .text_3,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        )
                                                      : Text(
                                                          recentMessage,
                                                          style: AppTextStyles
                                                              .PR_R_14
                                                              .copyWith(
                                                            color: UsedColor
                                                                .text_3,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                  if (recentMessage.length <=
                                                      18)
                                                    SizedBox(width: 8.w),
                                                  // Container(
                                                  //   height: 13.h,
                                                  //   width: newMessageCount > 10
                                                  //       ? 17.w
                                                  //       : 13.w,
                                                  //   padding: EdgeInsets.only(
                                                  //     top: 1.h,
                                                  //     right: 0.5.h,
                                                  //   ),
                                                  //   decoration: BoxDecoration(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //       6.5.r,
                                                  //     ),
                                                  //     color: UsedColor.main,
                                                  //   ),
                                                  //   child: Center(
                                                  //     child: Text(
                                                  //       '$newMessageCount',
                                                  //       style: AppTextStyles
                                                  //           .PR_SB_10
                                                  //           .copyWith(
                                                  //         color: Colors.white,
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h)
                                    ],
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
}
