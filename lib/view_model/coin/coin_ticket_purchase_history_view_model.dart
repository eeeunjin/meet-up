import 'package:flutter/material.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/good_history_model.dart';
import 'package:meet_up/repository/good_history_repository.dart';

class CoinTicketPurchaseHistoryViewModel with ChangeNotifier {
  final GoodHistoryRepository _goodHistoryRepository = GoodHistoryRepository();

  Future<List<GoodHistoryModel>> getAllGoodHistory(
      {required String uid, required String type}) async {
    logger.d("uid: $uid, type: $type");

    // type을 넣었지만 내부 함수에서 type 제한을 풀어둠 (readAllGoodHistories)
    final ghList = await _goodHistoryRepository.readAllGoodHistories(uid, type);

    return ghList;
  }
}
