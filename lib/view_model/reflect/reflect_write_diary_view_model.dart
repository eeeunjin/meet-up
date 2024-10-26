import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/diary_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/repository/user_repository.dart';

class ReflectWriteDiaryViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // Schedule 관련 변수
  RoomModel? _scheduleModel;
  RoomModel? get scheduleModel => _scheduleModel;

  // 선택된 질문
  final List<int> _selectedImages = [];
  List<int> get selectedImages => _selectedImages;

  // 질문 추가 중인지 여부
  bool _addQeustion = false;
  bool get addQeustion => _addQeustion;

  final List<int> completedSelection = [];

  final Map<int, String> _answers = {}; // 답변을 저장할 맵
  Map<int, String> get answers => _answers;

  bool _isFromDiaryMore = false;
  bool get isFromDiaryMore => _isFromDiaryMore;

  void setScheduleModel(RoomModel scheduleModel) {
    _scheduleModel = scheduleModel;
  }

  void setIsFromDiaryMore(bool value) {
    _isFromDiaryMore = value;
    notifyListeners();
  }

  void setAddQuestion(bool value) {
    _addQeustion = value;
    notifyListeners();
  }

  // 답변 업데이트
  void updateAnswer(int questionIndex, String answer) {
    _answers[questionIndex] = answer;
  }

  // 질문을 제거할 때 답변도 함께 제거
  void removeQuestion(int index) {
    _answers.remove(index);
    completedSelection.removeWhere((element) => element == index);
    notifyListeners();
  }

  // 별점 관련 변수
  final List<int> ratings = List<int>.filled(6, 0);

  void toggleSelection(int index) {
    if (_selectedImages.contains(index)) {
      _selectedImages.remove(index);
    } else {
      if (_selectedImages.length + completedSelection.length < 3) {
        _selectedImages.add(index);
      }
    }
    notifyListeners();
  }

  bool isSelected(int index) {
    return _selectedImages.contains(index);
  }

  void markAsCompleted() {
    completedSelection.addAll(_selectedImages); // 선택된 이미지를 추가
    notifyListeners();
  }

  Map<int, String> getSelectedQuestions() {
    final questions = [
      '어떤 만남이었는지 설명한다면?',
      '해당 만남에서 좋았던 점은?',
      '해당 만남에서 아쉬웠던 점은?',
      '해당 만남을 통해 새로 알게 된 점은?',
      '해당 만남을 한 줄로 표현한다면?'
    ];

    Map<int, String> selectedQuestions = {};
    for (var index in completedSelection) {
      selectedQuestions[index] = questions[index];
    }

    return selectedQuestions;
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
    return completedSelection.isNotEmpty &&
        answers.values.length == completedSelection.length &&
        answers.values.where((element) => element.isEmpty).isEmpty;
  }

  // 모든 질문에 답변과 별점이 매겨졌는지 확인
  bool get canSubmit {
    // 질문이 하나도 선택되지 않은 경우
    // 질문이 선택된 경우에는 기존 로직을 따름
    return allQuestionsAnswered() && allRatingsCompleted();
  }

  // 질문 추가하다 뒤로 간 경우 선택된 질문 초기화
  void resetSelectedImages() {
    _selectedImages.clear();
  }

  // DiaryModel 저장
  Future<void> createDiary(
      {required String uid, required DiaryModel diary}) async {
    await _userRepository.createMyDiaryDocument(data: diary, uid: uid);
  }

  // ScheduleModel 업데이트
  Future<void> updateScheduleModel({
    required String uid,
    required RoomModel data,
  }) async {
    await _userRepository.updateMyScheduleDocument(
      data: data,
      uid: uid,
    );
  }

  // ScheduleModel 업데이트
  Future<void> updateScheduleModelbyMapData({
    required String uid,
    required String scheduleId,
    required Map<String, dynamic> data,
  }) async {
    await _userRepository.updateMyScheduleDocumentByMapData(
      data: data,
      scheduleId: scheduleId,
      uid: uid,
    );
  }

  // 상태 초기화
  void resetState() {
    _scheduleModel = null;
    _selectedImages.clear();
    completedSelection.clear();
    _answers.clear();
    ratings.fillRange(0, ratings.length, 0);
    notifyListeners();
  }
}
