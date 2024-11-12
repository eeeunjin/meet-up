import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/repository/user_repository.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

class ScheduleAddPersonalViewModel with ChangeNotifier {
  // MARK: - 일정
  TextEditingController namingController = TextEditingController();

  // naming check
  bool get namingCompleted {
    return namingController.text.trim().isNotEmpty;
  }

  final FirebaseRefs _firebaseRefs = FirebaseRefs();
  final UserRepository _userRepository = UserRepository();

  // 타임 피커 초기화
  ScheduleAddPersonalViewModel({
    required DateTime start,
    required DateTime end,
  }) {
    DateTime startFormatted =
        DateTime(start.year, start.month, start.day, 0, 0);
    _selectedDate = startFormatted;
    _start = startFormatted;
    _end = end;
  }

  // MARK: - 날짜
  DateTime? _selectedDate;
  DateTime get selectedDate => _selectedDate!;

  // DatePicker
  bool _isDatePanelExpanded = false;
  bool get isDatePanelExpanded => _isDatePanelExpanded;

  DateTime? _start;
  DateTime? _end;

  DateTime get start => _start!;
  DateTime get end => _end!;

  // year 업데이트
  void updateYear(int year) {
    if (_selectedDate!.year != year) {
      _selectedDate = DateTime(year, _selectedDate!.month, _selectedDate!.day,
          _selectedDate!.hour, _selectedDate!.minute);
      if (_selectedDate!.year == start.year) {
        updateMonth(start.month);
      } else {
        updateMonth(1);
      }
    }
  }

  // month 업데이트
  void updateMonth(int month) {
    if (_selectedDate!.month != month) {
      _selectedDate = DateTime(_selectedDate!.year, month, _selectedDate!.day,
          _selectedDate!.hour, _selectedDate!.minute);

      if (_selectedDate!.month == start.month) {
        updateDay(start.day, month);
      } else {
        updateDay(1, month);
      }
    }
  }

  // day 업데이트
  void updateDay(int day, [int? month]) {
    if (_selectedDate!.day != day) {
      _selectedDate = DateTime(
          _selectedDate!.year,
          month ?? _selectedDate!.month,
          day,
          _selectedDate!.hour,
          _selectedDate!.minute);
      notifyListeners();
    }
  }

  List<int> getYearList() {
    return List<int>.generate(
        end.year - start.year + 1, (index) => start.year + index);
  }

  List<int> getMonthList() {
    if (selectedDate.year == end.year) {
      List<int> months = List<int>.generate(end.month, (index) => index + 1);
      // 연도가 넘어가지 않은 경우
      if (start.year == end.year) {
        months.removeWhere((element) => element < start.month);
      }
      return months;
    } else {
      // 연도가 넘어간 경우
      List<int> months = List<int>.generate(12, (index) => index + 1);
      months.removeWhere((element) => element < start.month);
      return months;
    }
  }

  List<int> getDayList() {
    if (selectedDate.month == end.month) {
      List<int> days = List<int>.generate(end.day, (index) => index + 1);
      // 연도가 넘어가지 않은 경우
      if (start.month == end.month) {
        days.removeWhere((element) => element < start.day);
      }
      return days;
    } else {
      int maxDay = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
      // 연도가 넘어간 경우
      List<int> days = List<int>.generate(maxDay, (index) => index + 1);
      days.removeWhere((element) => element < start.day);

      return days;
    }
  }

  // 요일 계산 메서드
  String getDayOfWeek(DateTime date) {
    final DateFormat formatter = DateFormat.EEEE('ko');
    return formatter.format(date);
  }

  // ExpansionPanel 토글
  void toggleDatePanel() {
    if (_isTimePanelExpanded) {
      _isTimePanelExpanded = !_isTimePanelExpanded;
    }
    _isDatePanelExpanded = !_isDatePanelExpanded; // 상태 반전
    notifyListeners();
  }

  // MARK: - 시간
  bool _isTimePanelExpanded = false;

  bool get isTimePanelExpanded => _isTimePanelExpanded;

  // ExpansionPanel 토글
  void toggleTimePanel() {
    if (_isDatePanelExpanded) {
      _isDatePanelExpanded = !_isDatePanelExpanded;
    }
    _isTimePanelExpanded = !_isTimePanelExpanded;
    notifyListeners();
  }

