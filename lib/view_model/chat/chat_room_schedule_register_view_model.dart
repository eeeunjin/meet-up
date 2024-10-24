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
    required DateTime start,
    required DateTime end,
  }) {
    DateTime startFormatted =
        DateTime(start.year, start.month, start.day, 0, 0);
    _selectedDate = startFormatted;
    _start = startFormatted;
    _end = end;
  }

  // MARK: - 일정 등록
  TextEditingController scheduleNameController = TextEditingController();
  bool get namingCompleted => scheduleNameController.text.isNotEmpty;

  // MARK: - DatePicker
  bool _isDatePanelExpanded = false;
  bool get isDatePanelExpanded => _isDatePanelExpanded;

  DateTime? _selectedDate;
  DateTime get selectedDate => _selectedDate!; // 선택된 날짜

  DateTime? _start;
  DateTime? _end;

  DateTime get start => _start!;
  DateTime get end => _end!;

  // 연도 업데이트
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

  // 월 업데이트
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

  // 일 업데이트
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

  // MARK: - timePicker
  bool _isTimePanelExpanded = false;

  // 선택된 시간 초기화
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

  String formatTime() {
    final time = selectedDate;
    final period = time.hour < 12 ? '오전' : '오후';
    final hour = (period == '오전' ? time.hour : time.hour - 12)
        .toString()
        .padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$period $hour:$minute';
  }

  // MARK: - 장소 등록
  TextEditingController locationController = TextEditingController();
  bool get locationCompleted => locationController.text.isNotEmpty;

  // MARK: - check
  bool get allCheckCompleted => namingCompleted && locationCompleted;

  void pannelClose() {
    _isDatePanelExpanded = false;
    _isTimePanelExpanded = false;
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
          selectedDate.hour,
          selectedDate.minute,
        ),
      ),
      location: locationController.text,
      participants_agree_selected_schedule: [],
    );

    ChatModel chatModel = ChatModel(
      uid: uid,
      nickname: '',
      profile_icon: '',
      content: '',
      date: Timestamp.now(),
      room_reference: roomId,
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
    required String type,
    String? nickname,
    List<dynamic>? participants,
  }) async {
    Map<String, dynamic> data;

    if (participants != null) {
      if (type == 'owner') {
        data = {
          "isScheduleDecided": false,
          "room_schedule": null,
          "isRoomDeleted": true,
          "isOwnerExit": true,
        };
      } else {
        data = {
          "room_participant_reference": participants,
          "isScheduleDecided": false,
          "room_schedule": null,
          "isRoomDeleted": false,
          "room_creation_date": Timestamp.now(),
        };
      }
    } else {
      data = {
        'room_schedule': null,
      };
    }

    // 기존의 스케줄 chat 삭제 (docId 'schedule_register')
    await _chatRepository.deleteChat(
      roomId,
      'schedule_register',
    );

    // 알림 삭제 채팅이 존재했다면 삭제
    await _chatRepository.deleteChat(
      roomId,
      "schedule_delete_by_owner",
    );

    // ChatModel 추가
    ChatModel chatModel = ChatModel(
      uid: '',
      nickname: nickname!,
      profile_icon: '',
      content: scheduleTitle,
      date: Timestamp.now(),
      room_reference: roomId,
      type: type == 'owner'
          ? (participants != null)
              ? 'schedule_delete_by_owner_out'
              : 'schedule_delete_by_owner'
          : 'schedule_delete_by_participant',
    );

    await _chatRepository.createChat(
      chatModel,
      roomId,
      (type == 'owner')
          ? (participants != null)
              ? 'schedule_delete_by_owner_out'
              : 'schedule_delete_by_owner'
          : 'schedule_delete_by_participant',
    );

    // RoomModel 업데이트
    await _roomRepository.updateRoomDocument(
      roomId: roomId,
      data: data,
    );
  }

  // MARK: - 상태 초기화
  void resetState() {
    scheduleNameController.clear();
    _selectedDate = _start;
    _isDatePanelExpanded = false;
    _isTimePanelExpanded = false;
    locationController.clear();
    notifyListeners();
  }
}
