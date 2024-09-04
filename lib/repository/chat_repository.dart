import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/model/chat_room_model.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

class ChatRepository {
  final firebaseCRUD = FirebaseCRUD();
  final firebaseRefs = FirebaseRefs();

  // MARK: - ChatRoomCRUD
  // Create
  Future<void> createChatRoom(
      ChatRoomModel chatRoomModel, String roomId) async {
    await firebaseCRUD.createDocument<ChatRoomModel>(
      docRef: firebaseRefs.colRefChatRoom.doc(roomId),
      data: chatRoomModel,
    );
  }

  // MARK: - ChatCRUD
  // Create
  Future<bool> createChat(
    ChatModel chatModel,
    String roomId, [
    String? docId,
  ]) async {
    if (docId == null) {
      return await firebaseCRUD.createDocument<ChatModel>(
        docRef:
            firebaseRefs.colRefChatRoom.doc(roomId).collection('chats').doc(),
        data: chatModel,
      );
    } else {
      return await firebaseCRUD.createDocument<ChatModel>(
        docRef: firebaseRefs.colRefChatRoom
            .doc(roomId)
            .collection('chats')
            .doc(docId),
        data: chatModel,
      );
    }
  }

  // delete
  Future<void> deleteChat(String roomId, String chatId) async {
    await firebaseCRUD.deleteDocument(
      docRef: firebaseRefs.colRefChatRoom
          .doc(roomId)
          .collection('chats')
          .doc(chatId),
    );
  }

  // Read
  Stream<QuerySnapshot<Object?>> getChatStream(String roomId) {
    return firebaseCRUD.readCollectionStream<ChatModel>(
      colRef: firebaseRefs.colRefChatRoom.doc(roomId).collection('chats'),
    );
  }
}
