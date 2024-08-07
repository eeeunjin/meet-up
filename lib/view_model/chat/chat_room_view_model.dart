import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/model/chat_room_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/chat_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

class ChatRoomViewModel with ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();
  final UserRepository _userRepository = UserRepository();

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

  void setRoomID(String value) {
    _roomID = value;
  }

  void setRoomModel(RoomModel value) {
    _roomModel = value;
  }

  Future<void> setUserModels() async {
    final userRefs = List.from(roomModel.room_participant_reference);

    userRefs.insert(0, roomModel.room_owner_reference);

    for (DocumentReference userRef in userRefs) {
      UserModel userModel =
          await _userRepository.readUserDocument(uid: userRef.id);
      _userModels.add(userModel);
    }
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

    return textPainter.width.toDouble();
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

  // 채팅 메시지 전송 함수
  Future<bool> createChatDocument(ChatModel chatModel) async {
    return await _chatRepository.createChat(
      chatModel,
      _roomID,
    );
  }

  // 채팅 메시지 스트림 함수
  Stream<QuerySnapshot<Object?>> getChatStream() {
    return _chatRepository.getChatStream(_roomID);
  }

  // 상태 초기화 함수
  void resetState() {
    _roomID = '';
    _messageController.clear();
    _startEdit = false;
    _lineNum = 1;
  }
}