  void updateTime(TimeOfDay newTime) {
    final hour = _selectedDate!.hour;
    final minute = _selectedDate!.minute;
    final TimeOfDay selectedTime = TimeOfDay(hour: hour, minute: minute);
    if (selectedTime != newTime) {
      DateTime newDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        newTime.hour,
        newTime.minute,
      );
      _selectedDate = newDateTime;
      notifyListeners();
    }
  }

  String formatSelectedTime() {
    final time = selectedDate;
    final period = time.hour < 12 ? '오전' : '오후';
    final hour = (period == '오전' ? time.hour : time.hour - 12)
        .toString()
        .padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$period $hour:$minute';
  }

  // MARK: - 장소
  TextEditingController locationTextController = TextEditingController();

  bool get isLocationCompleted {
    return locationTextController.text.isNotEmpty;
  }

  // MARK: - 설명
  TextEditingController detailTextController = TextEditingController();

  bool get isDetailCompleted {
    return detailTextController.text.isNotEmpty;
  }

  // MARK: - 참여 인원
  List<String> _selectedMembers = [];
  List<String> get selectedMembers => _selectedMembers;

  set selectedMembers(List<String> members) {
    logger.d(members);
    _selectedMembers = members;
    notifyListeners();
  }

  bool get isMembersCompleted => selectedMembers.isNotEmpty;

  // MARK: - 입력 사항 체크
  bool get allCheckCompleted {
    return namingCompleted &&
        isLocationCompleted &&
        isDetailCompleted &&
        isMembersCompleted;
  }

  // MARK: - 상태 초기화
  void clearAllState() {
    namingController.clear();
    _selectedDate = start;
    locationTextController.clear();
    detailTextController.clear();
    _selectedMembers.clear();
    _originalRoomModel = null;
    _isDatePanelExpanded = false;
    _isTimePanelExpanded = false;
  }

  // MARK: - 개인 일정 저장
  Future<void> savePersonalSchedule({required String myUID}) async {
    // 개인 일정 저장
    // _selectedDate!, _selectedTime -> Timestamp
    final date = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedDate!.hour,
      _selectedDate!.minute,
    );

    Timestamp dateByTimestamp = Timestamp.fromDate(date);

    // RoomModel 생성
    final roomSchedule = RoomSchedule(
      title: namingController.text,
      date: dateByTimestamp,
      location: locationTextController.text,
      participants_agree_selected_schedule: [],
    );

    final RoomModel roomModel = RoomModel(
      room_name: "",
      room_category: "",
      room_category_detail: "",
      room_region_province: "",
      room_region_district: "",
      room_keyword: [],
      room_description: detailTextController.text,
      room_age: [],
      room_gender_ratio: "",
      room_rules: [],
      room_creation_date: Timestamp.now(),
      room_owner_reference: _firebaseRefs.colRefUser.doc(myUID),
      room_participant_reference: selectedMembers,
      isScheduleDecided: true,
      room_meeting_review: [],
      recentMessage: "",
      room_schedule: roomSchedule.toJson(),
      isRoomDeleted: false,
      isOwnerExit: false,
    );

    await _userRepository.createMyScheduleDocument(data: roomModel, uid: myUID);
  }

  // MARK: - 개인 일정 수정
  // 수정 시, 기존 데이터 불러오기
  RoomModel? _originalRoomModel;
  RoomModel? get originalRoomModel => _originalRoomModel;

  List<String> get originalMembers {
    return List.from(_originalRoomModel!.room_participant_reference);
  }

  void loadExistingData(RoomModel roomModel) {
    _originalRoomModel = roomModel;
    namingController.text = roomModel.room_schedule!["title"] as String;
    _selectedDate = (roomModel.room_schedule!["date"] as Timestamp).toDate();
    locationTextController.text =
        roomModel.room_schedule!["location"] as String;
    detailTextController.text = roomModel.room_description;
    _selectedMembers = List<String>.from(roomModel.room_participant_reference);
  }

  // 처음이랑 달라진게 있는지 체크
  bool get isChanged {
    bool isNameChanged = namingController.text !=
        _originalRoomModel!.room_schedule!["title"] as String;
    bool isDateChanged = _selectedDate! !=
        (_originalRoomModel!.room_schedule!["date"] as Timestamp).toDate();
    bool isLocationChanged = locationTextController.text !=
        _originalRoomModel!.room_schedule!["location"] as String;
    bool isDetailChanged =
        detailTextController.text != _originalRoomModel!.room_description;
    bool isMembersChanged =
        !(_selectedMembers.toSet().containsAll(originalMembers) &&
            originalMembers.toSet().containsAll(_selectedMembers));

    return _originalRoomModel == null
        ? false
        : isNameChanged ||
            isDateChanged ||
            isLocationChanged ||
            isDetailChanged ||
            isMembersChanged;
  }

  Future<void> updatePersonalSchedule(
      {required String myUID, required String myScheduleId}) async {
    // 개인 일정 저장
    final date = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedDate!.hour,
      _selectedDate!.minute,
    );

    Timestamp dateByTimestamp = Timestamp.fromDate(date);

    // RoomModel 생성
    final roomSchedule = RoomSchedule(
      title: namingController.text,
      date: dateByTimestamp,
      location: locationTextController.text,
      participants_agree_selected_schedule: [],
    );

    final RoomModel roomModel = RoomModel(
      room_name: myScheduleId,
      room_category: "",
      room_category_detail: "",
      room_region_province: "",
      room_region_district: "",
      room_keyword: [],
      room_description: detailTextController.text,
      room_age: [],
      room_gender_ratio: "",
      room_rules: [],
      room_creation_date: Timestamp.now(),
      room_owner_reference: _firebaseRefs.colRefUser.doc(myUID),
      room_participant_reference: selectedMembers,
      isScheduleDecided: true,
      room_meeting_review: [],
      recentMessage: "",
      room_schedule: roomSchedule.toJson(),
      isRoomDeleted: false,
      isOwnerExit: false,
    );

    await _userRepository.updateMyScheduleDocument(data: roomModel, uid: myUID);

    return;
  }

  void pannelClose() {
    _isDatePanelExpanded = false;
    _isTimePanelExpanded = false;
    notifyListeners();
  }
}
