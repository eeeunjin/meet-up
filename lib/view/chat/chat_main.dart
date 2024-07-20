import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/view/chat/chat_notification_onboarding.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ChatMain extends StatelessWidget {
  const ChatMain({super.key});

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
          _notification(context),
        ],
      ),
    );
  }

  // header
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

  Widget _notification(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: UsedColor.bg_color,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatNotification()),
            );
          },
          child: const Text('채팅 시 주의 사항'),
        ),
      ),
    );
  }

  Widget _main(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
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
                List<DocumentReference> myRoomDocumentList =
                    snapshot.data?.docs.map(
                          (e) {
                            final myRoomModel = MyRoomModel.fromJson(
                                e.data() as Map<String, dynamic>);
                            return myRoomModel.room_reference;
                          },
                        ).toList() ??
                        [];
                return myRoomDocumentList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data?.docs.length ?? 0,
                          padding: EdgeInsets.zero,
                          reverse: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return StreamBuilder<DocumentSnapshot>(
                              stream: myRoomDocumentList[index].snapshots(),
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
                                  final recentMessageList = [
                                    '안녕하세요 반가워요 ~',
                                    '그럼 저희 어디서 만날지 부터 정할까요 ??',
                                    '일정 등록 했어요 ~ 다들 확인 해주세요 !',
                                    '??',
                                    'ㅋㅋㅋㅋㅋ 아니에요',
                                    '네 알겠습니다 !',
                                  ];
                                  // 만료 여부
                                  bool timeOver = roomModel.room_creation_date
                                          .toDate()
                                          .add(const Duration(days: 7))
                                          .compareTo(DateTime.now()) <
                                      0;
                                  final recentMessage = recentMessageList[
                                      Random()
                                          .nextInt(recentMessageList.length)];
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
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
                                              children: [
                                                SizedBox(width: 20.w),
                                                SizedBox(
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
                                                SizedBox(width: 2.w),
                                                Text(
                                                  "${roomModel.room_participant_reference.length + 1}",
                                                  style: AppTextStyles.PR_SB_13
                                                      .copyWith(
                                                          color:
                                                              UsedColor.violet),
                                                ),
                                                Text(
                                                  "/4명",
                                                  style: AppTextStyles.PR_M_12
                                                      .copyWith(
                                                          color:
                                                              UsedColor.text_5),
                                                ),
                                                SizedBox(width: 10.w),
                                                // 알림 설정 상태
                                                Container(
                                                  height: 12.h,
                                                  width: 12.w,
                                                  color: UsedColor.text_6,
                                                ),
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
                                                        width: 186.w,
                                                        child: Text(
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
                                                      )
                                                    : Text(
                                                        recentMessage,
                                                        style: AppTextStyles
                                                            .PR_R_14
                                                            .copyWith(
                                                          color:
                                                              UsedColor.text_3,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                if (recentMessage.length <= 18)
                                                  SizedBox(width: 8.w),
                                                Container(
                                                  height: 13.h,
                                                  width: newMessageCount > 10
                                                      ? 17.w
                                                      : 13.w,
                                                  padding: EdgeInsets.only(
                                                    top: 1.h,
                                                    right: 0.5.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      6.5.r,
                                                    ),
                                                    color: UsedColor.main,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '$newMessageCount',
                                                      style: AppTextStyles
                                                          .PR_SB_10
                                                          .copyWith(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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
                            style: AppTextStyles.PR_R_13.copyWith(
                              color: UsedColor.text_3,
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
