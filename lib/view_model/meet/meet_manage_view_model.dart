import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/repository/user_repository.dart';

class MeetManageViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // MARK - 내가 만든 방 불러오는 함수
  Stream<QuerySnapshot<Object?>> getMyRoomModel({required String myUid}) {
    return _userRepository.readMyRoomCollectionStream(uid: myUid);
  }
}
