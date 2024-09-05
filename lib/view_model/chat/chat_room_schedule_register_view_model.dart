import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/model/chat_room_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/repository/chat_repository.dart';
import 'package:meet_up/repository/room_repository.dart';

class ChatRoomSchduleRegisterViewModel with ChangeNotifier {
  final RoomRepository _roomRepository = RoomRepository();
  final ChatRepository _chatRepository = ChatRepository();

  // MARK: - Initializer
  ChatRoomSchduleRegisterViewModel({
    required DateTime init,
    required DateTime start,
    required DateTime end,
  })  : _selectedDate = init,
        _start = start,
        _end = end,
        _selectedTime = const TimeOfDay(hour: 19, minute: 30);

  // MARK: - 일정 등록
  TextEditingController scheduleNameController = TextEditingController();
  bool get namingCompleted => scheduleNameController.text.isNotEmpty;

  // MARK: - DatePicker
  bool _isDatePanelExpanded = false;
  bool get isDatePanelExpanded => _isDatePanelExpanded;

  DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate; // 선택된 날짜

  final DateTime _start;
  final DateTime _end;

  DateTime get start => _start;
  DateTime get end => _end;

  set selectedDate(DateTime newValue) {
    if (_selectedDate != newValue) {
      _selectedDate = newValue;
      notifyListeners();
    }
  }

  void updateDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      notifyListeners();
    }
  }

  // 연도 업데이트
  void updateYear(int year) {
    if (_selectedDate.year != year) {
      _selectedDate = DateTime(year, _selectedDate.month, _selectedDate.day);
      notifyListeners();
    }
  }

  // 월 업데이트
  void updateMonth(int month) {
    if (_selectedDate.month != month) {
      _selectedDate = DateTime(_selectedDate.year, month, _selectedDate.day);
      notifyListeners();
    }
  }

  // 일 업데이트
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
    if (selectedDate.year == end.year) {
      return List<int>.generate(end.month, (index) => index + 1);
    } else {
      return List<int>.generate(12, (index) => index + 1);
    }
  }

  List<int> getDayList() {
    DateTime lastDateOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);
    if (selectedDate.year == end.year && selectedDate.month == end.month) {
      return List<int>.generate(end.day, (index) => index + 1);
    }
    return List<int>.generate(lastDateOfMonth.day, (index) => index + 1);
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

  // MARK: - timePicker
  bool _isTimePanelExpanded = false;

  // 선택된 시간 초기화
  TimeOfDay _selectedTime;

  bool get isTimePanelExpanded => _isTimePanelExpanded;
  TimeOfDay get selectedTime => _selectedTime;

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

  // String getFormattedTime() {
  //   final period = _selectedTime.period == DayPeriod.am ? '오전' : '오후';
  //   final hour = _selectedTime.hourOfPeriod.toString().padLeft(2, '0');
  //   final minute = _selectedTime.minute.toString().padLeft(2, '0');
  //   return '$period $hour:$minute';
  // }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? '오전' : '오후';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$period $hour:$minute';
  }

  // MARK: - 장소 등록
  TextEditingController locationController = TextEditingController();
  bool get locationCompleted => locationController.text.isNotEmpty;

  // MARK: - check
  bool get allCheckCompleted => namingCompleted && locationCompleted;

  void notify() {
    notifyListeners();
  }

  // MARK: - 일정 등록
  Future<void> registerSchedule(
      {required String roomId,
      required String uid,
      required String nickname}) async {
    // 일정 등록
    RoomSchedule roomSchedule = RoomSchedule(
      title: scheduleNameController.text,
      date: Timestamp.fromDate(
        DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        ),
      ),
      location: locationController.text,
      participants_agree_selected_schedule: null,
    );

    ChatModel chatModel = ChatModel(
      uid: uid,
      nickName: nickname,
      content: '',
      date: Timestamp.now(),
      room_id: roomId,
      type: 'schedule_register',
    );

    await _roomRepository.updateRoomDocument(
      roomId: roomId,
      data: {
        'room_schedule': roomSchedule.toJson(),
      },
    );

    await _chatRepository.createChat(
      chatModel,
      roomId,
      'schedule_register',
    );
  }

  // MARK: - 일정 삭제
  Future<void> deleteSchedule({
    required String roomId,
    required String scheduleTitle,
  }) async {
    // RoomModel 업데이트
    await _roomRepository.updateRoomDocument(
      roomId: roomId,
      data: {
        'room_schedule': null,
      },
    );

    // 기존의 스케줄 chat 삭제 (docId 'schedule_register')
    await _chatRepository.deleteChat(
      roomId,
      'schedule_register',
    );

    // 알림 삭제 채팅이 존재했다면 삭제
    await _chatRepository.deleteChat(
      roomId,
      "schedule_delete",
    );

    // ChatModel 추가
    ChatModel chatModel = ChatModel(
      uid: '',
      nickName: '',
      content: scheduleTitle,
      date: Timestamp.now(),
      room_id: roomId,
      type: 'schedule_delete',
    );

    await _chatRepository.createChat(
      chatModel,
      roomId,
      "schedule_delete",
    );
  }
}
