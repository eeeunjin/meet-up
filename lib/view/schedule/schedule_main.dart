import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/util/color.dart';
import 'package:meet_up/util/font.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/meet/header_widget.dart';
import 'package:meet_up/view_model/schedule/schedule_main_view_model.dart';
import 'package:provider/provider.dart';

class ScheduleMain extends StatelessWidget {
  ScheduleMain({super.key});

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
      // 개인 일정 추가 플로팅액션 버튼
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  // header
  Widget _header(BuildContext context) {
    return Center(
      child: Column(
        children: [
          header(title: '일정', back: _back(context)),
          SizedBox(
            height: 30.h,
          ),
          _meetPart(),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) {
    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        // 스케줄이 선택된 경우에만 뒤로가기 버튼을 표시
        if (viewModel.selectedScheduleDetail != null) {
          return GestureDetector(
            onTap: () {
              // ViewModel의 resetScheduleSelection()을 호출하여 리스트로 돌아가기
              viewModel.resetScheduleSelection();
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

  // 파트 선택
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

  // 파트 선택 위젯
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
      if (viewModel.selectedPart == SelectedPart.personal) {
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

  Widget _main(BuildContext context) {
    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.selectedPart == SelectedPart.meetUp) {
          return _meetUpView(context);
        } else {
          return _personalView(
            context,
          );
        }
      },
    );
  }

  // 밋업 만남 뷰
  Widget _meetUpView(BuildContext context) {
    return Container(
      width: double.infinity,
      color: UsedColor.bg_color,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 39.h),
            ...meetUpScheduleMap.keys.map((date) {
              return _schedulesPersonal(context, date);
            }),
          ],
        ),
      ),
    );
  }

  // MARK: - 개인 만남 뷰
  Widget _personalView(BuildContext context) {
    // final scheduleMainViewModel =
    //     Provider.of<ScheduleMainViewModel>(context, listen: false);
    // final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.selectedScheduleDetail == null) {
          // 선택된 스케줄이 없을 때, 기본 일정 리스트 뷰를 보여줍니다.
          return _personalScheduleListView(context);
        } else {
          // 선택된 스케줄이 있을 때, 상세 정보를 보여줍니다.
          return _personalScheduleDetailView(context);
        }
      },
    );
  }

  // 개인 일정 리스트
  Widget _personalScheduleListView(BuildContext context) {
    return Container(
      width: double.infinity,
      color: UsedColor.bg_color,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 39.h),
            ...personalScheduleMap.keys.map((date) {
              return _schedulesPersonal(context, date);
            }),
          ],
        ),
      ),
    );
  }

  // MARK: - 개인 스케쥴 Mapping
  Map<String, List<Map<String, String>>> personalScheduleMap = {
    '2024.01.06': [
      {'title': '체력 단련', 'time': '오후 7시 30분', 'location': '아름고등학교 체육관 체력 단련실'},
      {'title': '회의', 'time': '오후 9시 00분', 'location': '아름고등학교 체육관 회의실'}
    ],
    '2024.01.07': [
      {'title': '비즈니스 미팅', 'time': '오후 3시 00분', 'location': '서울역 회의실'},
    ],
    '2024.01.08': [
      {'title': '커피 타임', 'time': '오전 10시 00분', 'location': '강남 카페 미팅룸'},
      {'title': '점심 식사', 'time': '오후 12시 00분', 'location': '강남 카페 루프탑'}
    ],
  };

  //MARK: - 개인 만남 일정 컨테이너
  Widget _schedulesPersonal(BuildContext context, String date) {
    // final scheduleMainViewModel =
    //     Provider.of<ScheduleMainViewModel>(context, listen: false);
    // scheduleMap에서 해당 날짜에 대한 정보 가져오기
    List<Map<String, String>>? personalScheduleDetails =
        personalScheduleMap[date];

    // 스케줄 리스트가 없는 경우 예외 처리
    if (personalScheduleDetails == null || personalScheduleDetails.isEmpty) {
      return const Text("스케줄이 없습니다.");
    }

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
                children: personalScheduleDetails.map((detail) {
                  // 개별 시간 및 장소 정보 표시
                  String title = detail['title'] ?? '일정 제목';
                  String time = detail['time'] ?? '일정 시간';
                  String location = detail['location'] ?? '일정 장소';

                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h), // 간격 임시 값
                    child: GestureDetector(
                      onTap: () {
                        // 컨테이너 선택 시
                        Provider.of<ScheduleMainViewModel>(context,
                                listen: false)
                            .selectSchedule(date, detail);
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
                                      Text(time,
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
            ],
          ),
        ),
      ],
    );
  }

  //MARK: - 개인 일정 디테일 뷰
  Widget _personalScheduleDetailView(BuildContext context) {
    return Consumer<ScheduleMainViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(16.0),
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
                        Text(
                          '일정 제목',
                          style: AppTextStyles.PR_SB_20
                              .copyWith(color: Colors.black),
                        ),
                        SizedBox(width: 12.w),
                        Image.asset(
                          ImagePath.editPencil,
                          width: 19.w,
                          height: 19.h,
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
                            padding: EdgeInsets.only(top: 20.h, left: 24.w),
                            child: Row(
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
                                  style: AppTextStyles.PR_SB_17
                                      .copyWith(color: Colors.black),
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

  // MARK: - 밋업 스케쥴 Mapping
  Map<String, List<Map<String, String>>> meetUpScheduleMap = {
    '2024.01.06': [
      {'title': '체력 단련', 'time': '오후 7시 30분', 'location': '아름고등학교 체육관 체력 단련실'},
      {'title': '회의', 'time': '오후 9시 00분', 'location': '아름고등학교 체육관 회의실'}
    ],
    '2024.01.07': [
      {'title': '비즈니스 미팅', 'time': '오후 3시 00분', 'location': '서울역 회의실'},
    ],
    '2024.01.08': [
      {'title': '커피 타임', 'time': '오전 10시 00분', 'location': '강남 카페 미팅룸'},
      {'title': '점심 식사', 'time': '오후 12시 00분', 'location': '강남 카페 루프탑'}
    ],
  };

  // MARK: - 밋업 만남 위젯
  Widget _schedulesMeetUp(BuildContext context, String date) {
    // final scheduleMainViewModel =
    //     Provider.of<ScheduleMainViewModel>(context, listen: false);
    // scheduleMap에서 해당 날짜에 대한 정보 가져오기
    List<Map<String, String>>? meetUpScheduleDetails =
        personalScheduleMap[date];

    // 스케줄 리스트가 없는 경우 예외 처리
    if (meetUpScheduleDetails == null || meetUpScheduleDetails.isEmpty) {
      return const Text("스케줄이 없습니다.");
    }

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
                children: meetUpScheduleDetails.map((detail) {
                  // 개별 시간 및 장소 정보 표시
                  String title = detail['title'] ?? '일정 제목';
                  String time = detail['time'] ?? '일정 시간';
                  String location = detail['location'] ?? '일정 장소';

                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h), // 간격 임시 값
                    child: GestureDetector(
                      onTap: () {
                        // 컨테이너 선택 시
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
                                      Text(time,
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
            ],
          ),
        ),
      ],
    );
  }
}
