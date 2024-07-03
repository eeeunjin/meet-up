import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/good_history_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/service/remote/firebase_service.dart';

class GoodHistoryRepository {
  final FirebaseCRUD _firebaseCRUD = FirebaseCRUD();
  final FirebaseRefs _firebaseRefs = FirebaseRefs();

  // MARK: - CRUD
  // MARK: Create

  Future<void> createGoodHistory(GoodHistoryModel goodHistoryModel) async {
    await _firebaseCRUD.createDocument<GoodHistoryModel>(
      docRef: _firebaseRefs.colRefGoodHistory.doc(),
      data: goodHistoryModel,
    );
  }

  Future<List<GoodHistoryModel>> readAllGoodHistories(
      String uid, String type) async {
    CollectionReference colRef = _firebaseRefs.colRefGoodHistory;

    FilterInfo filterInfo = FilterInfo(uid: uid);

    return await _firebaseCRUD.readCollection<GoodHistoryModel>(
      colRef: colRef,
      filterInfo: filterInfo,
    );
  }
}
