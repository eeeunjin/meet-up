import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/repository/user_repository.dart';
import 'package:intl/intl.dart';

class ChatViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // myRoom 정보 불러오기
  Stream<QuerySnapshot<Object?>> readMyRoomCollectionStream({
    required String uid,
  }) {
    return _userRepository.readMyRoomCollectionStream(
      uid: uid,
      findAll: true,
    );
  }

  // myRoom 정보 업데이트 (isNew 변수)
  Future<void> updateMyRoomInfo({
    required String uid,
    required String roomId,
    required Map<String, dynamic> data,
  }) async {
    await _userRepository.updateMyRoomDocument(
      uid: uid,
      data: data,
      roomId: roomId,
    );
  }

  // MARK: - 공지 온보딩
  bool _isChecked = false;

  bool get isChecked => _isChecked;

  void toggleChecked() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

// MARK: - 만남 후기

  int _rating = 0;
  int get rating => _rating;

  Map<String, bool> selectedChips = {
    'chatReview1': false,
    'chatReview2': false,
    'chatReview3': false,
    'chatReview4': false,
    'chatReview5': false,
    'chatReview6': false,
    'chatReview7': false,
    'chatReview8': false,
    'chatReview9': false,
    'chatReview10': false,
    'chatReview11': false,
    'chatReview12': false,
  };

// 이미지칩을 선택/해제
  void toggleChip(String chipName) {
    if (selectedChips.containsKey(chipName)) {
      selectedChips[chipName] = !selectedChips[chipName]!;
      checkReviewCompletion();
      notifyListeners();
    }
  }

// 코멘트 설정
  void setComment(String comment) {
    _comment = comment;
    checkReviewCompletion();
    notifyListeners();
  }

// 별점에 따른 이미지 리스트 반환
  List<String> get images {
    if (_rating == 0 || _rating >= 3) {
      return [
        'chatReview1',
        'chatReview2',
        'chatReview3',
        'chatReview4',
        'chatReview5',
        'chatReview6'
      ];
    } else {
      return [
        'chatReview7',
        'chatReview8',
        'chatReview9',
        'chatReview10',
        'chatReview11',
        'chatReview12'
      ];
    }
  }

// 이미지칩이 선택되었는지
  bool isSelected(String chipName) {
    return selectedChips[chipName] ?? false;
  }

  int _currentPage = 0;
  int get currentPage => _currentPage;

  String _comment = '';
  String get comment => _comment;

// 다음 페이지로 이동
  void nextPage() {
    _currentPage++;
    if (_currentPage < 3) {
      _rating = 0;
      selectedChips.updateAll((key, value) => false);
      _comment = '';
    }
    notifyListeners();
  }

  bool get isReviewComplete {
    return rating > 0 &&
        selectedChips.values.any((isSelected) => isSelected) &&
        comment.length >= 20 &&
        comment.length <= 100;
  }

  void checkReviewCompletion() {
    notifyListeners();
  }

  // 모든 데이터를 초기화하는 메서드 추가
  void resetData() {
    _rating = 0;
    selectedChips.updateAll((key, value) => false);
    _comment = '';
    _currentPage = 0;
    notifyListeners();
  }

  // 별점 설정 시 기존 데이터 초기화
  void setRating(int rating) {
    resetData(); // 데이터 초기화
    _rating = rating;
    checkReviewCompletion();
    notifyListeners();
  }

  // 뒤로 나갔다 올 때 데이터 초기화
  void onBackPressed() {
    resetData();
  }
}
