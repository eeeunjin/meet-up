import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/repository/user_repository.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

class ScheduleAddPersonalScheduleViewModel with ChangeNotifier {
  final FirebaseRefs _firebaseRefs = FirebaseRefs();
  final UserRepository _userRepository = UserRepository();

  // MARK: - 날짜
  DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate;

  // 선택 날짜 초기화
  TimeOfDay _selectedTime;
  TimeOfDay get selectedTime => _selectedTime;

  final DateTime _start = DateTime.now(); // Start is set to today
  final DateTime _end = DateTime.now().add(const Duration(days: 14));

  // 타임 피커 초기화
  ScheduleAddPersonalScheduleViewModel({
    required DateTime init,
  })  : _selectedDate = init,
        _selectedTime = const TimeOfDay(hour: 19, minute: 30);

  // MARK: - 일정
  TextEditingController namingController = TextEditingController();

  // naming check
  bool get namingCompleted {
    return namingController.text.trim().isNotEmpty;
  }

  // DatePicker
  bool _isDatePanelExpanded = false;
  bool get isDatePanelExpanded => _isDatePanelExpanded;

  DateTime get start => _start;
  DateTime get end => _end;

  set selectedDate(DateTime newValue) {
    if (_selectedDate != newValue) {
      _selectedDate = newValue;
      notifyListeners();
    }
  }

  // date 업데이트
  void updateDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      notifyListeners();
    }
  }

  // year 업데이트
  void updateYear(int year) {
    if (_selectedDate.year != year) {
      _selectedDate = DateTime(year, _selectedDate.month, _selectedDate.day);
      notifyListeners();
    }
  }

  // month 업데이트
  void updateMonth(int month) {
    if (_selectedDate.month != month) {
      _selectedDate = DateTime(_selectedDate.year, month, _selectedDate.day);
      notifyListeners();
    }
  }

  // day 업데이트
  void updateDay(int day) {
    if (_selectedDate.day != day) {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, day);
      notifyListeners();
    }
  }

  List<int> getYearList() {
    return List<int>.generate(
        end.year - start.year + 1, (index) => start.year + index);
  }

  List<int> getMonthList() {
    if (_start.year == _end.year) {
      return List<int>.generate(
          _end.month - _start.month + 1, (index) => _start.month + index);
    }
    return [];
  }

  List<int> getDayList() {
    if (_selectedDate.year == _start.year &&
        _selectedDate.month == _start.month) {
      // Show days from today onward
      return List<int>.generate(
          _end.difference(_start).inDays + 1, (index) => _start.day + index);
    } else if (_selectedDate.year == _end.year &&
        _selectedDate.month == _end.month) {
      // Show days up to the _end date
      return List<int>.generate(_end.day, (index) => index + 1);
    }
    return [];
  }

  // 요일 계산 메서드
  String getDayOfWeek(DateTime date) {
    final DateFormat formatter = DateFormat.EEEE('ko');
    return formatter.format(date);
  }

  // ExpansionPanel 토글
  void toggleDatePanel() {
    _isDatePanelExpanded = !_isDatePanelExpanded; // 상태 반전
    notifyListeners();
  }

  // MARK: - 시간
  bool _isTimePanelExpanded = false;

  bool get isTimePanelExpanded => _isTimePanelExpanded;

  // ExpansionPanel 토글
  void toggleTimePanel() {
    _isTimePanelExpanded = !_isTimePanelExpanded;
    notifyListeners();
  }

  void updateTime(TimeOfDay newTime) {
    if (_selectedTime != newTime) {
      _selectedTime = newTime;
      notifyListeners();
    }
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? '오전' : '오후';
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
  void addMembers(String member) {
    if (!_selectedMembers.contains(member)) {
      _selectedMembers.add(member);
      notifyListeners();
    }
  }

  void removeParticipant(String member) {
    _selectedMembers.remove(member);
    notifyListeners();
  }

  // add members
  List<String> _selectedMembers = [];
  List<String> get selectedMembers => _selectedMembers;

  set selectedMembers(List<String> members) {
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
    _selectedDate = DateTime.now();
    _selectedTime = const TimeOfDay(hour: 19, minute: 30);
    locationTextController.clear();
    detailTextController.clear();
    _selectedMembers.clear();
    _originalRoomModel = null;
  }

  // MARK: - 개인 일정 저장
  Future<void> savePersonalSchedule({required String myUID}) async {
    // 개인 일정 저장
    logger.d(
        '일정: ${namingController.text}\n날짜: $_selectedDate\n시간: $_selectedTime\n장소: ${locationTextController.text}\n설명: ${detailTextController.text}\n참여 인원: $_selectedMembers');

    // _selectedDate, _selectedTime -> Timestamp
    final date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
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
    );

    await _userRepository.createMyScheduleDocument(data: roomModel, uid: myUID);
  }

  // MARK: - 개인 일정 수정
  // 수정 시, 기존 데이터 불러오기
  RoomModel? _originalRoomModel;

  List<String> get originalMembers {
    return List.from(_originalRoomModel!.room_participant_reference);
  }

  void loadExistingData(RoomModel roomModel) {
    _originalRoomModel = roomModel;
    namingController.text = roomModel.room_schedule!["title"] as String;
    _selectedDate = (roomModel.room_schedule!["date"] as Timestamp).toDate();
    _selectedTime = TimeOfDay.fromDateTime(_selectedDate);
    locationTextController.text =
        roomModel.room_schedule!["location"] as String;
    detailTextController.text = roomModel.room_description;
    _selectedMembers = List<String>.from(roomModel.room_participant_reference);
  }

  // 처음이랑 달라진게 있는지 체크
  bool get isChanged {
    bool isNameChanged = namingController.text !=
        _originalRoomModel!.room_schedule!["title"] as String;
    bool isDateChanged = _selectedDate !=
        (_originalRoomModel!.room_schedule!["date"] as Timestamp).toDate();
    bool isTimeChanged = _selectedTime !=
        TimeOfDay.fromDateTime(
            (_originalRoomModel!.room_schedule!["date"] as Timestamp).toDate());
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
            isTimeChanged ||
            isLocationChanged ||
            isDetailChanged ||
            isMembersChanged;
  }

  Future<RoomModel> updatePersonalSchedule(
      {required String myUID, required String myScheduleId}) async {
    // 개인 일정 저장
    final date = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
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
    );

    await _userRepository.updateMyScheduleDocument(data: roomModel, uid: myUID);

    return roomModel;
  }

  void notify() {
    notifyListeners();
  }
}
