// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  String roomId; // 방 고유 번호

  String room_name;
  String room_category;
  String room_category_detail;
  String room_region_province;
  String room_region_district;
  List<dynamic> room_keyword;
  String room_description;
  List<dynamic> room_age;
  String room_gender_ratio;
  List<dynamic> room_rules;
  Timestamp room_creation_date;
  DocumentReference room_owner_reference;
  List<dynamic> room_participant_reference;
  Map<String, dynamic>? room_schedule;
  bool isScheduleDecided;
  List<dynamic> room_meeting_review;
  String recentMessage; // 가장 최근 메시지
  bool isRoomDeleted;

  RoomModel({
    this.roomId = '',
    required this.room_name,
    required this.room_category,
    required this.room_category_detail,
    required this.room_region_province,
    required this.room_region_district,
    required this.room_keyword,
    required this.room_description,
    required this.room_age,
    required this.room_gender_ratio,
    required this.room_rules,
    required this.room_creation_date,
    required this.room_owner_reference,
    required this.room_participant_reference,
    this.room_schedule,
    required this.isScheduleDecided,
    required this.room_meeting_review,
    required this.recentMessage,
    required this.isRoomDeleted,
  });

  RoomModel clone() {
    return RoomModel(
      room_name: room_name,
      room_category: room_category,
      room_category_detail: room_category_detail,
      room_region_province: room_region_province,
      room_region_district: room_region_district,
      room_keyword: room_keyword,
      room_description: room_description,
      room_age: room_age,
      room_gender_ratio: room_gender_ratio,
      room_rules: room_rules,
      room_creation_date: room_creation_date,
      room_owner_reference: room_owner_reference,
      room_participant_reference: room_participant_reference,
      roomId: roomId,
      room_schedule: room_schedule,
      isScheduleDecided: isScheduleDecided,
      room_meeting_review: room_meeting_review,
      recentMessage: recentMessage,
      isRoomDeleted: isRoomDeleted,
    );
  }

  RoomModel.fromJson(Map<String, Object?> json)
      : this(
          room_name: json['room_name']! as String,
          room_category: json['room_category']! as String,
          room_category_detail: json['room_category_detail']! as String,
          room_region_province: json['room_region_province']! as String,
          room_region_district: json['room_region_district']! as String,
          room_keyword: json['room_keyword']! as List<dynamic>,
          room_description: json['room_description']! as String,
          room_age: json['room_age']! as List<dynamic>,
          room_gender_ratio: json['room_gender_ratio']! as String,
          room_rules: json['room_rules']! as List<dynamic>,
          room_creation_date: json['room_creation_date']! as Timestamp,
          room_owner_reference:
              json['room_owner_reference']! as DocumentReference,
          room_participant_reference:
              json['room_participant_reference']! as List<dynamic>,
          roomId: json['roomId']! as String,
          room_schedule: json['room_schedule'] as Map<String, dynamic>?,
          isScheduleDecided: json['isScheduleDecided']! as bool,
          room_meeting_review: json['room_meeting_review']! as List<dynamic>,
          recentMessage: json['recentMessage']! as String,
          isRoomDeleted: json['isRoomDeleted']! as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'roomId': roomId,
      'room_name': room_name,
      'room_category': room_category,
      'room_category_detail': room_category_detail,
      'room_region_province': room_region_province,
      'room_region_district': room_region_district,
      'room_keyword': room_keyword,
      'room_description': room_description,
      'room_age': room_age,
      'room_gender_ratio': room_gender_ratio,
      'room_rules': room_rules,
      'room_creation_date': room_creation_date,
      'room_owner_reference': room_owner_reference,
      'room_participant_reference': room_participant_reference,
      'room_schedule': room_schedule,
      'isScheduleDecided': isScheduleDecided,
      'room_meeting_review': room_meeting_review,
      'recentMessage': recentMessage,
      'isRoomDeleted': isRoomDeleted,
    };
  }
}

class RoomSchedule {
  String title;
  Timestamp date;
  String location;
  List<dynamic>? participants_agree_selected_schedule;

  RoomSchedule({
    required this.title,
    required this.date,
    required this.location,
    required this.participants_agree_selected_schedule,
  });

  RoomSchedule.fromJson(Map<String, Object?> json)
      : this(
          title: json['title']! as String,
          date: json['date']! as Timestamp,
          location: json['location']! as String,
          participants_agree_selected_schedule:
              json['participants_agree_selected_schedule'] as List<dynamic>?,
        );

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'date': date,
      'location': location,
      'participants_agree_selected_schedule':
          participants_agree_selected_schedule,
    };
  }
}

class FilterInfo {
  // 만남방 검색 필터
  String? room_category;
  String? room_category_detail;
  String? room_region_province;
  String? room_region_district;
  String? room_age;
  String? room_gender_ratio;
  List<bool>? room_rules;

  // 코인 이용 내역 필터
  String? uid;
  String? type;

  // 채팅 방 필터
  DocumentReference? room_reference;

  FilterInfo({
    this.room_category,
    this.room_category_detail,
    this.room_region_province,
    this.room_region_district,
    this.room_age,
    this.room_gender_ratio,
    this.room_rules,
    this.uid,
    this.type,
    this.room_reference,
  });
}
