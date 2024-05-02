import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

class ChatViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final RoomRepository _roomRepository = RoomRepository();

  // MARK: - 내가 만든 방 불러오는 함수
  Stream<QuerySnapshot<Object?>> getMyRoomModel({required String myUid}) {
    return _userRepository.readMyRoomCollectionStream(uid: myUid);
  }

  // MARK: - 다른 사람들 방 불러오는 함수
  Stream<QuerySnapshot<Object?>> getOthersRoomModel({required String myUid}) {
    return _roomRepository.readRoomCollectionStream(myUid: myUid);
  }
}
