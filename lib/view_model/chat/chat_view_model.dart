import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/repository/user_repository.dart';
import 'package:intl/intl.dart';

class ChatViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // myRoom 정보 불러오기 테스트
  Stream<QuerySnapshot<Object?>> readMyRoomCollectionStream({
    required String uid,
  }) {
    return _userRepository.readMyRoomCollectionStream(
      uid: uid,
      findAll: true,
    );
  }

  // MARK: - 일정 등록
  // 일정
  String _scheduleNaming = '';

  String get scheduleNaming => _scheduleNaming;

  void namingContents(String newNamingCount) {
    if (_scheduleNaming != newNamingCount) {
      _scheduleNaming = newNamingCount;
      notifyListeners();
    }
  }

  // naming check
  bool get namingCompleted {
    return _scheduleNaming.trim().isNotEmpty;
  }

  // datePicker
  bool _isDatePanelExpanded = false;

  bool get isDatePanelExpanded => _isDatePanelExpanded;

  DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate; // 선택된 날짜

  // MARK: - DatePicker
  final DateTime _start;
  final DateTime _end;

  ChatViewModel({
    required DateTime init,
    required DateTime start,
    required DateTime end,
  })  : _selectedDate = init,
        _start = start,
        _end = end,
        _selectedTime = const TimeOfDay(hour: 19, minute: 30); // 타임 피커 초기화

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

  // MARK: - check

  bool get allCheckCompleted {
    return namingCompleted;
  }
}
