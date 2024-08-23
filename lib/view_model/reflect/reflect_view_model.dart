import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReflectViewModel with ChangeNotifier {
  final List<int> _selectedImages = [];
  final List<int> completedSelection = [];
  final Map<int, String> _answers = {}; // 답변을 저장할 맵

  final Map<int, TextEditingController> _controllers = {};

  TextEditingController getController(int index) {
    if (!_controllers.containsKey(index)) {
      _controllers[index] = TextEditingController();
    }
    return _controllers[index]!;
  }

  // 질문을 제거할 때 컨트롤러도 함께 제거
  void removeQuestion(int index) {
    _controllers[index]?.dispose();
    _controllers.remove(index);
    _answers.remove(_selectedImages[index]); // 답변도 함께 삭제
    completedSelection.remove(_selectedImages[index]);
    _selectedImages.removeAt(index);
    notifyListeners();
  }

  @override
  void dispose() {
    // 모든 컨트롤러를 해제
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
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

  // 답변을 저장
  void updateAnswer(int questionIndex, String answer) {
    _answers[questionIndex] = answer;
    notifyListeners();
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
}
