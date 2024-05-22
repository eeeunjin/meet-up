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
        roomId: roomId);
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
    };
  }
}

class EnterRequestModel {
  Timestamp end_date_time;
  String requester_uid;
  bool isAccepted;

  EnterRequestModel(
      {required this.end_date_time,
      required this.requester_uid,
      required this.isAccepted});

  EnterRequestModel.fromJson(Map<String, Object?> json)
      : this(
          end_date_time: json['end_date_time']! as Timestamp,
          requester_uid: json['requester_uid']! as String,
          isAccepted: json['isAccepted']! as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'end_date_time': end_date_time,
      'requester_uid': requester_uid,
      'isAccepted': isAccepted,
    };
  }
}

class FilterInfo {
  String? room_category;
  String? room_category_detail;
  String? room_region_province;
  String? room_region_district;
  String? room_age;
  String? room_gender_ratio;
  List<bool>? room_rules;

  FilterInfo({
    this.room_category,
    this.room_category_detail,
    this.room_region_province,
    this.room_region_district,
    this.room_age,
    this.room_gender_ratio,
    this.room_rules,
  });
}
