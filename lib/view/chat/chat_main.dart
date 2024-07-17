import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/service/remote/service_test.dart';
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

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    reverse: false,
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
                                snapshot.data!.data() as Map<String, dynamic>);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 80.h,
                                  width: 345.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      roomModel.room_name,
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
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
