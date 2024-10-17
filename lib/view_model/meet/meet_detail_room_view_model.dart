import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

class MeetDetailRoomViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final RoomRepository _roomRepository = RoomRepository();
  RoomModel? currentRoomModel; // 현재 방 모델
  List<UserModel>? currentRoomModelUserModels; // 현재 방 모델의 유저들
  bool? isMyRoom;
  bool? isChatRoom;

  void setCurrentRoomModel({required RoomModel roomModel}) {
    currentRoomModel = roomModel.clone();
  }

  void setIsMyRoom({required bool isMyRoom}) {
    this.isMyRoom = isMyRoom;
    notifyListeners();
  }

  void setIsChatRoom({required bool isChatRoom}) {
    this.isChatRoom = isChatRoom;
    notifyListeners();
  }

  void clearCurrentRoomModel() {
    currentRoomModel = null;
    notifyListeners();
  }

  List<bool> get roomRules => currentRoomModel?.room_rules.cast<bool>() ?? [];

  // MARK: - 상세정보 불러오면서 참여자 정보 가져오는 함수
  Future<List<UserModel>> getParticipantInfo() async {
    List<DocumentReference> docRefs = List.empty(growable: true);

    if (!currentRoomModel!.isRoomDeleted) {
      // 방장 추가
      docRefs.add(currentRoomModel!.room_owner_reference);
    }

    // 입장한 사람 추가
    for (DocumentReference docRef
        in currentRoomModel!.room_participant_reference) {
      docRefs.add(docRef);
    }

    // 유저 정보 불러오기
    List<UserModel> userModels = List.empty(growable: true);
    for (DocumentReference docRef in docRefs) {
      userModels
          .add(await _userRepository.readUserDocumentByDocRef(docRef: docRef));
    }

    for (UserModel userModel in userModels) {
      logger.d(
          "userModel.nickname: ${userModel.nickname} / userModel.gender: ${userModel.gender}");
    }

    currentRoomModelUserModels = userModels;

    return userModels;
  }

  String calRestParticipantNum({required List<UserModel> userModels}) {
    int manCount = 0;
    int womanCount = 0;

    for (UserModel userModel in userModels) {
      if (userModel.gender == 'male') {
        manCount += 1;
      } else {
        womanCount += 1;
      }
    }

    logger.d("성비: ${currentRoomModel!.room_gender_ratio}");

    switch (currentRoomModel!.room_gender_ratio) {
      case "남성 4명":
        return "(남성 ${4 - manCount}자리 남음)";
      case "여성 4명":
        return "(여성 ${4 - womanCount}자리 남음)";
      default:
        return "(여성 ${2 - womanCount}자리, 남성 ${2 - manCount}자리 남음)";
    }
  }

  Future<void> updateRoomInfo(
      {required String myUid,
      required List<dynamic> participants,
      required roomId}) async {
    try {
      final participantList = participants;
      participantList
          .add(FirebaseFirestore.instance.collection('users').doc(myUid));

      final data = {
        'room_participant_reference': participantList,
      };

      await _roomRepository.updateRoomDocument(
        roomId: roomId,
        data: data,
      );
    } catch (e) {
      logger.e("방 정보 추가 중 에러가 발생하였습니다. $e");
    }
  }

  Future<void> addMyRoomInfo(
      {required String myUid, required String roomId}) async {
    try {
      // 유저의 방 정보 생성
      MyRoomModel myRoomModel = MyRoomModel(
        isMyRoom: false,
        isNew: true,
        room_reference:
            FirebaseFirestore.instance.collection('rooms').doc(roomId),
      );
      // 유저의 방 정보 저장
      await _userRepository.createMyRoomDocument(
        data: myRoomModel,
        uid: myUid,
        roomId: roomId,
      );
    } catch (e) {
      logger.e("방 정보 추가 중 에러가 발생하였습니다. $e");
    }
  }
}
