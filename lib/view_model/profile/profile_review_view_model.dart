import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileReviewViewModel with ChangeNotifier {
  bool isEditing = false;
  Map<int, bool> selectedReviews = {};
  Map<String, List<Map<String, dynamic>>> groupedReviews = {
    '2000.00.00': [
      {
        'id': 1,
        'title': '클라이밍 좋아클라.',
        'sender': '발신자 | 초보 클밍이',
        'rating': 4,
        'isNew': false,
      },
      {
        'id': 2,
        'title': '클라이밍 좋아!',
        'sender': '발신자 | 중수 클밍이',
        'rating': 2,
        'isNew': true,
      },
    ],
  };

  // 편집 모드 활성화/비활성화
  void toggleEditMode() {
    isEditing = !isEditing;
    notifyListeners();
  }

  // 특정 리뷰 체크박스 선택/해제
  void toggleSelection(int reviewId) {
    if (selectedReviews.containsKey(reviewId)) {
      selectedReviews[reviewId] = !selectedReviews[reviewId]!;
    } else {
      selectedReviews[reviewId] = true;
    }
    notifyListeners();
  }

  bool isSelected(int reviewId) {
    return selectedReviews[reviewId] ?? false;
  }

  // 선택된 리뷰 삭제 로직
  void deleteSelectedReviews() {
    groupedReviews.forEach((date, reviews) {
      reviews.removeWhere((review) => selectedReviews[review['id']] == true);
    });
    selectedReviews.clear(); // 선택된 목록 초기화
    notifyListeners();
  }
}
