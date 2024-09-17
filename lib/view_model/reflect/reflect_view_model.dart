import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReflectViewModel with ChangeNotifier {
  final List<int> _selectedImages = [];
  final List<int> completedSelection = [];
  final Map<int, String> _answers = {}; // 답변을 저장할 맵

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

  List<Map<String, String>> get availableEntries => _availableEntries;

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
  ];

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
    // 날짜 부분과 시간 부분을 분리
    final dateTimePart = dateStr.split(' ');
    final datePart = dateTimePart[0]; // 연.월.일
    final period = dateTimePart[2]; // '오후' or '오전'
    final timePart = dateTimePart[3]; // 시간.분

    final dateClean = datePart.split('(')[0];

    final dateComponents = dateClean.split('.');
    final year = int.parse(dateComponents[0]);
    final month = int.parse(dateComponents[1]);
    final day = int.parse(dateComponents[2]);

    // 시간 부분을 ':'으로 나눠서 시간과 분을 가져오기
    final timeComponents = timePart.split(':');
    int hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    // '오후'
    if (period == '오후' && hour != 12) {
      hour += 12;
    }

    // '오전'
    if (period == '오전' && hour == 12) {
      hour = 0;
    }

    return DateTime(year, month, day, hour, minute);
  }

  // 날짜 기준으로 작성 가능한 일기 최신순 정렬
  void sortAvailableEntriesByDate() {
    _availableEntries.sort((a, b) {
      final dateA = _parseDate(a['date']!);
      final dateB = _parseDate(b['date']!);
      return dateB.compareTo(dateA); // 최신순으로 정렬
    });
    notifyListeners();
  }

  bool _isSortedByRecent = false; // 최근순 정렬 여부

  bool get isSortedByRecent => _isSortedByRecent;

  // 날짜 기준으로 내가 작성한 일기 최신순 정렬
  void sortMyDiaryEntriesByDate() {
    _myDiaryEntries.sort((a, b) {
      final dateA = _parseDate(a['date']!);
      final dateB = _parseDate(b['date']!);
      return dateB.compareTo(dateA); // 최신순으로 정렬
    });
    _isSortedByRecent = true; // 최근순 정렬 상태를 true로 변경
    notifyListeners();
  }

  // 최근순 정렬 리셋
  void resetSortOrder() {
    _isSortedByRecent = false; // 최근순 정렬 상태를 false로 초기화
    notifyListeners();
  }
}
