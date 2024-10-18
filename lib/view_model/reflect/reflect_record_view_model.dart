import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReflectRecordViewModel with ChangeNotifier {
  // 내가 작성한 일기 데이터
  final List<Map<String, String>> _myDiaryEntries = [
    {
      'title': '16글자 제목을 적어 보겠습니다',
      'date': '2024.02.07. (수) 오후 7:30',
      'content':
          '즐겁고 보람찬 만남이었다.\n다음에는 스트레이 키즈 노래 틀어 주면 좋겠다 왜냐면....\n더 길어져야 하는데 뭔 내용을 더 적어야 하는지 모르겠다.',
    },
    {
      'title': '두 번째 일기 제목',
      'date': '2024.02.08. (목) 오전 10:30',
      'content': '오늘은 아침에 산책을 다녀왔다\n날씨가 정말 좋았다.',
    },
    {
      'title': '돼지 파티',
      'date': '2024.05.07. (월) 오후 6:30',
      'content': '돼지 파티를 했다.'
    }
  ];

  String? _selectedDiaryId;
  DateTime _selectedDate = DateTime.now(); // 선택된 연/월 저장
  DateTime _displayedDate = DateTime.now(); // 팝업에서 표시용 연/월 저장

  String? get selectedDiaryId => _selectedDiaryId;
  DateTime get selectedDate => _selectedDate;
  DateTime get displayedDate => _displayedDate;

  List<Map<String, String>> get myDiaryEntries => _myDiaryEntries;

  final bool _isAvailableEntriesSortedByRecent = true;

  // 연도와 월을 표시용으로 초기화 (팝업 열릴 때)
  void initializeDisplayedDate() {
    _displayedDate = _selectedDate;
  }

  void confirmSelectedDate() {
    _selectedDate = _displayedDate;
    updateDiaryList();
  }

  // 연도 변경 (표시용)
  void selectPreviousYear() {
    _displayedDate = DateTime(_displayedDate.year - 1, _displayedDate.month);
    notifyListeners();
  }

  void selectNextYear() {
    _displayedDate = DateTime(_displayedDate.year + 1, _displayedDate.month);
    notifyListeners();
  }

  // 월 선택 (표시용)
  void selectMonth(int month) {
    _displayedDate = DateTime(_displayedDate.year, month);
    notifyListeners();
  }

  // 다이어리 목록 갱신
  void updateDiaryList() {
    notifyListeners();
  }

  // 작성된 일기가 있는 연/월을 확인
  bool isMonthWritten(int month, int year) {
    // _myDiaryEntries가 null이 아닌지 확인
    if (_myDiaryEntries.isEmpty) {
      return false;
    }

    return _myDiaryEntries.any((entry) {
      try {
        DateTime entryDate = _parseDate(entry['date']!);
        return entryDate.month == month && entryDate.year == year;
      } catch (e) {
        print('날짜 파싱 오류: $e');
        return false;
      }
    });
  }

  // 제목 길이 제한
  String getLimitedTitle(String title) {
    if (title.length > 16) {
      return title.substring(0, 16);
    }
    return title;
  }

  // 기본값을 최근순으로 설정
  bool _isSortedByRecent = true;
  bool get isSortedByRecent => _isSortedByRecent;

  // 최근순 정렬
  void _sortByRecent() {
    _myDiaryEntries.sort((a, b) {
      final dateA = _parseDate(a['date']!);
      final dateB = _parseDate(b['date']!);
      return dateB.compareTo(dateA); // 최근순 정렬
    });
  }

  DateTime _parseDate(String dateStr) {
    final dateTimePart = dateStr.split(' ');
    final datePart = dateTimePart[0]; // 연.월.일
    final period = dateTimePart[2]; // '오후' or '오전'
    final timePart = dateTimePart[3]; // 시간.분

    final dateClean = datePart.split('(')[0];
    final dateComponents = dateClean.split('.');
    final year = int.parse(dateComponents[0]);
    final month = int.parse(dateComponents[1]);
    final day = int.parse(dateComponents[2]);

    final timeComponents = timePart.split(':');
    int hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    if (period == '오후' && hour != 12) {
      hour += 12;
    }

    if (period == '오전' && hour == 12) {
      hour = 0;
    }

    return DateTime(year, month, day, hour, minute);
  }

  // 편집 모드 여부
  bool _isEditMode = false;
  bool get isEditMode => _isEditMode;

  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }

  // 일기 항목을 삭제
  void deleteDiaryEntry(int index) {
    _myDiaryEntries.removeAt(index);
    notifyListeners();
  }

  // 내가 작성한 일기 데이터를 정렬
  void sortMyDiaryEntriesByDate() {
    if (_isSortedByRecent) {
      _sortMyDiaryEntriesByOldest(); // 오래된순으로 정렬
    } else {
      _sortMyDiaryEntriesByRecent(); // 최근순으로 정렬
    }
    _isSortedByRecent = !_isSortedByRecent;
    notifyListeners();
  }

  // 내가 작성한 일기: 최근순 / 오래된순
  final bool _isMyDiaryEntriesSortedByRecent = true;

  // 내가 작성한 일기 리스트 반환
  bool get isMyDiaryEntriesSortedByRecent => _isMyDiaryEntriesSortedByRecent;

  // 내가 작성한 일기 최근순 정렬
  void _sortMyDiaryEntriesByRecent() {
    _myDiaryEntries.sort((a, b) {
      final dateA = _parseDate(a['date']!);
      final dateB = _parseDate(b['date']!);
      return dateB.compareTo(dateA);
    });
  }

  // 내가 작성한 일기 오래된순 정렬
  void _sortMyDiaryEntriesByOldest() {
    _myDiaryEntries.sort((a, b) {
      final dateA = _parseDate(a['date']!);
      final dateB = _parseDate(b['date']!);
      return dateA.compareTo(dateB);
    });
  }

  // 필터링된 일기 항목을 반환 (현재 선택된 연월과 정렬 방식에 따라)
  List<Map<String, String>> get filteredDiaryEntries {
    List<Map<String, String>> filteredEntries = _myDiaryEntries.where((entry) {
      DateTime entryDate = _parseDate(entry['date']!);
      return entryDate.year == _selectedDate.year &&
          entryDate.month == _selectedDate.month;
    }).toList();

    // 정렬 방식에 따라 정렬
    filteredEntries.sort((a, b) {
      final dateA = _parseDate(a['date']!);
      final dateB = _parseDate(b['date']!);
      return _isSortedByRecent
          ? dateB.compareTo(dateA)
          : dateA.compareTo(dateB);
    });

    return filteredEntries;
  }

  // 정렬 방식을 토글
  void toggleSortOrder() {
    _isSortedByRecent = !_isSortedByRecent;
    notifyListeners();
  }

  // 최근순 정렬 리셋
  void resetSortOrder() {
    _isSortedByRecent = false;
    notifyListeners();
  }

  // 모든 상태를 초기화
  void resetAll() {
    notifyListeners();
  }

  // 정렬 상태만 초기화
  void resetSortState() {
    _isSortedByRecent = true; // 기본값을 최근순으로 설정
    notifyListeners();
  }
}
