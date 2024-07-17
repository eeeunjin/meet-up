import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/repository/user_repository.dart';

class ChatViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // myRoom 정보 불러오기 테스트
  Stream<QuerySnapshot<Object?>> readMyRoomCollectionStream({
    required String uid,
  }) {
    return _userRepository.readMyRoomCollectionStream(
      uid: uid,
      findAll: true,
    );
  }
}
