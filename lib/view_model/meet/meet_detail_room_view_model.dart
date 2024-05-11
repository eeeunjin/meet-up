import 'package:flutter/widgets.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

class MeetDetailRoomViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final RoomRepository _roomRepository = RoomRepository();
  RoomModel? currentRoomModel; // 현재 방 모델
  bool? isMyRoom;

  void setCurrentRoomModel({required RoomModel roomModel}) {
    currentRoomModel = roomModel;
    notifyListeners();
  }

  void setIsMyRoom({required bool isMyRoom}) {
    this.isMyRoom = isMyRoom;
    notifyListeners();
  }

  void clearCurrentRoomModel() {
    currentRoomModel = null;
    notifyListeners();
  }

  Future<void> deleteRoom({required String myUid}) async {
    logger.d("채팅 방 만들어지고, 채팅 방 삭제되는 로직도 들어와야 함");

    // Room Collection 에서 해당 정보 삭제
    try {
      await _roomRepository.deleteRoomData(roomId: currentRoomModel!.roomId);

      // 해당 유저의 myRoom Collection 에서 해당 정보 삭제
      await _userRepository.deleteMyRoomData(
          uid: myUid, roomId: currentRoomModel!.roomId);

      logger.d("안전하게 방 정보가 삭제되었습니다.");
    } catch (e) {
      logger.e("방 삭제 중 에러가 발생하였습니다. $e");
    }

    return;
  }

  List<bool> get roomRules => currentRoomModel?.room_rules.cast<bool>() ?? [];
}
