// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  List<dynamic> accepted_policies;
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
  int coin;
  int ticket;
  bool isFixedTicket;
  Timestamp fixed_ticket_end_date;

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
      'isAccepted': isAccepted,
      'room_reference': room_reference,
    };
  }
}

class MyGoodsHistoryModel {
  DocumentReference gh_reference;
  Timestamp gh_change_date;

  MyGoodsHistoryModel({
    required this.gh_reference,
    required this.gh_change_date,
  });

  MyGoodsHistoryModel.fromJson(Map<String, Object?> json)
      : this(
          gh_reference: json["gh_reference"]! as DocumentReference,
          gh_change_date: json["gh_change_date"]! as Timestamp,
        );

  Map<String, dynamic> toJson() {
    return {
      'gh_reference': gh_reference,
      'gh_change_date': gh_change_date,
    };
  }
}

class MyTickets {
  int number_of_times_available;
  bool isUsed;
  DocumentReference roomReference;

  MyTickets({
    required this.number_of_times_available,
    required this.isUsed,
    required this.roomReference,
  });

  MyTickets.fromJson(Map<String, Object?> json)
      : this(
          number_of_times_available: json["number_of_times_available"]! as int,
          isUsed: json["isUsed"]! as bool,
          roomReference: json["roomReference"]! as DocumentReference,
        );

  Map<String, Object?> toJson() {
    return {
      "number_of_times_available": number_of_times_available,
      "isUsed": isUsed,
      "roomReference": roomReference,
    };
  }
}
