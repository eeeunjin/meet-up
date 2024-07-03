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

    for (GoodHistoryModel gh in ghList) {
      logger.d(
          "[${gh.gh_change_date.toDate().month}월 ${gh.gh_change_date.toDate().day}일, ${gh.gh_change_date.toDate().hour}:${gh.gh_change_date.toDate().minute}] ${gh.gh_uid} 님이 ${gh.gh_change_coin_amount} 코인을 구매하여 ${gh.gh_result_coin} 코인이 되었습니다.");
    }

    return ghList;
  }
}
