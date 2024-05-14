import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/coin_widget.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_manage_view_model.dart';
import 'package:meet_up/view_model/meet/meet_detail_room_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class MeetManageMain extends StatelessWidget {
  const MeetManageMain({super.key});

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
          Expanded(
            child: _main(context),
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
          header(
            back: _back(context),
            title: '내가 만든 만남방',
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

  Widget _main(BuildContext context) {
    final meetViewModel =
        Provider.of<MeetManageViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: meetViewModel.getMyRoomModel(myUid: userViewModel.uid!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          logger.e(snapshot.error);
          return const Text("DB Load Error");
        } else if (!snapshot.hasData) {
          // 생성된 방 없을 때
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // 정렬
          var docs = snapshot.data!.docs;
          return Container(
            color: UsedColor.bg_color,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 19.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 31.h),
                    _title(context, docs),
                    if (docs.isEmpty) ...[
                      SizedBox(
                        height: 293.h,
                      ),
                      _emptyRoom(),
                    ],
                    if (docs.isNotEmpty) ...[
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.only(right: 19.0.w),
                        child: _rooms(context, docs),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _title(
    BuildContext context,
    List<QueryDocumentSnapshot<Object?>> docs,
  ) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.0.w, right: 8.w),
          child: Text(
            '만남방 관리',
            style: AppTextStyles.PR_SB_22,
          ),
        ),
        // 방 개수
        Padding(
          padding: EdgeInsets.only(top: 2.0.h),
          child: Text(
            '${docs.length} 개',
            style: AppTextStyles.SU_SB_16.copyWith(color: UsedColor.text_3),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(right: 18.0.w),
          child: GestureDetector(
            onTap: () {
              context.goNamed('coinMainFromMeetManageMain');
            },
            child: CoinWidget(
              coinAmount: userViewModel.userModel!.coin,
              ticketAmount: userViewModel.userModel!.ticket,
              isFixed: userViewModel.userModel!.isFixedTicket,
            ),
          ),
        ),
      ],
    );
  }

  Widget _rooms(
    BuildContext context,
    List<QueryDocumentSnapshot<Object?>> docs,
  ) {
    final meetDetailRoomViewModel =
        Provider.of<MeetDetailRoomViewModel>(context, listen: false);

    // 날짜로 그룹화
    Map<String, List<DocumentSnapshot>> groupedByDate = {};
    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      var timestamp = data['room_creation_date'] as Timestamp?;
      if (timestamp != null) {
        var date = timestamp.toDate();
        String formattedDate = DateFormat('yyyy.MM.dd').format(date);
        groupedByDate[formattedDate] ??= [];
        groupedByDate[formattedDate]!.add(doc);
      }
    }
    // MARK: - 방 리스트
    // 그룹화된 데이터를 기반으로 위젯 구성
    List<Widget> dateSections = [];
    groupedByDate.forEach((date, rooms) {
      dateSections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.w, bottom: 12.h),
              child: Text(
                date,
                style: AppTextStyles.SU_R_12.copyWith(color: UsedColor.text_4),
              ),
            ),
            Column(
              children: rooms.map((room) {
                var roomData = room.data() as Map<String, dynamic>;
                var roomModel = RoomModel.fromJson(roomData);
                roomModel.roomId = room.id;
                logger.d("${roomModel.room_name}의 room id는 [${room.id}] 입니다 ~");

                // 개별 컨테이너
                return GestureDetector(
                  onTap: () {
                    meetDetailRoomViewModel.setCurrentRoomModel(
                        roomModel: roomModel);
                    meetDetailRoomViewModel.setIsMyRoom(isMyRoom: true);
                    context.goNamed('meetDetailRoom_manage');
                  },
                  child: Container(
                    width: 355.w,
                    height: 85.h,
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 21.w, top: 19.h),
                      // title & 인원 수
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(roomModel.room_name,
                                  style: AppTextStyles.PR_SB_16),
                              SizedBox(width: 10.w),
                              Padding(
                                padding: EdgeInsets.only(bottom: 3.0.h),
                                child: Text(
                                  '1',
                                  style: AppTextStyles.PR_SB_10
                                      .copyWith(color: UsedColor.violet),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 3.0.h),
                                child: Text(
                                  '/4명',
                                  style: AppTextStyles.PR_SB_10
                                      .copyWith(color: UsedColor.text_4),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          // detail
                          Text(
                            roomModel.room_description,
                            style: AppTextStyles.PR_R_12
                                .copyWith(color: UsedColor.text_5),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 48.h),
          ],
        ),
      );
    });

    return SingleChildScrollView(
      child: Column(
        children: dateSections,
      ),
    );
  }

  Widget _emptyRoom() {
    return Center(
      child: Text(
        '생성된 만남 방이 없습니다.',
        style: AppTextStyles.PR_R_16.copyWith(color: UsedColor.text_2),
      ),
    );
  }
}
