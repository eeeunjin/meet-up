import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/user_repository.dart';

class ProfileReviewViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // 불러온 리뷰 데이터
  List<MeetingReviewModel> _reviews = [];
  List<MeetingReviewModel> get reviews => _reviews;

  // 선택된 리뷰 데이터
  MeetingReviewModel? _selectedReview;
  MeetingReviewModel? get selectedReview => _selectedReview;

  // 편집 모드
  bool isEditing = false;

  // 선택된 리뷰 박스
  final List<MeetingReviewModel> _selectedEditReviews = [];
  List<MeetingReviewModel> get selectedEditReviews => _selectedEditReviews;

  // 상호 평가 데이터 불러오기
  Stream<QuerySnapshot<Object?>> loadReviewData({required String uid}) {
    return _userRepository.readMeetingReviewCollectionStream(uid: uid);
  }

  // 불러온 데이터 저장하기
  void saveReviewData(List<MeetingReviewModel> reviews) {
    _reviews = reviews;
  }

  // 현재 정보를 그룹 데이터로 반환
  Map<String, List<MeetingReviewModel>> getGroupedReviews() {
    Map<String, List<MeetingReviewModel>> groupedReviews = {};

    for (MeetingReviewModel review in reviews) {
      final date = review.date.toDate();
      final dateformatter = DateFormat('yyyy.MM.dd');
      final dateString = dateformatter.format(date);

      if (groupedReviews.containsKey(dateString)) {
        groupedReviews[dateString]!.add(review);
      } else {
        groupedReviews[dateString] = [review];
      }
    }
    return groupedReviews;
  }

  // MeetReview.isNew 필드를 false로 변경
  Future<bool> updateMeetingReviewModel(
      {required uid, required meetingReviewId}) async {
    return await _userRepository.updateMeetingReviewModel(
      uid: uid,
      meetingReviewId: meetingReviewId,
      data: {'isNew': false},
    );
  }

  // 선택된 리뷰 저장
  void setSelectedReview(MeetingReviewModel review) {
    _selectedReview = review;
    notifyListeners();
  }

  // 편집 모드 활성화/비활성화
  void toggleEditMode() {
    isEditing = !isEditing;
    notifyListeners();
  }

  // 리뷰 박스가 선택되었을 때, 컨트롤 함수
  void setSelectedEditReviews(MeetingReviewModel review) {
    if (_selectedEditReviews
        .where((element) =>
            element.meetingReviewDocId == review.meetingReviewDocId)
        .isNotEmpty) {
      _selectedEditReviews.removeWhere(
          (element) => element.meetingReviewDocId == review.meetingReviewDocId);
    } else {
      _selectedEditReviews.add(review);
    }
    notifyListeners();
  }

  // 선택된 리뷰 리스트 초기화
  void resetSelectedEditReviews() {
    _selectedEditReviews.clear();
  }

  // 전체 선택
  void selectAllReviews() {
    if (_selectedEditReviews.length == reviews.length) {
      resetSelectedEditReviews();
    } else {
      resetSelectedEditReviews();
      _selectedEditReviews.addAll(reviews);
    }
    notifyListeners();
  }

  // 선택된 리뷰 DB에서 삭제
  Future<void> deleteSelectedReviews(String uid) async {
    for (MeetingReviewModel review in _selectedEditReviews) {
      await _userRepository.deleteMeetingReviewModel(
        uid: uid,
        meetingReviewId: review.meetingReviewDocId,
      );
    }
    resetSelectedEditReviews();
    // notifiy 안해도 streamBuilder에서 자동으로 업데이트 됨
  }

  // reset all states
  void resetAllStates() {
    _reviews.clear();
    _selectedReview = null;
    isEditing = false;
    _selectedEditReviews.clear();
  }
}
