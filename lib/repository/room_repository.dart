import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

class RoomRepository {
  final FirebaseCRUD _firebaseService = FirebaseCRUD();
  final FirebaseRefs _firebaseRefs = FirebaseRefs();

  // < ---------- RoomModel CRUD ---------- >
  Future<List<RoomModel>> readRoomCollection() async {
    return await _firebaseService.readCollection(
        colRef: _firebaseRefs.colRefRoom);
  }

  Stream<QuerySnapshot<Object?>> readRoomCollectionStream() {
    return _firebaseService.readCollectionStream(
        colRef: _firebaseRefs.colRefRoom);
  }

  Future<bool> createRoomDocument(
      {required RoomModel data}) async {
    return await _firebaseService.createDocument(
      docRef: _firebaseRefs.colRefRoom.doc(),
      data: data,
    );
  }

  Future<RoomModel> readRoomDocument({required String roomId}) async {
    return await _firebaseService.readDocument<RoomModel>(
        docRef: _firebaseRefs.colRefRoom.doc(roomId));
  }

  Future<bool> updateRoomDocument({
    required String roomId,
    required Map<String, dynamic> data,
  }) async {
    return await _firebaseService.updateDocument(
      docRef: _firebaseRefs.colRefRoom.doc(roomId),
      data: data,
    );
  }

  Future<bool> deleteRoomData({required String roomId}) async {
    return _firebaseService.deleteDocument(
        docRef: _firebaseRefs.colRefRoom.doc(roomId));
  }

  // < ---------- EnterRequestModel CRUD ---------- >
}
