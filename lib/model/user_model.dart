// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // 프로필 정보
  String nickname;
  String profile_icon;
  DateTime birthday;
  String gender;
  Map<String, dynamic> region;
  String job;
  List<dynamic> personality_relationship;
  List<dynamic> personality_self;
  List<dynamic> interest;
  List<dynamic> purpose;
  String uid;

  // 재화 정보
  int coin;
  int ticket;
  bool isFixedTicket;
  Timestamp fixed_ticket_end_date;

  // 등급 정보
  String rank;

  // 가입 전화번호
  String phone_number;

  // 마케팅 및 개인정보 수집 선택 동의 항목 (5번, 6번)
  List<dynamic> accepted_policies;

  // 알림 설정 정보
  List<dynamic> notification_settings;

  UserModel({
    required this.nickname,
    required this.profile_icon,
    required this.birthday,
    required this.gender,
    required this.region,
    required this.job,
    required this.personality_relationship,
    required this.personality_self,
    required this.interest,
    required this.purpose,
    required this.phone_number,
    required this.accepted_policies,
    required this.coin,
    required this.ticket,
    required this.isFixedTicket,
    required this.fixed_ticket_end_date,
    required this.rank,
    required this.notification_settings,
    required this.uid,
  });

  UserModel.fromJson(Map<String, Object?> json)
      : this(
          nickname: json['nickname']! as String,
          profile_icon: json['profile_icon']! as String,
          birthday: DateTime.parse(
              (json['birthday']! as Timestamp).toDate().toString()),
          gender: json['gender']! as String,
          region: json['region']! as Map<String, dynamic>,
          job: json['job']! as String,
          personality_relationship:
              json["personality_relationship"]! as List<dynamic>,
          personality_self: json["personality_self"]! as List<dynamic>,
          interest: json["interest"]! as List<dynamic>,
          purpose: json["purpose"]! as List<dynamic>,
          phone_number: json["phone_number"]! as String,
          accepted_policies: json["accepted_policies"]! as List<dynamic>,
          coin: json["coin"]! as int,
          ticket: json["ticket"]! as int,
          isFixedTicket: json["isFixedTicket"]! as bool,
          fixed_ticket_end_date: json["fixed_ticket_end_date"]! as Timestamp,
          rank: json["rank"]! as String,
          notification_settings:
              json["notification_settings"]! as List<dynamic>,
          uid: json["uid"]! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'nickname': nickname,
      'profile_icon': profile_icon,
      'birthday': birthday,
      'gender': gender,
      'region': region,
      'job': job,
      'personality_relationship': personality_relationship,
      'personality_self': personality_self,
      'interest': interest,
      'purpose': purpose,
      'phone_number': phone_number,
      'accepted_policies': accepted_policies,
      'coin': coin,
      'ticket': ticket,
      'isFixedTicket': isFixedTicket,
      'fixed_ticket_end_date': fixed_ticket_end_date,
      'rank': rank,
      'notification_settings': notification_settings,
      'uid': uid,
    };
  }
}

class MyRoomModel {
  bool isMyRoom;
  bool isNew;
  DocumentReference room_reference;

  MyRoomModel({
    required this.isMyRoom,
    required this.isNew,
    required this.room_reference,
  });

  MyRoomModel.fromJson(Map<String, Object?> json)
      : this(
          isMyRoom: json['isMyRoom']! as bool,
          isNew: json['isNew']! as bool,
          room_reference: json['room_reference']! as DocumentReference,
        );

  Map<String, dynamic> toJson() {
    return {
      'isMyRoom': isMyRoom,
      'isNew': isNew,
      'room_reference': room_reference,
    };
  }
}

class MeetingReviewModel {
  String senderUID;
  String roomTitle;
  int rating;
  List<dynamic> chosenChips;
  String comment;
  Timestamp date;

  MeetingReviewModel({
    required this.senderUID,
    required this.roomTitle,
    required this.rating,
    required this.chosenChips,
    required this.comment,
    required this.date,
  });

  MeetingReviewModel.fromJson(Map<String, Object?> json)
      : this(
          senderUID: json["senderUID"]! as String,
          roomTitle: json["roomTitle"]! as String,
          rating: json["rating"]! as int,
          chosenChips: json["chosenChips"]! as List<dynamic>,
          comment: json["comment"]! as String,
          date: json["date"]! as Timestamp,
        );

  Map<String, Object?> toJson() {
    return {
      "senderUID": senderUID,
      "roomTitle": roomTitle,
      "rating": rating,
      "chosenChips": chosenChips,
      "comment": comment,
      "date": date,
    };
  }
}