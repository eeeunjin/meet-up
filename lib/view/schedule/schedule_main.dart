import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/bot_nav_view_model.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/schedule/schedule_add_personal_schdule_view_model.dart';
import 'package:meet_up/view_model/schedule/schedule_main_view_model.dart';
import 'package:meet_up/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class ScheduleMain extends StatelessWidget {
  const ScheduleMain({super.key});

  // MARK: - build
  @override
  Widget build(BuildContext context) {
    final scheduleMainViewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: scheduleMainViewModel.getMyScheduleStream(userViewModel.uid!),
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
          List<RoomModel> mySchedules = snapshot.data?.docs.map(
                (e) {
                  return RoomModel.fromJson(e.data() as Map<String, dynamic>);
                },
              ).toList() ??
              [];

          scheduleMainViewModel.setScheduleList(mySchedules);

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
            // 개인 일정 추가 플로팅액션 버튼
            floatingActionButton: _buildFloatingActionButton(context),
          );
        }
      },
    );
  }

  // MARK: - header
  Widget _header(BuildContext context) {
    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        final currentPart = viewModel.selectedPart;
        bool isInDetail = false;
        if (currentPart == SelectedPart.meetUp) {
          isInDetail = viewModel.selectedMeetUpScheduleDetail != null;
        } else {
          isInDetail = viewModel.selectedPersonalScheduleDetail != null;
        }

        return Center(
          child: Column(
            children: [
              isInDetail
                  ? header(title: '일정', back: _back(context))
                  : header(title: '일정', back: null),
              SizedBox(height: 30.h),
              _meetPart(),
            ],
          ),
        );
      },
    );
  }

  // MARK: - back
  Widget _back(BuildContext context) {
    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        final currentPart = viewModel.selectedPart;
        bool isInDetail = false;
        if (currentPart == SelectedPart.meetUp) {
          isInDetail = viewModel.selectedMeetUpScheduleDetail != null;
        } else {
          isInDetail = viewModel.selectedPersonalScheduleDetail != null;
        }

        // 스케줄이 선택된 경우에만 뒤로가기 버튼을 표시
        if (isInDetail) {
          return GestureDetector(
            onTap: () {
              if (currentPart == SelectedPart.meetUp) {
                viewModel.resetScheduleSelection('meetUp');
              } else {
                viewModel.resetScheduleSelection('personal');
              }
            },
            child: Image.asset(
              ImagePath.back,
              width: 10.w,
              height: 20.h,
            ),
          );
        } else {
          // 스케줄이 선택되지 않았을 경우 빈 위젯을 반환
          return const SizedBox.shrink();
        }
      },
    );
  }

  // MARK: - 파트 선택
  Widget _meetPart() {
    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        return Row(
          children: [
            _selectedPart(
              title: '밋업 만남',
              isSelected: viewModel.selectedPart == SelectedPart.meetUp,
              onTap: () => viewModel.selectMeetUp(),
            ),
            _selectedPart(
              title: '개인 만남',
              isSelected: viewModel.selectedPart == SelectedPart.personal,
              onTap: () => viewModel.selectPersonal(),
            ),
          ],
        );
      },
    );
  }

  // MARK: - 파트 선택 위젯
  Widget _selectedPart({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.PR_M_17.copyWith(
                  color:
                      isSelected ? UsedColor.violet : UsedColor.charcoal_black),
            ),
            SizedBox(height: 11.h),
            Container(
              height: 3.h,
              color:
                  isSelected ? UsedColor.progress_bar : UsedColor.progress_bar2,
            )
          ],
        ),
      ),
    );
  }

  // MARK: - 플로팅 액션 버튼
  Widget _buildFloatingActionButton(BuildContext context) {
    return Consumer<ScheduleMainViewModel>(
        builder: (context, viewModel, child) {
      // 개인 만남이 선택 되었을 때
      if (viewModel.selectedPart == SelectedPart.personal &&
          viewModel.selectedPersonalScheduleDetail == null) {
        return FloatingActionButton(
          heroTag: null, // 고유 태그 지정 - hero오류
          onPressed: () {
            context.goNamed('addPersonalSchedule');
          },
          backgroundColor: Colors.black,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        );
      } else {
        return Container();
      }
    });
  }

  // MARK: - 메인
  Widget _main(BuildContext context) {
    final viewModel = Provider.of<ScheduleMainViewModel>(context, listen: true);

    if (viewModel.selectedPart == SelectedPart.meetUp) {
      return _meetUpView(context);
    } else {
      return _personalView(
        context,
      );
    }
  }

  // MARK: - 밋업 만남 뷰
  Widget _meetUpView(BuildContext context) {
    final scheduleMainViewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);
    final botNavViewModel =
        Provider.of<BottomNavigationBarViewModel>(context, listen: false);

    if (scheduleMainViewModel.selectedMeetUpScheduleDetail == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        botNavViewModel.setIsHidden(false);
      });
      // 선택된 스케줄이 없을 때, 기본 일정 리스트 뷰를 보여줍니다.
      return _meetUpScheduleListView(context);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        botNavViewModel.setIsHidden(true);
      });
      // 선택된 스케줄이 있을 때, 상세 정보를 보여줍니다.
      return _meetUpScheduleDetailView(context);
    }
  }

  // MARK: - 밋업 일정 리스트
  Widget _meetUpScheduleListView(BuildContext context) {
    final scheduleMainViewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);
    final isScheduleExist = scheduleMainViewModel.scheduleList != null &&
        scheduleMainViewModel.scheduleList!.isNotEmpty;
    final isMeetUpScheduleExist = isScheduleExist
        ? scheduleMainViewModel.getMeetUpScheduleByDate().isNotEmpty
        : false;

    if (!isMeetUpScheduleExist) {
      return Container(
        width: double.infinity,
        color: UsedColor.bg_color,
        child: Center(
          child: Text(
            '일정이 없습니다.',
            style: AppTextStyles.PR_R_16.copyWith(
              color: UsedColor.text_2,
            ),
          ),
        ),
      );
    } else {
      final scheduleMap = scheduleMainViewModel.getMeetUpScheduleByDate();
      // 최신 순으로 정렬
      final dates = scheduleMap.keys.toList()..sort((a, b) => a.compareTo(b));

      return Container(
        width: double.infinity,
        color: UsedColor.bg_color,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 39.h),
              ...dates.map(
                (date) {
                  return _scheduleContainer(context, date, 'meetUp');
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  // MARK: - 밋업 일정 디테일 뷰
  Widget _meetUpScheduleDetailView(BuildContext context) {
    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        final title =
            viewModel.selectedMeetUpScheduleDetail!.room_schedule!['title'];
        final location =
            viewModel.selectedMeetUpScheduleDetail!.room_schedule!['location'];
        // 한국 기준 날짜 및 시간 포맷
        final dateFormatter = DateFormat('yyyy.MM.dd. EEEE', 'ko_KR');
        final timeFormatter = DateFormat('a h시 mm분', 'ko_KR');
        DateTime scheduleDate = viewModel
            .selectedMeetUpScheduleDetail!.room_schedule!['date']
            .toDate();
        String date = dateFormatter.format(scheduleDate);
        String time = timeFormatter
            .format(scheduleDate)
            .replaceFirst('AM', '오전')
            .replaceFirst('PM', '오후');

        String content =
            viewModel.selectedMeetUpScheduleDetail!.room_description;

        return Container(
          width: double.infinity,
          color: UsedColor.bg_color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.w, right: 26.w),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        // 일정 제목
                        Text(
                          title,
                          style: AppTextStyles.PR_SB_20
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    Container(
                      width: 340.w,
                      height: 110.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 20.h,
                              left: 24.w,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: UsedColor.main),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '날짜',
                                      style: AppTextStyles.PR_SB_12
                                          .copyWith(color: Colors.black),
                                    ),
                                    SizedBox(width: 31.w),
                                    Text(
                                      date,
                                      style: AppTextStyles.PR_R_12
                                          .copyWith(color: UsedColor.text_3),
                                    )
                                  ],
                                ),
                                SizedBox(height: 14.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: UsedColor.main),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '시간',
                                      style: AppTextStyles.PR_SB_12
                                          .copyWith(color: Colors.black),
                                    ),
                                    SizedBox(width: 31.w),
                                    Text(
                                      time,
                                      style: AppTextStyles.PR_R_12
                                          .copyWith(color: UsedColor.text_3),
                                    )
                                  ],
                                ),
                                SizedBox(height: 14.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: UsedColor.main),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '장소',
                                      style: AppTextStyles.PR_SB_12
                                          .copyWith(color: Colors.black),
                                    ),
                                    SizedBox(width: 31.w),
                                    Text(
                                      location,
                                      style: AppTextStyles.PR_R_12
                                          .copyWith(color: UsedColor.text_3),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Container(
                      width: 340.w,
                      height: 84.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 20.h,
                              left: 24.w,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: UsedColor.main),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '설명',
                                      style: AppTextStyles.PR_SB_12
                                          .copyWith(color: Colors.black),
                                    ),
                                    SizedBox(width: 31.w),
                                    Text(
                                      content,
                                      style: AppTextStyles.PR_R_12
                                          .copyWith(color: UsedColor.text_3),
                                    )
                                  ],
                                ),
                                SizedBox(height: 14.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: UsedColor.main),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '참여',
                                      style: AppTextStyles.PR_SB_12
                                          .copyWith(color: Colors.black),
                                    ),
                                    SizedBox(width: 31.w),
                                    // 참여자 리스트
                                    FutureBuilder(
                                      future: viewModel.getParticipantInfo(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container();
                                        } else {
                                          final participantList =
                                              snapshot.data as List<UserModel>;
                                          return Row(
                                            children: participantList
                                                .map(
                                                  (user) => Row(
                                                    children: [
                                                      Wrap(
                                                        children: [
                                                          Container(
                                                            width: 45.w,
                                                            height: 18.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: UsedColor
                                                                  .image_card,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.5.r),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                user.nickname,
                                                                style: AppTextStyles
                                                                    .SU_M_10
                                                                    .copyWith(
                                                                        color: UsedColor
                                                                            .violet),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(width: 8.w),
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // MARK: - 개인 만남 뷰
  Widget _personalView(BuildContext context) {
    final scheduleMainViewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);
    final botNavViewModel =
        Provider.of<BottomNavigationBarViewModel>(context, listen: false);

    if (scheduleMainViewModel.selectedPersonalScheduleDetail == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        botNavViewModel.setIsHidden(false);
      });
      // 선택된 스케줄이 없을 때, 기본 일정 리스트 뷰를 보여줍니다.
      return _personalScheduleListView(context);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        botNavViewModel.setIsHidden(true);
      });
      // 선택된 스케줄이 있을 때, 상세 정보를 보여줍니다.
      return _personalScheduleDetailView(context);
    }
  }

  // MARK: - 개인 일정 리스트
  Widget _personalScheduleListView(BuildContext context) {
    final scheduleMainViewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);
    final isScheduleExist = scheduleMainViewModel.scheduleList != null &&
        scheduleMainViewModel.scheduleList!.isNotEmpty;
    final isPersonalScheduleExist = isScheduleExist
        ? scheduleMainViewModel.getPersonalScheduleByDate().isNotEmpty
        : false;

    if (!isPersonalScheduleExist) {
      return Container(
        width: double.infinity,
        color: UsedColor.bg_color,
        child: Center(
          child: Text(
            '일정이 없습니다.',
            style: AppTextStyles.PR_R_16.copyWith(
              color: UsedColor.text_2,
            ),
          ),
        ),
      );
    } else {
      final scheduleMap = scheduleMainViewModel.getPersonalScheduleByDate();
      // 최신 순으로 정렬
      final dates = scheduleMap.keys.toList()..sort((a, b) => a.compareTo(b));

      return Container(
        width: double.infinity,
        color: UsedColor.bg_color,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 39.h),
              ...dates.map((date) {
                return _scheduleContainer(context, date, 'personal');
              }),
            ],
          ),
        ),
      );
    }
  }

  // MARK: - 개인 일정 디테일 뷰
  Widget _personalScheduleDetailView(BuildContext context) {
    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        final title =
            viewModel.selectedPersonalScheduleDetail!.room_schedule!['title'];
        final location = viewModel
            .selectedPersonalScheduleDetail!.room_schedule!['location'];
        // 한국 기준 날짜 및 시간 포맷
        final dateFormatter = DateFormat('yyyy.MM.dd. EEEE', 'ko_KR');
        final timeFormatter = DateFormat('a h시 mm분', 'ko_KR');
        DateTime scheduleDate = viewModel
            .selectedPersonalScheduleDetail!.room_schedule!['date']
            .toDate();
        String date = dateFormatter.format(scheduleDate);
        String time = timeFormatter
            .format(scheduleDate)
            .replaceFirst('AM', '오전')
            .replaceFirst('PM', '오후');

        String content =
            viewModel.selectedPersonalScheduleDetail!.room_description;

        List<dynamic> memberList = viewModel
            .selectedPersonalScheduleDetail!.room_participant_reference;

        return Container(
          height: double.infinity,
          width: double.infinity,
          color: UsedColor.bg_color,
          child: Column(
            children: [
              SizedBox(height: 32.h),
              Row(
                children: [
                  // 일정 제목
                  SizedBox(
                    width: 30.w,
                  ),
                  Text(
                    title,
                    style: AppTextStyles.PR_SB_20.copyWith(color: Colors.black),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {
                      // 편집
                      final scheduleAddPersonalScheduleViewModel =
                          Provider.of<ScheduleAddPersonalScheduleViewModel>(
                              context,
                              listen: false);
                      scheduleAddPersonalScheduleViewModel.loadExistingData(
                          viewModel.selectedPersonalScheduleDetail!);
                      context.goNamed('editPersonalSchedule');
                    },
                    child: Image.asset(
                      ImagePath.editPencil,
                      width: 19.w,
                      height: 19.h,
                    ),
                  )
                ],
              ),
              SizedBox(height: 28.h),
              Container(
                width: 340.w,
                height: 110.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20.h,
                        left: 24.w,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: UsedColor.main),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                '날짜',
                                style: AppTextStyles.PR_SB_12
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(width: 31.w),
                              Text(
                                date,
                                style: AppTextStyles.PR_R_12
                                    .copyWith(color: UsedColor.text_3),
                              )
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: UsedColor.main),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                '시간',
                                style: AppTextStyles.PR_SB_12
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(width: 31.w),
                              Text(
                                time,
                                style: AppTextStyles.PR_R_12
                                    .copyWith(color: UsedColor.text_3),
                              )
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: UsedColor.main),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                '장소',
                                style: AppTextStyles.PR_SB_12
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(width: 31.w),
                              Text(
                                location,
                                style: AppTextStyles.PR_R_12
                                    .copyWith(color: UsedColor.text_3),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              Container(
                width: 340.w,
                height: 84.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20.h,
                    left: 24.w,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: UsedColor.main),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            '설명',
                            style: AppTextStyles.PR_SB_12
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(width: 31.w),
                          Text(
                            content,
                            style: AppTextStyles.PR_R_12
                                .copyWith(color: UsedColor.text_3),
                          )
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: UsedColor.main),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            '참여',
                            style: AppTextStyles.PR_SB_12
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(width: 31.w),
                          // 참여자 리스트
                          Row(
                            children: memberList
                                .map(
                                  (member) => Row(
                                    children: [
                                      Wrap(
                                        children: [
                                          Container(
                                            width: 45.w,
                                            height: 18.h,
                                            decoration: BoxDecoration(
                                              color: UsedColor.image_card,
                                              borderRadius:
                                                  BorderRadius.circular(8.5.r),
                                            ),
                                            child: Center(
                                              child: Text(
                                                member,
                                                style: AppTextStyles.SU_M_10
                                                    .copyWith(
                                                        color:
                                                            UsedColor.violet),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 8.w),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // 삭제버튼
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  // TODO: 삭제 기능 구현
                  // AlertDialog로 삭제 여부 확인
                  _showDeleteDialog(context);
                },
                child: Container(
                  width: 327.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19.r),
                      color: Colors.black),
                  child: Center(
                    child: Text(
                      '삭제',
                      style:
                          AppTextStyles.PR_SB_20.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 56.h),
            ],
          ),
        );
      },
    );
  }

  // MARK: - 삭제 다이얼로그
  void _showDeleteDialog(BuildContext context) {
    final scheduleMainViewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            width: 245.w,
            height: 109.h,
            padding: EdgeInsets.only(
              top: 19.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '해당 일정을 삭제하시겠습니까?',
                  style: AppTextStyles.PR_M_13.copyWith(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  '삭제한 일정은 다시 복구할 수 없습니다.',
                  style: AppTextStyles.PR_R_12.copyWith(
                    color: UsedColor.line,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Divider(thickness: 0.5.h, height: 0.h, color: UsedColor.line),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 9.h),
                          child: Center(
                            child: Text(
                              '취소',
                              style: AppTextStyles.PR_M_14.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 0.5.w,
                      height: 35.h,
                      color: UsedColor.line,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          // 삭제

                          // 해당 일정 삭제
                          await scheduleMainViewModel.deletePersonalSchedule(
                              userViewModel.uid!,
                              scheduleMainViewModel
                                  .selectedPersonalScheduleDetail!.room_name);

                          // 다이얼로그 닫기
                          context.pop();

                          // 뒤로 돌아가기
                          scheduleMainViewModel
                              .resetScheduleSelection('personal');
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 9.h),
                          child: Center(
                            child: Text(
                              '삭제',
                              style: AppTextStyles.PR_M_14.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // MARK: - 일정 컨테이너
  Widget _scheduleContainer(BuildContext context, String date, String type) {
    final scheduleMainViewModel =
        Provider.of<ScheduleMainViewModel>(context, listen: false);

    // scheduleMap에서 해당 날짜에 대한 정보 가져오기
    final scheduleMap = (type == 'meetUp')
        ? scheduleMainViewModel.getMeetUpScheduleByDate()
        : scheduleMainViewModel.getPersonalScheduleByDate();

    List<RoomModel> scheduleDetails = scheduleMap[date]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜
              Text(
                date,
                style: AppTextStyles.SU_R_12.copyWith(color: UsedColor.text_3),
              ),
              SizedBox(height: 12.h),
              Column(
                children: scheduleDetails.map((detail) {
                  // 개별 시간 및 장소 정보 표시
                  String title = detail.room_schedule!['title'];
                  String location = detail.room_schedule!['location'];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h), // 간격 임시 값
                    child: GestureDetector(
                      onTap: () {
                        // 컨테이너 선택 시
                        scheduleMainViewModel.selectSchedule(detail, type);
                      },
                      child: Container(
                        width: 355.w,
                        height: 85.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 18.h),
                              Text(
                                title,
                                style: AppTextStyles.PR_SB_17
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(height: 12.24.h),
                              Row(
                                children: [
                                  // 시간
                                  Row(
                                    children: [
                                      Container(
                                        width: 7.w,
                                        height: 7.h,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: UsedColor.main),
                                      ),
                                      SizedBox(width: 13.w),
                                      Text(date,
                                          style: AppTextStyles.PR_R_12.copyWith(
                                              color: UsedColor.text_5)),
                                    ],
                                  ),
                                  SizedBox(width: 24.w),
                                  // 장소
                                  Row(
                                    children: [
                                      Container(
                                        width: 7.w,
                                        height: 7.h,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: UsedColor.main),
                                      ),
                                      SizedBox(width: 13.w),
                                      Text(location,
                                          style: AppTextStyles.PR_R_12.copyWith(
                                              color: UsedColor.text_5)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.24.h),
            ],
          ),
        ),
      ],
    );
  }
}
