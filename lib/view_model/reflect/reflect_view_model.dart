import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReflectViewModel with ChangeNotifier {
  final List<int> _selectedImages = [];
  final List<int> completedSelection = [];
  final Map<int, String> _answers = {}; // 답변을 저장할 맵

  String? _selectedDiaryId;
  DateTime _selectedDate = DateTime.now(); // 선택된 연/월 저장
  DateTime _displayedDate = DateTime.now(); // 팝업에서 표시용 연/월 저장

  String? get selectedDiaryId => _selectedDiaryId;
  DateTime get selectedDate => _selectedDate;
  DateTime get displayedDate => _displayedDate;

  void selectDiaryId(String diaryId) {
    _selectedDiaryId = diaryId;
    notifyListeners();
  }

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

  // 답변 업데이트
  void updateAnswer(int questionIndex, String answer) {
    _answers[questionIndex] = answer;
    notifyListeners();
  }

  // 질문을 제거할 때 답변도 함께 제거
  void removeQuestion(int index) {
    _answers.remove(_selectedImages[index]);
    completedSelection.remove(_selectedImages[index]);
    _selectedImages.removeAt(index);
    notifyListeners();
  }

  List<int> get selectedImages => _selectedImages;

  // 별점 관련 변수
  final List<int> ratings = List<int>.filled(6, 0);

  // 상태 초기화
  void reset() {
    _selectedImages.clear();
    completedSelection.clear();
    _answers.clear();
    ratings.fillRange(0, ratings.length, 0);
    notifyListeners();
  }

  void toggleSelection(int index) {
    if (_selectedImages.contains(index)) {
      _selectedImages.remove(index);
    } else {
      if (_selectedImages.length < 3) {
        _selectedImages.add(index);
      }
    }
    notifyListeners();
  }

  bool isSelected(int index) {
    return _selectedImages.contains(index);
  }

  void markAsCompleted() {
    completedSelection.clear();
    completedSelection.addAll(_selectedImages); // 선택된 이미지를 추가
    notifyListeners();
  }

  List<String> getSelectedQuestions() {
    final questions = [
      '어떤 만남이었는지 설명한다면?',
      '해당 만남에서 좋았던 점은?',
      '해당 만남에서 아쉬웠던 점은?',
      '해당 만남을 통해 새로 알게 된 점은?',
      '해당 만남을 한 줄로 표현한다면?'
    ];

    return _selectedImages.map((index) => questions[index]).toList();
  }

  bool canSelectMoreQuestions() {
    return _selectedImages.length < 3;
  }

  // 별점 설정
  void setRating(int questionIndex, int rating) {
    ratings[questionIndex] = rating;
    notifyListeners();
  }

  // 총점 계산
  double calculateTotalRating() {
    if (ratings.isEmpty) return 0.0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  // 모든 질문에 별점이 매겨졌는지 확인
  bool allRatingsCompleted() {
    return ratings.every((rating) => rating > 0);
  }

  // 모든 질문에 답변이 입력되었는지 확인
  bool allQuestionsAnswered() {
    return _answers.length == _selectedImages.length &&
        _answers.values.every((answer) => answer.isNotEmpty);
  }

  // 모든 질문에 답변과 별점이 매겨졌는지 확인
  bool get canSubmit {
    // 질문이 하나도 선택되지 않은 경우
    if (_selectedImages.isEmpty) {
      return allRatingsCompleted(); // 별점이 모두 선택된 경우에만 저장 가능
    }

    // 질문이 선택된 경우에는 기존 로직을 따름
    return allQuestionsAnswered() && allRatingsCompleted();
  }

  // 제목 길이 제한
  String getLimitedTitle(String title) {
    if (title.length > 16) {
      return title.substring(0, 16);
    }
    return title;
  }

  // 작성 가능한 일기 데이터
  final List<Map<String, String>> _availableEntries = [
    {'title': '초보 클밍 모임', 'date': '2024.02.07. (수) 오후 7:30'},
    {'title': '돼지 파티', 'date': '2024.02.09. (금) 오후 7:30'},
    {'title': '제로부터 시작하는 오타쿠', 'date': '2024.02.07. (수) 오후 7:30'},
    {'title': '인생 상담', 'date': '2024.02.07. (수) 오후 7:30'},
  ];

  List<Map<String, String>> get availableEntries {
    // 정렬된 상태의 일기를 반환
    List<Map<String, String>> sortedEntries = List.from(_availableEntries);
    sortedEntries.sort((a, b) {
      final dateA = _parseDate(a['date']!);
      final dateB = _parseDate(b['date']!);
      return _isSortedByRecent
          ? dateB.compareTo(dateA) // 최근순 정렬
          : dateA.compareTo(dateB); // 오래된순 정렬
    });
    return sortedEntries;
  }

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
  // 기본값을 최근순으로 설정
  bool _isSortedByRecent = true;
  bool get isSortedByRecent => _isSortedByRecent;

  ReflectViewModel() {
    _sortByRecent(); // 뷰모델 초기화 시 기본값으로 "최근순" 정렬
  }
  List<Map<String, String>> get myDiaryEntries => _myDiaryEntries;

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

// 작성 가능한 일기 데이터 최신순/오래된순 정렬
  void sortAvailableEntriesByDate() {
    _isSortedByRecent = !_isSortedByRecent;
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

  // 작성 가능한 일기: 최근순 / 오래된순
  final bool _isAvailableEntriesSortedByRecent = true;

  // 내가 작성한 일기: 최근순 / 오래된순
  final bool _isMyDiaryEntriesSortedByRecent = true;

  // 내가 작성한 일기 리스트 반환
  bool get isAvailableEntriesSortedByRecent =>
      _isAvailableEntriesSortedByRecent;
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

  // 최근순 정렬
  void _sortByRecent() {
    _myDiaryEntries.sort((a, b) {
      final dateA = _parseDate(a['date']!);
      final dateB = _parseDate(b['date']!);
      return dateB.compareTo(dateA); // 최근순 정렬
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
    _selectedImages.clear();
    completedSelection.clear();
    _answers.clear();
    ratings.fillRange(0, ratings.length, 0);
    _isEditMode = false;
    _selectedDate = DateTime.now(); // 날짜를 현재로 초기화

    _isSortedByRecent = true;
    _sortByRecent(); // 초기 정렬을 최근순으로 설정

    notifyListeners();
  }

// 정렬 상태만 초기화
  void resetSortState() {
    _isSortedByRecent = true; // 기본값을 최근순으로 설정
    _sortByRecent(); // 최근순으로 정렬
    notifyListeners();
  }
}
