import 'package:meet_up/model/good_history_model.dart';
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
}
