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
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/meet/meet_browse_view_model.dart';
import 'package:meet_up/view_model/meet/meet_detail_room_view_model.dart';
import 'package:meet_up/view_model/meet/meet_filter_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class MeetBrowseMain extends StatelessWidget {
  const MeetBrowseMain({super.key});

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
          // _main(context),
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
            title: '만남 방 둘러보기',
          ),
          SizedBox(
            height: 16.h,
          ),
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
          width: 10.w,
          height: 20.h,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      thickness: 0.3.h,
      height: 0.h,
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
    final meetBrowseViewModel = Provider.of<MeetBrowseViewModel>(context);
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
              controller: meetBrowseViewModel.searchTextEditingControlller,
              onSubmitted: (String text) {
                meetBrowseViewModel.submitSearchTextEditingControlller();
              },
              decoration: InputDecoration(
                hintText: '만남방의 이름을 검색해 보세요.',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintStyle:
                    AppTextStyles.SU_R_14.copyWith(color: UsedColor.text_3),
                isDense: true,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (meetBrowseViewModel.searchTextEditingControlller.text != "") {
                meetBrowseViewModel.searchTextEditingControlller.clear();
                meetBrowseViewModel.submitSearchTextEditingControlller();
              }
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
      child: Consumer2<MeetBrowseViewModel, MeetFilterViewModel>(
          builder: (context, meetBrowseViewModel, meetFilterViewModel, child) {
        List<Widget> filterWidgets = [
          _filterButton(
            context,
            onTap: () {
              if (meetBrowseViewModel.selectedFilters.isNotEmpty) {
                meetFilterViewModel.clearAllFilters();
                meetBrowseViewModel.clearSelectedFilters();
              } else {
                context.goNamed('meetFilterMain');
              }
            },
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  meetBrowseViewModel.selectedFilters.isNotEmpty
                      ? '초기화'
                      : '필터 설정',
                  style:
                      AppTextStyles.PR_M_12.copyWith(color: UsedColor.text_2),
                ),
                SizedBox(width: 5.w),
                Image.asset(
                  meetBrowseViewModel.selectedFilters.isNotEmpty
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

        for (var filter in meetBrowseViewModel.selectedFilters) {
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
    final meetFilterViewModel =
        Provider.of<MeetFilterViewModel>(context, listen: false);
    final meetBrowseViewModel = Provider.of<MeetBrowseViewModel>(context);
    final meetDetailRoomViewModel =
        Provider.of<MeetDetailRoomViewModel>(context);
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: !meetBrowseViewModel.isFilterApplied
          ? meetBrowseViewModel.getOthersRoomModel(myUid: userViewModel.uid!)
          : meetBrowseViewModel.getOthersRoomModelByFilter(
              myUid: userViewModel.uid!,
              filterInfo: meetFilterViewModel.getFilterInfo(),
            ),
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
              room.roomId = doc.id;
              return room;
            }).toList() ??
            [];

        rooms.sort(
          (a, b) {
            return b.room_creation_date.compareTo(a.room_creation_date);
          },
        );

        if (meetBrowseViewModel.searchTextEditingControlller.text != "") {
          rooms.removeWhere((element) => !element.room_name
              .contains(meetBrowseViewModel.searchTextEditingControlller.text));
        }

        if (rooms.isEmpty && !meetBrowseViewModel.isFilterApplied) {
          return Center(
            child: Text(
              "생성된 만남 방이 없습니다.",
              style: AppTextStyles.PR_R_16.copyWith(
                color: UsedColor.text_2,
              ),
            ),
          );
        } else if (rooms.isEmpty && meetBrowseViewModel.isFilterApplied) {
          return Center(
            child: Text(
              "조건에 맞는 만남 방이 없습니다.",
              style: AppTextStyles.PR_R_16.copyWith(
                color: UsedColor.text_2,
              ),
            ),
          );
        }
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
                meetDetailRoomViewModel.setCurrentRoomModel(roomModel: room);
                meetDetailRoomViewModel.setIsMyRoom(isMyRoom: false);
                logger.d(
                    "room category: ${room.room_category} && room sub Category : ${room.room_category_detail}");
                context.goNamed('meetDetailRoom_browse');
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
                            height: 17.h,
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
                              SizedBox(
                                width: 235.w,
                                child: Text(
                                  '#${room.room_keyword.join(' #')}', // 키워드
                                  style: AppTextStyles.SU_L_12
                                      .copyWith(color: UsedColor.main),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${DateFormat('yyyy.MM.dd').format(room.room_creation_date.toDate().add(const Duration(days: 7)))} 만료',
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
