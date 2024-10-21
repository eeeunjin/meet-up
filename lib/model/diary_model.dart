import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  String diaryDocId; // 일기 문서 ID
  String scheduleDocId; // 일정 문서 ID
  bool isPersonalSchedule; // true: 개인 일정, false: 팀 일정
  String title; // 일정 제목
  Timestamp date; // 일정 날짜

  // 입력 정보
  Map<String, dynamic> reviews; // 각 항목에 대한 리뷰 내용
  List<dynamic> meetingScores; // 만남 평가 점수

  DiaryModel({
    required this.diaryDocId,
    required this.scheduleDocId,
    required this.isPersonalSchedule,
    required this.title,
    required this.date,
    required this.reviews,
    required this.meetingScores,
  });

  DiaryModel.fromJson(Map<String, Object?> json)
      : this(
          diaryDocId: json['diaryDocId']! as String,
          scheduleDocId: json['scheduleDocId']! as String,
          isPersonalSchedule: json['isPersonalSchedule']! as bool,
          title: json['title']! as String,
          date: json['date']! as Timestamp,
          reviews: json['reviews']! as Map<String, dynamic>,
          meetingScores: json['meetingScores']! as List<dynamic>,
        );

  Map<String, Object?> toJson() {
    return {
      'diaryDocId': diaryDocId,
      'scheduleDocId': scheduleDocId,
      'isPersonalSchedule': isPersonalSchedule,
      'title': title,
      'date': date,
      'reviews': reviews,
      'meetingScores': meetingScores,
    };
  }
}
