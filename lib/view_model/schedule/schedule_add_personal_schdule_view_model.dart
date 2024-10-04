import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleAddPersonalScheduleViewModel with ChangeNotifier {
   // 타임 피커 초기화
  ScheduleAddPersonalScheduleViewModel({
    required DateTime init,
    required DateTime start,
    required DateTime end,
  })  : _selectedDate = init,
        _start = start,
        _end = end,
        _selectedTime = const TimeOfDay(hour: 19, minute: 30);

  // 일정
  String _roomNaming = '';

  String get roomNaming => _roomNaming;

  void namingContents(String newNamingCount) {
    if (_roomNaming != newNamingCount) {
      _roomNaming = newNamingCount;
      notifyListeners();
    }
  }

  // naming check
  bool get namingCompleted {
    return _roomNaming.trim().isNotEmpty;
  }

  // 선택된 날짜
  DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate;

  // DatePicker
  bool _isDatePanelExpanded = false;
  bool get isDatePanelExpanded => _isDatePanelExpanded;

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

  // timePicker
  bool _isTimePanelExpanded = false;

  bool get isTimePanelExpanded => _isTimePanelExpanded;

  // 선택된 시간 초기화
  TimeOfDay _selectedTime;

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

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? '오전' : '오후';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$period $hour:$minute';
  }

  // 장소
  TextEditingController locationTextController = TextEditingController();

  bool get isLocationCompleted {
    return locationTextController.text.isNotEmpty;
  }

  // 설명
  TextEditingController detailTextController = TextEditingController();

  bool get isDetailCompleted {
    return detailTextController.text.isNotEmpty;
  }

  // 참여 인원
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
  // MARK: - check

  bool get allCheckCompleted {
    return namingCompleted &&
        isLocationCompleted &&
        isDetailCompleted &&
        isMembersCompleted;
  }

  // MARK: - Reset state
  void backClearSelection() {
    locationTextController.clear();
    detailTextController.clear();
    _selectedMembers.clear();
  }
}