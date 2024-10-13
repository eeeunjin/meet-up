import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/user_repository.dart';

class ScheduleMainViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // MARK: - Main
  // 선택된 탭을 저장하는 변수
  SelectedPart _selectedPart = SelectedPart.meetUp;

  SelectedPart get selectedPart => _selectedPart;

  // 불러온 스케줄 정보를 저장하는 변수
  List<RoomModel>? _ScheduleList;

  List<RoomModel>? get scheduleList => _ScheduleList;

  void selectMeetUp() {
    if (_selectedPart != SelectedPart.meetUp) {
      _selectedPart = SelectedPart.meetUp;
      notifyListeners();
    }
  }

  void selectPersonal() {
    if (_selectedPart != SelectedPart.personal) {
      _selectedPart = SelectedPart.personal;
      notifyListeners();
    }
  }

  void setScheduleList(List<RoomModel> mySchedules) {
    _ScheduleList = mySchedules;
  }

  // 밋업 일정 정보를 날짜별로 정리 후 반환
  Map<String, List<RoomModel>> getMeetUpScheduleByDate() {
    final DateFormat formatter = DateFormat('yyyy.MM.dd EEEE', 'ko_KR');
    final Map<String, List<RoomModel>> scheduleByDate = {};

    for (final schedule in _ScheduleList!) {
      // 개인 일정은 제외
      if (schedule.room_category.isEmpty) {
        continue;
      }
      final date = schedule.room_schedule!["date"] as Timestamp;

      if (date.toDate().isBefore(DateTime.now())) {
        continue;
      }

      final formattedDate = formatter.format(date.toDate());
      if (scheduleByDate.containsKey(formattedDate)) {
        scheduleByDate[formattedDate]!.add(schedule);
      } else {
        scheduleByDate[formattedDate] = [schedule];
      }
    }

    return scheduleByDate;
  }

  // 개인 일정 정보를 날짜별로 정리 후 반환
  Map<String, List<RoomModel>> getPersonalScheduleByDate() {
    final DateFormat formatter = DateFormat('yyyy.MM.dd EEEE', 'ko_KR');
    final Map<String, List<RoomModel>> scheduleByDate = {};

    for (final schedule in _ScheduleList!) {
      // 밋업 일정은 제외
      if (schedule.room_category.isNotEmpty) {
        continue;
      }

      final date = schedule.room_schedule!["date"] as Timestamp;

      if (date.toDate().isBefore(DateTime.now())) {
        continue;
      }
      final formattedDate = formatter.format(date.toDate());
      if (scheduleByDate.containsKey(formattedDate)) {
        scheduleByDate[formattedDate]!.add(schedule);
      } else {
        scheduleByDate[formattedDate] = [schedule];
      }
    }

    return scheduleByDate;
  }

  // user - mySchedule collection stream 정보 가져오기
  Stream<QuerySnapshot<Object?>> getMyScheduleStream(String uid) {
    return _userRepository.readMyScheduleCollectionStream(uid: uid);
  }

  // user 정보 불러오기
  Future<List<UserModel>> getParticipantInfo() async {
    List<DocumentReference> docRefs = List.empty(growable: true);
    // 방장 추가
    docRefs.add(selectedMeetUpScheduleDetail!.room_owner_reference);

    // 입장한 사람 추가
    for (DocumentReference docRef
        in selectedMeetUpScheduleDetail!.room_participant_reference) {
      docRefs.add(docRef);
    }

    // 유저 정보 불러오기
    List<UserModel> userModels = List.empty(growable: true);
    for (DocumentReference docRef in docRefs) {
      userModels
          .add(await _userRepository.readUserDocumentByDocRef(docRef: docRef));
    }

    for (UserModel userModel in userModels) {
      logger.d(
          "userModel.nickname: ${userModel.nickname} / userModel.gender: ${userModel.gender}");
    }

    return userModels;
  }

  // MARK: - Schedule Selection
  // 선택된 개인 일정
  RoomModel? _selectedPersonalScheduleDetail;
  RoomModel? get selectedPersonalScheduleDetail =>
      _selectedPersonalScheduleDetail;

  // 선택된 밋업 일정
  RoomModel? _selectedMeetUpScheduleDetail;
  RoomModel? get selectedMeetUpScheduleDetail => _selectedMeetUpScheduleDetail;

  // 스케줄 선택
  void selectSchedule(RoomModel detail, String type) {
    if (type == 'meetUp') {
      _selectedMeetUpScheduleDetail = detail;
    } else {
      _selectedPersonalScheduleDetail = detail;
    }
    notifyListeners();
  }

  // 선택 초기화
  void resetScheduleSelection(String type) {
    if (type == 'meetUp') {
      _selectedMeetUpScheduleDetail = null;
    } else {
      _selectedPersonalScheduleDetail = null;
    }
    notifyListeners();
  }

  // 선택된 개인 일정 삭제
  Future<void> deletePersonalSchedule(String uid, String scheduleId) async {
    await _userRepository.deleteMyScheduleData(
      uid: uid,
      scheduleId: scheduleId,
    );
  }
}

enum SelectedPart { meetUp, personal }
