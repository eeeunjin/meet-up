import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/good_history_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/good_history_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

class TicketBuyViewModel with ChangeNotifier {
  final GoodHistoryRepository _goodHistoryRepository = GoodHistoryRepository();
  final UserRepository _userRepository = UserRepository();

  bool? _isFixed;
  bool? get isFixed => _isFixed;

  int _selectedNum = 1;
  int get selectedNum => _selectedNum;

  void setTicketKind(bool isFixed) {
    _isFixed = isFixed;
    logger.d('ticket kind: ${isFixed == true ? '정기권' : '단일권'}');
    notifyListeners();
  }

  void setSelectedNum(int num) {
    _selectedNum = num;
    notifyListeners();
  }

  Future<void> createGoodHistory(
      {required GoodHistoryModel goodHistoryModel}) async {
    await _goodHistoryRepository.createGoodHistory(goodHistoryModel);
    logger.d('[TicketBuyViewModel] good history created');
  }

  Future<DocumentReference> addMyTicketModel({required String uid}) async {
    final myTicketModel = MyTicketModel(
      number_of_times_available: 3,
      isUsed: false,
      roomReference: null,
    );

    return await _userRepository.createMyTicketDocument(
      data: myTicketModel,
      uid: uid,
    );
  }

  void resetState() {
    _isFixed = null;
    _selectedNum = 1;
    notifyListeners();
  }
}
