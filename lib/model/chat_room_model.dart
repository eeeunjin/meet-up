// 채팅방 정보를 담는 모델
// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  // 방 정보를 담고 있는 레퍼런스
  DocumentReference room_reference;
  // 방이 삭제되었는지 여부
  bool isDeleted;

  ChatRoomModel({
    required this.room_reference,
    required this.isDeleted,
  });

  ChatRoomModel.fromJson(Map<String, Object?> json)
      : this(
          room_reference: json['room_reference']! as DocumentReference,
          isDeleted: json['isDeleted']! as bool,
        );

  Map<String, Object?> toJson() {
    return {
      'room_reference': room_reference,
      'isDeleted': isDeleted,
    };
  }
}

class ChatModel {
  // 작성자 uid
  String uid;
  // 작성자 nickName
  String nickName;
  // 채팅 내용
  String content;
  // 채팅 작성 일자
  Timestamp date;
  // 방 레퍼런스
  String room_id;
  // 타입
  // enter, exit, chat, schedule_write,
  String type;

  ChatModel({
    required this.uid,
    required this.nickName,
    required this.content,
    required this.date,
    required this.room_id,
    required this.type,
  });

  ChatModel.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          nickName: json['nickName']! as String,
          content: json['Content']! as String,
          date: json['date']! as Timestamp,
          room_id: json['room_reference']! as String,
          type: json['type']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'nickName': nickName,
      'Content': content,
      'date': date,
      'room_reference': room_id,
      'type': type,
    };
  }
}
