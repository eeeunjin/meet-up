import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

class ChatRoomMeetingReviewViewModel with ChangeNotifier {
  final RoomRepository _roomRepository = RoomRepository();
  final UserRepository _userRepository = UserRepository();

  int _rating = 0;
  int get rating => _rating;

  List<UserModel>? _uesrModels;
  List<UserModel>? get userModels => _uesrModels;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  String _comment = '';
  String get comment => _comment;

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

  void setUserModels(List<UserModel> userModels, String myUID) {
    _uesrModels = List.from(userModels);
    _uesrModels!.removeWhere((user) => user.uid == myUID);

    notifyListeners();
  }

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

  // 이미지 칩이 선택되었는지
  bool isSelected(String chipName) {
    return selectedChips[chipName] ?? false;
  }

  // 다음 페이지로 이동
  void setPage(int page) {
    _currentPage = page;
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
    _currentPage = 0;
  }

  // 만남 후기 데이터를 서버로 전송
  Future<void> sendMeetingReview(
      String roomId, String myUID, String otherUID, String roomName) async {
    final roomMeetingReviewData = "${myUID}_$otherUID";
    final data = {
      "room_meeting_review": FieldValue.arrayUnion([roomMeetingReviewData])
    };

    // room Model에 정보 추가
    await _roomRepository.updateRoomDocument(roomId: roomId, data: data);

    // user Model 하위에 meetingReview model 추가
    MeetingReviewModel meetingReviewModel = MeetingReviewModel(
      senderUID: myUID,
      roomTitle: roomName,
      rating: _rating,
      chosenChips:
          selectedChips.keys.where((key) => selectedChips[key]!).toList(),
      comment: _comment,
      date: Timestamp.now(),
    );

    await _userRepository.createMeetingReviewDocument(
        data: meetingReviewModel, uid: otherUID);

    notifyListeners();
  }
}
