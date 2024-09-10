import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/chat_room_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/chat/chat_room_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_detail_room_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  // MARK: - 빌드
  @override
  Widget build(BuildContext context) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    final meetDetailRoomViewModel =
        Provider.of<MeetDetailRoomViewModel>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      stream: chatRoomViewModel.roomRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.error != null) {
          return const Center(
            child: Text("에러가 발생했습니다."),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          if (chatRoomViewModel.userModels.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }

        chatRoomViewModel.setRoomModel(
            RoomModel.fromJson(snapshot.data!.data() as Map<String, dynamic>));
        chatRoomViewModel.setRoomID(chatRoomViewModel.roomRef.id);

        return FutureBuilder<void>(
          future: chatRoomViewModel.setUserModels(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("에러가 발생했습니다."),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              if (chatRoomViewModel.userModels.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }

            return Selector<ChatRoomViewModel, bool>(
              builder: (context, value, child) {
                return Opacity(
                  opacity: value ? 0.8 : 1,
                  child: Scaffold(
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 58.h,
                              ),
                              child: _header(context),
                            ),
                            Positioned(
                              right: 11.w,
                              bottom: 2.h,
                              child: PullDownButton(
                                routeTheme:
                                    PullDownMenuRouteTheme(width: 200.w),
                                onCanceled: () {
                                  // 키보드 내리기
                                  chatRoomViewModel.setStartEdit(false);
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  // PullDownMenu 관련 변수 설정
                                  chatRoomViewModel.setMoreOptionClicked(false);
                                },
                                itemBuilder: (context) => [
                                  PullDownMenuItem(
                                    title: '알람 켜기',
                                    itemTheme: PullDownMenuItemTheme(
                                      textStyle: AppTextStyles.PR_M_13.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: () {
                                      // 키보드 내리기
                                      chatRoomViewModel.setStartEdit(false);
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      // PullDownMenu 관련 변수 설정
                                      chatRoomViewModel
                                          .setMoreOptionClicked(false);
                                    },
                                  ),
                                  PullDownMenuItem(
                                    title: '방 세부 정보 보기',
                                    itemTheme: PullDownMenuItemTheme(
                                      textStyle: AppTextStyles.PR_M_13.copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: () {
                                      logger.d("방 세부 정보 보기 버튼 눌림");
                                      // 키보드 내리기
                                      chatRoomViewModel.setStartEdit(false);
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      meetDetailRoomViewModel
                                          .setCurrentRoomModel(
                                              roomModel:
                                                  chatRoomViewModel.roomModel);
                                      meetDetailRoomViewModel.setIsChatRoom(
                                          isChatRoom: true);
                                      meetDetailRoomViewModel.setIsMyRoom(
                                          isMyRoom: false);
                                      context.goNamed('chatRoomDetail');
                                      chatRoomViewModel
                                          .setMoreOptionClicked(false);
                                    },
                                  ),
                                  PullDownMenuItem(
                                    title: '채팅방 나가기',
                                    itemTheme: PullDownMenuItemTheme(
                                      textStyle:
                                          AppTextStyles.PR_SB_13.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                    onTap: () {
                                      logger.d("방 나가기 버튼 눌림");
                                      // 키보드 내리기
                                      chatRoomViewModel.setStartEdit(false);
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      _showOutRoomDialog(context);
                                      chatRoomViewModel
                                          .setMoreOptionClicked(false);
                                    },
                                  ),
                                ],
                                buttonBuilder: (context, showMenu) =>
                                    CupertinoButton(
                                  onPressed: () {
                                    chatRoomViewModel
                                        .setMoreOptionClicked(true);
                                    showMenu();
                                  },
                                  padding: EdgeInsets.zero,
                                  child: Image.asset(
                                    ImagePath.chatRoomMoreOptionButton,
                                    width: 28.h,
                                    height: 28.h,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            width: 1.sw,
                            color: Colors.white,
                            child: _main(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              selector: (context, chatRoomViewModel) =>
                  chatRoomViewModel.moreOptionClicked,
            );
          },
        );
      },
    );
  }

  // MARK: - 헤더
  Widget _header(BuildContext context) {
    final chatViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    return Center(
      child: Column(
        children: [
          header(
            title: chatViewModel.roomName,
            back: _back(context),
          ),
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

  // MARK: - 뒤로가기
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

  // MARK: - 메인
  Widget _main(BuildContext context) {
    return Column(
      children: [
        _chatBody(context),
        _typeMessageBox(context),
      ],
    );
  }

  // MARK: - 채팅 바디
  Widget _chatBody(BuildContext context) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // 키보드 내리기
          chatRoomViewModel.setStartEdit(false);
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              _chatNotification(context),
              _chatList(context),
            ],
          ),
        ),
      ),
    );
  }

  // MARK: - 채팅 공지
  Widget _chatNotification(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logger.d("채팅 시 주의 사항 버튼이 눌렸습니다.");
        context.goNamed('chat_room_onboarding');
      },
      child: Container(
        width: 357.w,
        height: 31.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.5.r),
          color: UsedColor.image_card,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 12.w,
            ),
            Image.asset(
              ImagePath.chatRoomNoticeImage,
              width: 20.w,
              height: 20.h,
            ),
            SizedBox(
              width: 6.14.w,
            ),
            Text(
              "채팅 시 주의 사항",
              style: AppTextStyles.PR_SB_15.copyWith(
                color: UsedColor.charcoal_black,
              ),
            ),
            const Spacer(),
            Image.asset(
              ImagePath.chatRoomChevronRightImage,
              width: 6.25.w,
              height: 12.5.h,
            ),
            SizedBox(
              width: 14.37.w,
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - 채팅 리스트
  Widget _chatList(BuildContext context) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomViewModel.getChatStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.error != null) {
          return const Center(
            child: Text("에러가 발생했습니다."),
          );
        }

        final chatListDocs = snapshot.data!.docs;
        // chatListDocs의 정보를 ChatModel로 변환
        final chatModels = chatListDocs
            .map((chatDoc) =>
                ChatModel.fromJson(chatDoc.data() as Map<String, dynamic>))
            .toList();

        // chatModels를 시간 순으로 정렬
        chatModels.sort((a, b) => a.date.compareTo(b.date));

        // chatModels를 [String(~년 ~월 ~일), ChatModel]으로 변환, DateFormat을 사용하여 날짜 변환
        final chatModelsGroupByDate = <String, List<ChatModel>>{};
        for (var chatModel in chatModels) {
          final date = chatModel.date.toDate();
          final dateString = "${date.year}년 ${date.month}월 ${date.day}일";
          if (chatModelsGroupByDate[dateString] == null) {
            chatModelsGroupByDate[dateString] = [];
          }
          chatModelsGroupByDate[dateString]!.add(chatModel);
        }

        return Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              reverse: true,
              controller: chatRoomViewModel.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...chatModelsGroupByDate.keys.map(
                    (key) {
                      return Column(
                        children: [
                          SizedBox(height: 20.h),
                          Container(
                            width: 110.w,
                            height: 23.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11.5.r),
                              color: UsedColor.chat,
                            ),
                            child: Center(
                              child: Text(
                                key,
                                style: AppTextStyles.PR_R_11.copyWith(
                                  color: UsedColor.text_4,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // chatModelsGroupByDate[key]의 ChatModel 별로 chatBox 생성
                          ...chatModelsGroupByDate[key]!.map(
                            (chatModel) {
                              final isMyChat =
                                  chatModel.uid == userViewModel.uid;
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: 20.h,
                                ),
                                child: _chatBox(
                                  context,
                                  isMyChat: isMyChat,
                                  chatModel: chatModel,
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // MARK: - 채팅박스 (종류에 따라 다른 채팅박스 생성)
  Widget _chatBox(
    BuildContext context, {
    required bool isMyChat,
    required ChatModel chatModel,
  }) {
    switch (chatModel.type) {
      case "chat":
        return _chat(context, isMyChat: isMyChat, chatModel: chatModel);
      case "enter":
        return _enter(context, isMyChat: isMyChat, chatModel: chatModel);
      case "exit":
        return _exit(context, isMyChat: isMyChat, chatModel: chatModel);
      case "schedule_write":
        return _scheduleWrite(context,
            isMyChat: isMyChat, chatModel: chatModel);
      case "schedule_register":
        return _scheduleRegister(context,
            isMyChat: isMyChat, chatModel: chatModel);
      case "schedule_delete":
        return _scheduleDelete(context,
            isMyChat: isMyChat, chatModel: chatModel);
      default:
        return Container();
    }
  }

  // MAKR: - 채팅방 입장
  Widget _enter(
    BuildContext context, {
    required bool isMyChat,
    required ChatModel chatModel,
  }) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    final userModel = chatRoomViewModel.userModels
        .where((element) => element.uid == chatModel.uid)
        .first;

    return Center(
      child: Container(
        width: 344.w,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 0.5.h,
                color: UsedColor.text_4,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              userModel.nickname + chatModel.content,
              style: AppTextStyles.PR_M_11.copyWith(
                color: UsedColor.text_4,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Container(
                height: 0.5.h,
                color: UsedColor.text_4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - 채팅방 퇴장
  Widget _exit(
    BuildContext context, {
    required bool isMyChat,
    required ChatModel chatModel,
  }) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    final userModel = chatRoomViewModel.userModels
        .where((element) => element.uid == chatModel.uid)
        .first;

    return Center(
      child: Container(
        width: 344.w,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 0.5.h,
                color: UsedColor.text_4,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              userModel.nickname + chatModel.content,
              style: AppTextStyles.PR_M_11.copyWith(
                color: UsedColor.text_4,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Container(
                height: 0.5.h,
                color: UsedColor.text_4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - 채팅
  Widget _chat(
    BuildContext context, {
    required bool isMyChat,
    required ChatModel chatModel,
  }) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    // 채팅 라인 수에 맞춘 높이 계산
    final lineNum = chatRoomViewModel.calculateLineCount(
        chatModel.content, 240.w, AppTextStyles.PR_R_12);

    final height = ((isMyChat) ? 30.h : 51.h) + (lineNum - 1) * 14.h;
    final chatBoxHeight = isMyChat ? 0.h : 30.h + (lineNum - 1) * 14.h;

    // 채팅 길이에 맞춘 너비 계산
    // 1. 채팅 내용을 줄바꿈으로 나누기
    final contentSplited = chatModel.content.split('\n');
    // 2. 채팅 내용 중 가장 긴 너비 계산
    var limitWidth = 198.w;
    var maxWidth = 0.w;
    for (var content in contentSplited) {
      final width =
          chatRoomViewModel.calculateTextWidth(content, AppTextStyles.PR_R_12);
      if (width > maxWidth) maxWidth = width;
    }
    if (maxWidth > limitWidth) maxWidth = limitWidth;
    // 3. 채팅 박스 너비 계산
    final chatBoxWidth = maxWidth + 28.w;
    // 4. 채팅 보낸 시간 계산
    final sendTime = chatModel.date.toDate();
    final sendTimeHour = sendTime.hour % 12;
    final sendTimeMinute =
        sendTime.minute < 10 ? "0${sendTime.minute}" : sendTime.minute;
    final sendTimeString =
        '${sendTime.hour > 12 ? '오후' : '오전'} $sendTimeHour:$sendTimeMinute';
    // 다른 사람의 채팅인 경우 해당 유저 정보 불러오기
    UserModel? otherUser;
    if (!isMyChat) {
      otherUser = chatRoomViewModel.userModels
          .where((element) => element.uid == chatModel.uid)
          .first;
    }

    // 5. 방장의 채팅인지 확인하는 변수
    bool isOwnerChat = chatModel.uid == chatRoomViewModel.userModels[0].uid;

    if (isMyChat) {
      return SizedBox(
        width: 393.w,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              sendTimeString,
              style: AppTextStyles.PR_M_10.copyWith(color: UsedColor.text_3),
            ),
            SizedBox(
              width: 4.w,
            ),
            Container(
              width: chatBoxWidth,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: UsedColor.main,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                    top: 8.h,
                    bottom: 8.h,
                  ),
                  child: Text(
                    chatModel.content,
                    style: AppTextStyles.PR_R_12.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 28.w),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 393.w,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28.h,
            ),
            Stack(
              children: [
                Image.asset(
                  otherUser!.profile_icon,
                  width: 45.h,
                  height: 45.h,
                ),
                if (isOwnerChat)
                  Positioned(
                    right: 0.h,
                    bottom: 0.h,
                    child: Container(
                      width: 19.h,
                      height: 19.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.5.r),
                        color: UsedColor.main,
                      ),
                      child: Image.asset(
                        ImagePath.chatRoomOwnerCrownImage,
                        width: 12.0.h,
                        height: 12.0.h,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              width: 11.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherUser.nickname,
                  style: AppTextStyles.PR_SB_13.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Container(
                  width: chatBoxWidth,
                  height: chatBoxHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    color: UsedColor.chat,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 12.w,
                        top: 8.h,
                        bottom: 8.h,
                      ),
                      child: Text(
                        chatModel.content,
                        style: AppTextStyles.PR_R_12.copyWith(
                          color: UsedColor.charcoal_black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 4.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    logger.d("[${otherUser!.nickname}]님에 대한 신고 버튼이 눌렸습니다.");
                  },
                  child: Image.asset(
                    ImagePath.chatRoomDeclarationButton,
                    height: 19.h,
                    width: 19.h,
                  ),
                ),
                Text(
                  sendTimeString,
                  style: AppTextStyles.PR_M_10.copyWith(
                    color: UsedColor.text_3,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  // MARK: - 일정 작성 가능 알림
  Widget _scheduleWrite(
    BuildContext context, {
    required bool isMyChat,
    required ChatModel chatModel,
  }) {
    return Container(
      width: 338.w,
      height: 79.h,
      padding: EdgeInsets.only(left: 13.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: UsedColor.image_card,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 7.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: Image.asset(
                  ImagePath.chatRoomScheduleWriteIcon,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '일정 등록 가능',
                style: AppTextStyles.PR_SB_14
                    .copyWith(color: UsedColor.charcoal_black),
              ),
            ],
          ),
          SizedBox(
            height: 9.h,
          ),
          Text(
            '채팅방에 인원이 모두 들어왔습니다.',
            style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.text_4),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            '대화를 나누고, 일정을 등록해 보세요!',
            style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.text_4),
          )
        ],
      ),
    );
  }

  // MARK: - 일정 등록 알림
  Widget _scheduleRegister(
    BuildContext context, {
    required bool isMyChat,
    required ChatModel chatModel,
  }) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);

    // 1. 채팅 보낸 시간 계산
    final sendTime = chatModel.date.toDate();
    final sendTimeHour = sendTime.hour % 12;
    final sendTimeMinute =
        sendTime.minute < 10 ? "0${sendTime.minute}" : sendTime.minute;
    final sendTimeString =
        '${sendTime.hour > 12 ? '오후' : '오전'} $sendTimeHour:$sendTimeMinute';

    // room schedule 날짜 계산 (2024. 2. 7. (수) 형태로)
    final roomScheduleDate =
        RoomSchedule.fromJson(chatRoomViewModel.roomModel.room_schedule!)
            .date
            .toDate();
    final roomScheduleDateYear = roomScheduleDate.year.toString();
    final roomScheduleDateMonth = roomScheduleDate.month.toString();
    final roomScheduleDateDay = roomScheduleDate.day.toString();
    final roomScheduleDateDayOfWeek = chatRoomViewModel.getDayOfWeek(
        int.parse(roomScheduleDateYear),
        int.parse(roomScheduleDateMonth),
        int.parse(roomScheduleDateDay));
    final roomScheduleDateText =
        '$roomScheduleDateYear. $roomScheduleDateMonth. $roomScheduleDateDay. ($roomScheduleDateDayOfWeek)';

    // room schedule 시간 계산 (오후 3:00 형태로)
    final roomScheduleHour = roomScheduleDate.hour % 12;
    final roomScheduleMinute = roomScheduleDate.minute < 10
        ? "0${roomScheduleDate.minute}"
        : roomScheduleDate.minute;
    final roomScheduleTime =
        '${roomScheduleDate.hour > 12 ? '오후' : '오전'} $roomScheduleHour:$roomScheduleMinute';

    // 2. 다른 사람의 채팅인 경우 해당 유저 정보 불러오기
    UserModel? otherUser;
    if (!isMyChat) {
      otherUser = chatRoomViewModel.userModels
          .where((element) => element.uid == chatModel.uid)
          .first;
    }

    // 3. 방장의 채팅인지 확인하는 변수
    bool isOwnerChat = chatModel.uid == chatRoomViewModel.userModels[0].uid;

    if (isMyChat) {
      return SizedBox(
        width: 393.w,
        height: 189.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              sendTimeString,
              style: AppTextStyles.PR_M_10.copyWith(color: UsedColor.text_3),
            ),
            SizedBox(
              width: 4.w,
            ),
            _scheduleBox(
              context,
              chatRoomViewModel: chatRoomViewModel,
              roomScheduleDateText: roomScheduleDateText,
              roomScheduleTime: roomScheduleTime,
            ),
            SizedBox(width: 28.w),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 393.w,
        height: 210.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28.h,
            ),
            Stack(
              children: [
                Image.asset(
                  otherUser!.profile_icon,
                  width: 45.h,
                  height: 45.h,
                ),
                if (isOwnerChat)
                  Positioned(
                    right: 0.h,
                    bottom: 0.h,
                    child: Container(
                      width: 19.h,
                      height: 19.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.5.r),
                        color: UsedColor.main,
                      ),
                      child: Image.asset(
                        ImagePath.chatRoomOwnerCrownImage,
                        width: 12.0.h,
                        height: 12.0.h,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              width: 11.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherUser.nickname,
                  style: AppTextStyles.PR_SB_13.copyWith(
                    color: UsedColor.charcoal_black,
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                _scheduleBox(
                  context,
                  chatRoomViewModel: chatRoomViewModel,
                  roomScheduleDateText: roomScheduleDateText,
                  roomScheduleTime: roomScheduleTime,
                ),
              ],
            ),
            SizedBox(width: 4.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    logger.d("[${otherUser!.nickname}]님에 대한 신고 버튼이 눌렸습니다.");
                  },
                  child: Image.asset(
                    ImagePath.chatRoomDeclarationButton,
                    height: 19.h,
                    width: 19.h,
                  ),
                ),
                Text(
                  sendTimeString,
                  style: AppTextStyles.PR_M_10.copyWith(
                    color: UsedColor.text_3,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  // MARK: - 일정 삭제 알림
  Widget _scheduleDelete(
    BuildContext context, {
    required bool isMyChat,
    required ChatModel chatModel,
  }) {
    // 일정 삭제 view 표시
    return Container(
      width: 338.w,
      height: 79.h,
      padding: EdgeInsets.only(left: 13.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: UsedColor.image_card,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 12.67.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: Image.asset(
                  ImagePath.chatRoomDeleteScheduleIcon,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '일정 삭제',
                style: AppTextStyles.PR_SB_14
                    .copyWith(color: UsedColor.charcoal_black),
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            "방장이 '${chatModel.content}' 일정을 삭제했습니다.",
            style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.text_4),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            '참석자들의 기존 참석 확인은 무효 처리 됩니다.',
            style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.text_4),
          )
        ],
      ),
    );
  }

  // MARK: - 일정 박스
  Widget _scheduleBox(
    BuildContext context, {
    required chatRoomViewModel,
    required roomScheduleDateText,
    required roomScheduleTime,
  }) {
    return Container(
      width: 195.w,
      height: 189.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19.r),
        color: UsedColor.chat,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(left: 17.w),
            child: Text(
              chatRoomViewModel.roomModel.room_schedule!["title"],
              style: AppTextStyles.PR_SB_15.copyWith(
                color: UsedColor.charcoal_black,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.chat_line,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 17.w),
              Text(
                '날짜',
                style: AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
              ),
              SizedBox(
                width: 7.w,
              ),
              Text(
                roomScheduleDateText,
                style: AppTextStyles.PR_R_12
                    .copyWith(color: UsedColor.charcoal_black),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              SizedBox(
                width: 17.w,
              ),
              Text(
                '시간',
                style: AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
              ),
              SizedBox(width: 7.w),
              Text(
                roomScheduleTime,
                style: AppTextStyles.PR_R_12.copyWith(
                  color: UsedColor.charcoal_black,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Center(
            child: Container(
              height: 26.h,
              width: 131.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: UsedColor.charcoal_black,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: GestureDetector(
                onTap: () {
                  logger.d("일정 확인하기 버튼이 눌렸습니다.");
                  context.goNamed('chatScheduleCheck');
                },
                child: Text(
                  '일정 확인하기',
                  style: AppTextStyles.PR_M_12.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0.h),
          Divider(
            thickness: 0.5.h,
            height: 0.h,
            color: UsedColor.chat_line,
          ),
          SizedBox(height: 9.h),
          Padding(
            padding: EdgeInsets.only(left: 17.w),
            child: Text(
              '일정 등록이 완료되었습니다!\n참석자들은 일정 확인 후 참석 확인 버튼을\n꼭 눌러 주세요.',
              style: AppTextStyles.PR_M_10.copyWith(
                color: UsedColor.text_3,
              ),
            ),
          )
        ],
      ),
    );
  }

  // MARK: - 메시지 입력창
  Widget _typeMessageBox(BuildContext context) {
    return Consumer<ChatRoomViewModel>(
      builder: (context, chatRoomViewModel, child) {
        var additionalHeight =
            ((chatRoomViewModel.lineNum > 5 ? 5 : chatRoomViewModel.lineNum) -
                    1) *
                12.h;
        if (chatRoomViewModel.lineNum == 0) additionalHeight = 0;

        // 방장인지 확인하는 변수
        final userViewModel =
            Provider.of<UserViewModel>(context, listen: false);
        final isOwner = chatRoomViewModel.userModels[0].nickname ==
            (userViewModel.userModel?.nickname ?? '');
        double typeContainerWidth = chatRoomViewModel.startEdit ? 296.w : 357.w;
        double typeContainerWidthEnd =
            isOwner ? typeContainerWidth - 52.w : typeContainerWidth;

        return SizedBox(
          height:
              (chatRoomViewModel.startEdit ? 70.h : 106.h) + additionalHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                thickness: 0.5.h,
                height: 0.h,
                color: UsedColor.line,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  if (isOwner) ...[
                    SizedBox(width: 18.w),
                    _scheduleButton(context),
                  ],
                  Padding(
                    padding: EdgeInsets.only(
                        left: isOwner ? 12.w : 16.w, right: 16.w),
                    child: Container(
                      width: typeContainerWidthEnd,
                      height: 38.h + additionalHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19.r),
                        color: UsedColor.bg_color,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.top,
                            cursorColor: UsedColor.main,
                            // cursorHeight: 18.h,
                            controller: chatRoomViewModel.messageController,
                            maxLines: null,
                            onTap: () {
                              chatRoomViewModel.setStartEdit(true);
                            },
                            onEditingComplete: () {
                              // 키보드에서 완료 누를 때 키보드 내려가지 않도록 막기
                            },
                            onChanged: (value) {
                              final lineNum =
                                  chatRoomViewModel.calculateLineCount(
                                      value, 240.w, AppTextStyles.PR_R_13);
                              chatRoomViewModel.setLineNum(lineNum);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                left: 22.w,
                                right: 22.w,
                                bottom: (chatRoomViewModel.lineNum == 1 ||
                                        chatRoomViewModel.lineNum == 0)
                                    ? (Platform.isAndroid)
                                        ? 22.h
                                        : 16.h
                                    : (Platform.isAndroid)
                                        ? 10.h
                                        : 4.h,
                              ),
                              hintText: '메시지를 입력해주세요',
                              hintStyle: AppTextStyles.PR_R_13
                                  .copyWith(color: UsedColor.text_3),
                              border: InputBorder.none,
                            ),
                            style: AppTextStyles.PR_R_13
                                .copyWith(color: UsedColor.text_3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (chatRoomViewModel.startEdit) ...[
                    GestureDetector(
                      onTap: () async {
                        // 채탱이 입력되어 채팅 리스트에 채팅 항목 생 후 List Rebuild
                        final message =
                            chatRoomViewModel.messageController.text;
                        // 메시지가 없으면 전송하지 않음
                        if (message.isEmpty) return;

                        // 메시지가 존재하는 경우 전송
                        logger.d(message);
                        chatRoomViewModel.messageController.clear();
                        chatRoomViewModel.setLineNum(0);

                        // DB에 채팅 데이터 저장
                        final userViewModel =
                            Provider.of<UserViewModel>(context, listen: false);

                        final chatModel = ChatModel(
                          uid: userViewModel.uid!,
                          content: message,
                          date: Timestamp.now(),
                          room_reference: chatRoomViewModel.roomID,
                          type: "chat",
                        );

                        // 채팅 정보를 전달
                        await chatRoomViewModel.createChatDocument(chatModel);

                        // 채팅 리스트를 최하단으로 이동
                        chatRoomViewModel.scrollToBottom();
                      },
                      child: Container(
                        width: 49.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19.r),
                          color: UsedColor.image_card,
                        ),
                        child: Center(
                          child: Image.asset(
                            ImagePath.chatRoomSendMessageButton,
                            width: 19.53.w,
                            height: 16.31.h,
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // MARK: - 일정 추가 버튼
  Widget _scheduleButton(BuildContext context) {
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () {
        for (var userModel in chatRoomViewModel.userModels) {
          logger.d("참가자: ${userModel.nickname}");
        }

        bool isScheduleExist =
            chatRoomViewModel.roomModel.room_schedule != null;

        if (isScheduleExist) {
          logger.d("일정이 이미 등록되어 있습니다.");
        } else {
          logger.d("등록된 일정이 아직 없습니다.");
        }

        if (chatRoomViewModel.userModels.length == 4 && !isScheduleExist) {
          context.goNamed('chatScheduleRegister');
        }
      },
      child: Container(
        width: 38.h,
        height: 38.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19.r),
          color: UsedColor.button_g,
        ),
        child: Image.asset(
          ImagePath.chatRoomScheduleSetButton,
          width: 22.86.h,
          height: 22.86.h,
        ),
      ),
    );
  }

  // MARK: - 채팅방 나가기
  void _showOutRoomDialog(BuildContext context) {
    logger.d("채팅방 나가기 다이얼로그 출력");
    final chatRoomViewModel =
        Provider.of<ChatRoomViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          "채팅방에서 나가시겠습니까?",
          style: AppTextStyles.PR_M_13.copyWith(color: Colors.black),
        ),
        content: Container(
          alignment: Alignment.bottomCenter,
          height: 20.h,
          child: Text(
            "채팅방을 나가면 대화 내용이 전부 삭제됩니다.",
            style: AppTextStyles.PR_R_12.copyWith(color: UsedColor.text_3),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              "취소",
              style: AppTextStyles.PR_M_13.copyWith(color: Colors.black),
            ),
            onPressed: () {
              context.pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              "나가기",
              style: AppTextStyles.PR_M_13.copyWith(color: Colors.black),
            ),
            onPressed: () async {
              // 1. 나간 사람이 방장인 경우
              // 2. 나간 사람이 참여자인 경우
              // 참여자인지 방장인지 구별하는 변수
              final isOnwer = chatRoomViewModel.userModels[0].nickname ==
                  userViewModel.userModel?.nickname;

              // room 정보 변경
              // 방장이 나간 경우
              if (isOnwer) {
                // TODO: 방장이 나간 경우에 대한 함수 작성
                // owner 정보 지우고, 방장이 나간 경우에 대한 변수 전달 필요
                logger.e("방장이 나간 경우에 대한 함수가 없습니다.");
                return;
              }
              // 참여자가 나간 경우
              else {
                var participantRefs = List.from(
                  chatRoomViewModel.roomModel.room_participant_reference,
                );
                participantRefs.remove(FirebaseFirestore.instance
                    .collection('users')
                    .doc(userViewModel.uid));

                await chatRoomViewModel.updateRoomData(
                  roomId: chatRoomViewModel.roomID,
                  data: {"room_participant_reference": participantRefs},
                );
              }

              // myRoom 정보 삭제
              await chatRoomViewModel.deleteMyRoom(
                uid: userViewModel.uid!,
                roomId: chatRoomViewModel.roomID,
              );

              // chatModel 추가
              final chatModel = ChatModel(
                uid: userViewModel.uid!,
                content: " 님이 채팅방을 나갔습니다.",
                date: Timestamp.now(),
                room_reference: chatRoomViewModel.roomID,
                type: "exit",
              );
              await chatRoomViewModel.createChatDocument(chatModel);

              // TODO: 만남권 소진 로직 추가 이후 작성
              // Ticket 관련 로직 추가 (사용 가능 횟수 감소)
              // 2-1) 나간 사람의 만남권 횟수가 남은 경우
              // 2-2) 나간 사람의 만남권 횟수가 없는 경우

              // 채팅 방 나가기
              while (context.canPop()) {
                context.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
