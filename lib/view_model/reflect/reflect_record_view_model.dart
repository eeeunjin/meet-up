import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/model/diary_model.dart';
import 'package:meet_up/repository/user_repository.dart';

class ReflectRecordViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // 내가 작성한 일기 데이터
  List<DiaryModel> _myDiaryEntries = [];
  List<DiaryModel>? get myDiaryEntries => _myDiaryEntries;

  String? _selectedDiaryId;
  DateTime _selectedDate = DateTime.now(); // 선택된 연/월 저장
  DateTime _displayedDate = DateTime.now(); // 팝업에서 표시용 연/월 저장

  String? get selectedDiaryId => _selectedDiaryId;
  DateTime get selectedDate => _selectedDate;
  DateTime get displayedDate => _displayedDate;

  DiaryModel? _selectedDiary;
  DiaryModel? get selectedDiary => _selectedDiary;

  // 내가 작성한 일기 데이터 불러오기
  Stream<QuerySnapshot<Object?>> getMyDiaryEntriesStream(
      {required String uid}) {
    return _userRepository.readMyDiaryCollectionStream(uid: uid);
  }

  // 내가 작성한 일기 정보 삭제
  Future<void> deleteMyDiaryEntry(String uid, String diaryId) async {
    await _userRepository.deleteMyDiaryDocument(uid: uid, diaryId: diaryId);
  }

  void setMyDiaryEntries(List<DiaryModel> myDiaryEntries) {
    _myDiaryEntries = myDiaryEntries;
  }

  void setSelectedDiary(DiaryModel diary) {
    _selectedDiary = diary;
  }

  // 연도와 월을 표시용으로 초기화 (팝업 열릴 때)
  void initializeDisplayedDate() {
    _displayedDate = _selectedDate;
  }

  void confirmSelectedDate() {
    _selectedDate = _displayedDate;
    notifyListeners();
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

  // 작성된 일기가 있는 연/월을 확인
  bool isMonthWritten(int month, int year) {
    // _myDiaryEntries가 null이 아닌지 확인
    if (_myDiaryEntries.isEmpty) {
      return false;
    }

    return _myDiaryEntries.any((entry) {
      DateTime entryDate = entry.date.toDate();
      return entryDate.month == month && entryDate.year == year;
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
      final dateA = a.date.toDate();
      final dateB = b.date.toDate();
      return dateB.compareTo(dateA); // 최근순 정렬
    });
  }

  // 편집 모드 여부
  bool _isEditMode = false;
  bool get isEditMode => _isEditMode;

  void toggleEditMode() {
    _isEditMode = !_isEditMode;
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

  // 내가 작성한 일기 최근순 정렬
  void _sortMyDiaryEntriesByRecent() {
    _myDiaryEntries.sort((a, b) {
      final dateA = a.date.toDate();
      final dateB = b.date.toDate();
      return dateB.compareTo(dateA);
    });
  }

  // 내가 작성한 일기 오래된순 정렬
  void _sortMyDiaryEntriesByOldest() {
    _myDiaryEntries.sort((a, b) {
      final dateA = a.date.toDate();
      final dateB = b.date.toDate();
      return dateA.compareTo(dateB);
    });
  }

  // 필터링된 일기 항목을 반환 (현재 선택된 연월과 정렬 방식에 따라)
  List<DiaryModel> get filteredDiaryEntries {
    List<DiaryModel> filteredEntries = _myDiaryEntries.where((entry) {
      DateTime entryDate = entry.date.toDate();
      return entryDate.year == _selectedDate.year &&
          entryDate.month == _selectedDate.month;
    }).toList();

    // 정렬 방식에 따라 정렬
    filteredEntries.sort((a, b) {
      final dateA = a.date.toDate();
      final dateB = b.date.toDate();
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

  // 모든 상태를 초기화
  void resetAll() {
    _myDiaryEntries.clear();
    _selectedDiaryId = null;
    _selectedDate = DateTime.now();
    _displayedDate = DateTime.now();
    _isSortedByRecent = true;
    _isEditMode = false;
    notifyListeners();
  }
}
