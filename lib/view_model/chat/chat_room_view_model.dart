import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meet_up/model/chat_room_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/chat_repository.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

class ChatRoomViewModel with ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();
  final UserRepository _userRepository = UserRepository();
  final RoomRepository _roomRepository = RoomRepository();

  // RoomRef 정보
  DocumentReference? _roomRef;
  DocumentReference get roomRef => _roomRef!;

  // 방, 채팅 방의 document 아이디 (둘이 동일 함)
  String _roomID = '';
  String get roomID => _roomID;

  // 채팅 방 이름
  String get roomName => roomModel.room_name;

  // 방 정보 모델
  RoomModel? _roomModel;
  RoomModel get roomModel => _roomModel!;

  // 방에 참가한 유저 정보
  final List<UserModel> _userModels = [];
  List<UserModel> get userModels => _userModels;

  // 방 owner UID
  UserModel get ownerUID => _userModels[0];

  // 채팅 메시지 입력 컨트롤러
  final TextEditingController _messageController = TextEditingController();
  TextEditingController get messageController => _messageController;

  // 채팅 메시지 입력 중인지 여부
  bool _startEdit = false;
  bool get startEdit => _startEdit;

  // 채팅 메시지 입력 중인 라인 수
  int _lineNum = 1;
  int get lineNum => _lineNum;

  // 채팅 뷰에 쓰이는 스크롤 컨트롤러
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  // 더 보기 옵션 버튼 눌렸는지 여부
  bool _moreOptionClicked = false;
  bool get moreOptionClicked => _moreOptionClicked;

  void setRoomRef(DocumentReference value) {
    _roomRef = value;
  }

  void setRoomID(String value) {
    _roomID = value;
  }

  void setRoomModel(RoomModel value) {
    _roomModel = value;
  }

  Future<void> setUserModels() async {
    final userRefs = List.from(roomModel.room_participant_reference);
    userRefs.insert(0, roomModel.room_owner_reference);

    List<UserModel> newUserModels = [];

    for (DocumentReference userRef in userRefs) {
      UserModel userModel =
          await _userRepository.readUserDocument(uid: userRef.id);
      newUserModels.add(userModel);
    }

    _userModels.clear();
    _userModels.addAll(newUserModels);
  }

  void setStartEdit(bool value) {
    _startEdit = value;
    notifyListeners();
  }

  void setMoreOptionClicked(bool value) {
    _moreOptionClicked = value;
    notifyListeners();
  }

  void setLineNum(int value) {
    _lineNum = value;
    notifyListeners();
  }

  // 최대 길이를 지정해서 텍스트와 폰트 스타일을 받아와 텍스트 줄 수를 계산하는 함수
  int calculateLineCount(String text, double maxWidth, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);

    return textPainter.computeLineMetrics().length;
  }

  // 텍스트와 폰트 스타일을 받아와 텍스트 너비를 계산하는 함수
  double calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    return (textPainter.width + 2.w).toDouble();
  }

  // 스크롤 뷰의 가장 하단으로 움직이는 함수
  void scrollToBottom() {
    // 채팅 스크롤 뷰에 쓰이기 때문에 reverse: true 옵션에 따라 position이 minScrollExtent로 지정 됨
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // 년, 월, 일, 정보를 받아서 요일을 계산 및 반환하는 함수
  String getDayOfWeek(int year, int month, int day) {
    final DateTime date = DateTime(year, month, day);
    final List<String> days = ['일', '월', '화', '수', '목', '금', '토'];

    return days[date.weekday - 1];
  }

  // 채팅 메시지 전송 함수
  Future<bool> createChatDocument(ChatModel chatModel) async {
    // 해당 room model의 recent message 업데이트
    await _roomRepository.updateRoomDocument(
      roomId: chatModel.room_reference,
      data: {
        'recentMessage': chatModel.content,
      },
    );

    // 새로운 chat model 생성
    return await _chatRepository.createChat(
      chatModel,
      _roomID,
    );
  }

  // 채팅 메시지 Type에 따라 최근 채팅 메시지를 반환하는 함수
  String getRecentMessage(ChatModel chatModel, String? nickname) {
    switch (chatModel.type) {
      case "chat":
        return chatModel.content;
      case "enter":
        return '"${nickname}" 님이 입장하셨습니다.';
      case "exit":
        return '"${nickname}" 님이 퇴장하셨습니다.';
      case "schedule_register":
        return '일정을 확인해주세요.';
      case "schedule_delete":
        return '기존 일정이 삭제되었습니다.';
      default:
        return 'Error Type Message comes';
    }
  }

  // 채팅 메시지 스트림 함수
  Stream<QuerySnapshot<Object?>> getChatStream() {
    return _chatRepository.getChatStream(_roomID);
  }

  // myRoom 정보 삭제
  Future<void> deleteMyRoom(
      {required String uid, required String roomId}) async {
    await _userRepository.deleteMyRoomData(uid: uid, roomId: roomId);
  }

  // Room 정보 업데이트
  Future<void> updateRoomData(
      {required String roomId, required Map<String, dynamic> data}) async {
    await _roomRepository.updateRoomDocument(roomId: roomId, data: data);
  }

  // 상태 초기화 함수
  void resetState() {
    _roomID = '';
    _messageController.clear();
    _startEdit = false;
    _lineNum = 1;
  }
}
