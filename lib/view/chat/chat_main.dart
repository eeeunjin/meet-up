import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
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

  // MARK: - 내가 만든 방 / 다른 사람이 만든 방 테스트
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
              var decodedRoomModel =
                  chatViewModel.decodingRoomModel(roomModel: roomModel);
              return ListTile(
                title: Text(decodedRoomModel.room_name),
                subtitle: Text(decodedRoomModel.room_age.firstOrNull),
              );
            },
          );
        }
      },
    );
  }

  // MARK: - 다른 사람이 만든 방 테스트 필터 테스트
  Widget _filterTest(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      // 내가 만든 방을 제외한 다른 사람의 방
      stream:
          chatViewModel.getOthersRoomModelByFilter(myUid: userViewModel.uid!),
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
              var decodedRoomModel = chatViewModel.decodingRoomModel(
                roomModel: roomModel,
              );
              return ListTile(
                title: Text(decodedRoomModel.room_name),
                subtitle: Text(decodedRoomModel.room_age.firstOrNull),
              );
            },
          );
        }
      },
    );
  }

  // MARK: - 다른 사람이 만든 방 상세 정보 출력 테스트
  Widget _detailInfoTest(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
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
              var decodeRoomModel = chatViewModel.decodingRoomModel(
                roomModel: roomModel,
              );
              List<DocumentReference> participantDocRefs =
                  List.empty(growable: true);
              participantDocRefs.add(decodeRoomModel.room_owner_reference);
              for (DocumentReference docRef
                  in decodeRoomModel.room_participant_reference) {
                participantDocRefs.add(docRef);
              }

              // 항목을 누르면 참가자 정보가 나오도록 하는 위젯
              return GestureDetector(
                onTap: () {
                  chatViewModel.getParticipantInfo(docRefs: participantDocRefs);
                },
                child: ListTile(
                  title: Text(decodeRoomModel.room_name),
                  subtitle: Text(decodeRoomModel.room_category),
                ),
              );
            },
          );
        }
      },
    );
  }

  // MARK: - 방 입장 요청 테스트
  Widget _sendRoomEnterRequestTest(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
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
              var decodedRoomModel = chatViewModel.decodingRoomModel(
                roomModel: roomModel,
              );
              var roomDocRef =
                  snapshot.data!.docs[index].reference.path.split("/").last;

              return GestureDetector(
                onTap: () {
                  chatViewModel.sendRoomEnterRequest(
                    myUid: userViewModel.uid!,
                    roomModel: decodedRoomModel,
                    roomId: roomDocRef,
                  );
                },
                child: ListTile(
                  title: Text(decodedRoomModel.room_name),
                  subtitle: Text(decodedRoomModel.room_age.firstOrNull),
                ),
              );
            },
          );
        }
      },
    );
  }
}
