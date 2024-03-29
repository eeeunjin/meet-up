// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
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
  String phone_number;
  List<dynamic> accepted_policies;

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
    };
  }
}

class MyRoomModel {
  bool isMyRoom;
  DocumentReference room_reference;

  MyRoomModel({
    required this.isMyRoom,
    required this.room_reference,
  });

  MyRoomModel.fromJson(Map<String, Object?> json)
  : this(
    isMyRoom: json['isMyRoom']! as bool,
    room_reference: json['room_reference']! as DocumentReference,
  );

  Map<String, dynamic> toJson() {
    return {
      'isMyRoom': isMyRoom,
      'room_reference': room_reference,
    };
  }
}

class MyEnterRequestModel {
  bool isAccepted;
  DocumentReference room_reference;

  MyEnterRequestModel({
    required this.isAccepted,
    required this.room_reference,
  });

  MyEnterRequestModel.fromJson(Map<String, Object?> json)
  : this(
    isAccepted: json["isAccepted"]! as bool,
    room_reference: json["room_reference"]! as DocumentReference,
  );

  Map<String, dynamic> toJson() {
    return {
      'isAccepted' : isAccepted,
      'room_reference' : room_reference,
    };
  }
}