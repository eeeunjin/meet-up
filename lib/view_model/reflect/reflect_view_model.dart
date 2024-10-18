import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/repository/user_repository.dart';

class ReflectViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // MARK: - 작성 가능한 데이터 정보 불러오기 (mySchedule)
  final List<RoomModel> _availableEntries = [];

  // _userRepository 의 mySchedule 데이터를 Stream 데이터로 불러오기
  Stream<QuerySnapshot<Object?>> getMyScheduleStream({required String uid}) {
    return _userRepository.readMyScheduleCollectionStream(uid: uid);
  }

  // Schedule Stream 데이터를 받아와 _availableEntries 에 저장
  void setAvailableEntries(List<RoomModel> mySchedules) {
    _availableEntries.clear();
    for (var schedule in mySchedules) {
      if (schedule.room_schedule!['date'].toDate().isBefore(DateTime.now())) {
        if (schedule.roomId != "diary") {
          _availableEntries.add(schedule);
        }
      }
    }
  }

  // MARK: - 정렬
  bool _isSortedByRecent = true;
  bool get isSortedByRecent => _isSortedByRecent;

  // 작성 가능한 일기 데이터 최신순/오래된순 정렬
  void sortAvailableEntriesByDate() {
    _isSortedByRecent = !_isSortedByRecent;
    notifyListeners();
  }

  // 정렬된 상태의 일기를 반환
  List<RoomModel> get availableEntries {
    if (_availableEntries.isEmpty) {
      return [];
    }

    List<RoomModel> sortedEntries = List.from(_availableEntries);
    sortedEntries.sort((a, b) {
      final dateA = a.room_schedule!['date'].toDate();
      final dateB = b.room_schedule!['date'].toDate();
      return _isSortedByRecent
          ? dateB.compareTo(dateA) // 최근순 정렬
          : dateA.compareTo(dateB); // 오래된순 정렬
    });
    return sortedEntries;
  }

  // MARK: - 상태 초기화
  // 정렬 상태 초기화 (최근순)
  void resetSortOrder() {
    _isSortedByRecent = false;
    notifyListeners();
  }
}
