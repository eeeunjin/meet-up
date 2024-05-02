import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

class RoomRepository {
  final FirebaseCRUD _firebaseService = FirebaseCRUD();
  final FirebaseRefs _firebaseRefs = FirebaseRefs();

  // < ---------- RoomModel CRUD ---------- >
  Future<List<RoomModel>> readRoomCollection({
    int? limit,
    FilterInfo? filterInfo,
  }) async {
    if (limit == null) {
      if (filterInfo == null) {
        return await _firebaseService.readCollection<RoomModel>(
            colRef: _firebaseRefs.colRefRoom);
      } else {
        return await _firebaseService.readCollection<RoomModel>(
          filterInfo: filterInfo,
          colRef: _firebaseRefs.colRefRoom,
        );
      }
    } else {
      if (filterInfo == null) {
        return await _firebaseService.readCollection<RoomModel>(
          limit: limit,
          colRef: _firebaseRefs.colRefRoom,
        );
      } else {
        return await _firebaseService.readCollection<RoomModel>(
          limit: limit,
          filterInfo: filterInfo,
          colRef: _firebaseRefs.colRefRoom,
        );
      }
    }
  }

  Stream<QuerySnapshot<Object?>> readRoomCollectionStream({
    int? limit,
    FilterInfo? filterInfo,
    String? myUid,
  }) {
    if (limit == null) {
      if (filterInfo == null) {
        return _firebaseService.readCollectionStream<RoomModel>(
          colRef: _firebaseRefs.colRefRoom,
          myUID: myUid,
        );
      } else {
        return _firebaseService.readCollectionStream<RoomModel>(
          colRef: _firebaseRefs.colRefRoom,
          filterInfo: filterInfo,
          myUID: myUid,
        );
      }
    } else {
      if (filterInfo == null) {
        return _firebaseService.readCollectionStream<RoomModel>(
          limit: limit,
          colRef: _firebaseRefs.colRefRoom,
          myUID: myUid,
        );
      } else {
        return _firebaseService.readCollectionStream<RoomModel>(
          limit: limit,
          filterInfo: filterInfo,
          colRef: _firebaseRefs.colRefRoom,
          myUID: myUid,
        );
      }
    }
  }

  Future<DocumentReference> createRoomDocument(
      {required RoomModel data}) async {
    DocumentReference docRef = _firebaseRefs.colRefRoom.doc();
    await _firebaseService.createDocument<RoomModel>(
      docRef: docRef,
      data: data,
    );
    return docRef;
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
  Future<List<EnterRequestModel>> readEnterRequestCollection(
      {required String roomId}) async {
    CollectionReference enterRequestCollectionReference =
        _firebaseRefs.colRefUser.doc(roomId).collection("enterRequests");

    return await _firebaseService.readCollection<EnterRequestModel>(
        colRef: enterRequestCollectionReference);
  }

  Stream<QuerySnapshot<Object?>> readEnterRequestCollectionStream(
      {required String roomId}) {
    CollectionReference enterRequestCollectionReference =
        _firebaseRefs.colRefUser.doc(roomId).collection("enterRequests");
    return _firebaseService.readCollectionStream<EnterRequestModel>(
        colRef: enterRequestCollectionReference);
  }

  Future<bool> createEnterRequestDocument({
    required String roomId,
    required EnterRequestModel data,
  }) async {
    DocumentReference enterRequestDocumentReference =
        _firebaseRefs.colRefUser.doc(roomId).collection("enterRequests").doc();
    return await _firebaseService.createDocument<EnterRequestModel>(
      docRef: enterRequestDocumentReference,
      data: data,
    );
  }

  Future<EnterRequestModel> readEnterRequestDocument({
    required String roomId,
    required String enterRequestId,
  }) async {
    DocumentReference enterRequestDocumentReference = _firebaseRefs.colRefUser
        .doc(roomId)
        .collection("enterRequests")
        .doc(enterRequestId);
    return await _firebaseService.readDocument<EnterRequestModel>(
      docRef: enterRequestDocumentReference,
    );
  }

  Future<bool> updateEnterRequestDocument({
    required String roomId,
    required String enterRequestId,
    required Map<String, dynamic> data,
  }) async {
    DocumentReference enterRequestDocumentReference = _firebaseRefs.colRefUser
        .doc(roomId)
        .collection("enterRequests")
        .doc(enterRequestId);
    return await _firebaseService.updateDocument(
      docRef: enterRequestDocumentReference,
      data: data,
    );
  }

  Future<bool> deleteEnterRequestData({
    required String roomId,
    required String enterRequestId,
  }) async {
    DocumentReference enterRequestDocumentReference = _firebaseRefs.colRefUser
        .doc(roomId)
        .collection("enterRequests")
        .doc(enterRequestId);
    return _firebaseService.deleteDocument(
      docRef: enterRequestDocumentReference,
    );
  }
}

// 카테고리
enum RoomCategory {
  hobby,
  exercise,
  study,
  socializing,
  etc,
}

enum Hobby {
  travel,
  foodie,
  celebrity,
  photography,
  movies,
  gaming,
}

enum Exercise {
  soccer,
  baseball,
  basketball,
  tennis,
  yoga,
  fitness,
  pingpong,
  jogging,
  badminton
}

enum Study {
  employment,
  reading,
  university,
  miracleMorning,
  certification,
  partTimeJob,
}

enum Socializing {
  cafe,
  walking,
  dinner,
}

// 나이
enum RoomAge {
  twenties,
  thirties,
  fourties,
  fifties,
}

// 성비
enum RoomGenderRatio {
  manOnly,
  mixed,
  womanOnly,
}
