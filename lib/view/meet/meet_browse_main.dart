import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view/widget/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_browse_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class MeetBrowseMain extends StatelessWidget {
  const MeetBrowseMain({super.key});

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
                  top: 15.h,
                ),
                child: _header(context),
              ),
            Expanded(child: _main(context)),
            // _main(context),
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
          header(back: _back(context), title: '만남방 둘러보기'),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 9.h),
      child: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Image.asset(
          ImagePath.back,
          width: 40.w,
          height: 40.h,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 0.91.h,
      color: const Color(0xffd9d9d9),
    );
  }

  Widget _main(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 29.h),
          _search(context),
          SizedBox(height: 22.h),
          _filter(context),
          SizedBox(height: 22.h),
          _divider(),
          Expanded(
            child: Container(
              color: UsedColor.bg_color, // 원하는 배경색으로 변경
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 19.w),
                child: _meetingRoom(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _search(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Container(
      width: 352.w,
      height: 37.h,
      decoration: BoxDecoration(
        color: UsedColor.bg_color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          SizedBox(width: 20.w),
          Image.asset(
            ImagePath.search,
            width: 19.w,
            height: 19.h,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: TextField(
              style: AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
              controller: controller,
              decoration: InputDecoration(
                hintText: '만남방의 이름을 검색해 보세요.',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintStyle:
                    AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
              ),
              onChanged: (value) {},
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.clear();
            },
            child: Image.asset(
              ImagePath.close,
              width: 20.w,
              height: 20.h,
            ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }

  Widget _filter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0.w),
      child:
          Consumer<MeetBrowseViewModel>(builder: (context, viewModel, child) {
        List<Widget> filterWidgets = [
          _filterButton(
            context,
            onTap: () {
              if (viewModel.selectedFilters.isNotEmpty) {
                viewModel.clearAllFilters();
              } else {
                context.goNamed('meetFilterMain');
              }
            },
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  viewModel.selectedFilters.isNotEmpty ? '초기화' : '필터 설정',
                  style:
                      AppTextStyles.PR_M_12.copyWith(color: UsedColor.text_2),
                ),
                SizedBox(width: 5.w),
                Image.asset(
                  viewModel.selectedFilters.isNotEmpty
                      ? ImagePath.resetIcon
                      : ImagePath.filterIcon,
                  width: 14.w,
                  height: 11.h,
                ),
              ],
            ),
            borderColor: UsedColor.button_g,
            backgroundColor: Colors.white,
          ),
        ];

        for (var filter in viewModel.selectedFilters) {
          filterWidgets.add(SizedBox(width: 4.0.w));
          filterWidgets.add(
            _filterContainer(
              context,
              filter,
              UsedColor.b_line,
              UsedColor.image_card,
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: (MediaQuery.of(context).size.width) *
                    1.5.w, // 지정안하면 스크롤 오버플로우 오류남
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: filterWidgets,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _filterButton(BuildContext context,
      {required Widget content,
      required Color borderColor,
      required Color backgroundColor,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(width: 1.5.w, color: borderColor),
          color: backgroundColor,
        ),
        child: content,
      ),
    );
  }

  Widget _filterContainer(BuildContext context, String filterText,
      Color borderColor, Color backgroundColor) {
    return Container(
      height: 34.h,
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(width: 1.5.w, color: borderColor),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            filterText,
            style: AppTextStyles.PR_M_12.copyWith(color: UsedColor.violet),
          ),
        ],
      ),
    );
  }

  Widget _meetingRoom(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final meetBrowseViewModel = Provider.of<MeetBrowseViewModel>(context);
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: !meetBrowseViewModel.isAnyFilterSelected
          ? meetBrowseViewModel.getOthersRoomModel(myUid: userViewModel.uid!)
          : meetBrowseViewModel.getOthersRoomModelByFilter(
              myUid: userViewModel.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error loading rooms: ${snapshot.error.toString()}'));
        }
        List<RoomModel> rooms = snapshot.data?.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              RoomModel room = RoomModel.fromJson(data);
              room = meetBrowseViewModel.decodingRoomModel(roomModel: room);
              return room;
            }).toList() ??
            [];

        return ListView.builder(
          itemCount: rooms.length,
          padding: EdgeInsets.only(
            top: 20.h,
            bottom: 20.h,
          ),
          itemBuilder: (context, index) {
            final RoomModel room = rooms[index];
            return GestureDetector(
              onTap: () {
                context.goNamed('meetDetailRoom');
              },
              child: Container(
                height: 124.h,
                width: 355.w,
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: 355.w,
                    height: 108.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 18.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      room.room_name, // 방 명
                                      style: AppTextStyles.PR_SB_17.copyWith(
                                          color: UsedColor.charcoal_black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 11.w),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${room.room_participant_reference.length + 1}',
                                            style: AppTextStyles.PR_B_12
                                                .copyWith(
                                                    color: UsedColor.violet),
                                          ),
                                          TextSpan(
                                            text: '/4명',
                                            style: AppTextStyles.PR_M_12
                                                .copyWith(
                                                    color: UsedColor.text_3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            room.room_description, // 방 설명
                            style: AppTextStyles.PR_R_12
                                .copyWith(color: UsedColor.text_3),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '#${room.room_keyword.join(' #')}', // 키워드
                                style: AppTextStyles.SU_L_12
                                    .copyWith(color: UsedColor.main),
                              ),
                              Text(
                                '${DateFormat('yyyy.MM.dd').format(room.room_creation_date.toDate())} 생성',
                                style: AppTextStyles.SU_R_10
                                    .copyWith(color: UsedColor.text_5),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: 17.h,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
