import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/repository/user_repository.dart';

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

  // ExpansionPanel 토글
  void toggleDatePanel() {
    _isDatePanelExpanded = !_isDatePanelExpanded; // 상태 반전
    notifyListeners();
  }

  // timePicker
  bool _isTimePanelExpanded = false;

  bool get isTimePanelExpanded => _isTimePanelExpanded;

  // ExpansionPanel 토글
  void toggleTimePanel() {
    _isTimePanelExpanded = !_isTimePanelExpanded;
    notifyListeners();
  }

  // check

  bool get allCheckCompleted {
    return namingCompleted;
  }
}
