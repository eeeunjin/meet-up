import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/view_model/chat/chat_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ChatMain extends StatelessWidget {
  const ChatMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (Platform.isIOS)
              _header(context)
            else if (Platform.isAndroid)
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

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // header(title: '채팅', back: null),
          Text(
            '채팅',
            style: AppTextStyles.SU_R_20.copyWith(color: UsedColor.text_3),
          ),
          SizedBox(
            height: 16.h,
          ),
          Divider(
            height: 0.3.h,
            color: UsedColor.line,
          ),
        ],
      ),
    );
  }

  // main
  Widget _main(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      // 내가 만든 방
      // stream: chatViewModel.getMyRoomModel(myUid: userViewModel.uid!),

      // 내가 만든 방을 제외한 다른 사람의 방
      stream: chatViewModel.getOthersRoomModel(myUid: userViewModel.uid!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Text("DB Load Error");
        } else if (!snapshot.hasData) {
          return const Text("Has No Data");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print(snapshot.data!.docs.length);
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // 데이터를 사용하여 원하는 UI를 생성합니다.
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var roomModel = RoomModel.fromJson(data);
              return ListTile(
                title: Text(roomModel.room_name),
                subtitle: Text(roomModel.room_category),
              );
            },
          );
        }
      },
    );
  }
}
