// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class GoodHistoryModel {
  String gh_type;
  String gh_uid;
  int gh_result_coin;
  int gh_result_ticket;
  int gh_change_coin_amount;
  int gh_change_ticket_amount;
  Timestamp gh_change_date;

  GoodHistoryModel({
    required this.gh_type,
    required this.gh_uid,
    required this.gh_result_coin,
    required this.gh_result_ticket,
    required this.gh_change_coin_amount,
    required this.gh_change_ticket_amount,
    required this.gh_change_date,
  });

  GoodHistoryModel.fromJson(Map<String, Object?> json)
      : this(
          gh_type: json['gh_type']! as String,
          gh_uid: json['gh_uid']! as String,
          gh_result_coin: json['gh_result_coin']! as int,
          gh_result_ticket: json['gh_result_ticket']! as int,
          gh_change_coin_amount: json['gh_change_coin_amount']! as int,
          gh_change_ticket_amount: json['gh_change_ticket_amount']! as int,
          gh_change_date: json["gh_change_date"]! as Timestamp,
        );

  Map<String, Object?> toJson() {
    return {
      'gh_type': gh_type,
      'gh_uid': gh_uid,
      'gh_result_coin': gh_result_coin,
      'gh_result_ticket': gh_result_ticket,
      'gh_change_coin_amount': gh_change_coin_amount,
      'gh_change_ticket_amount': gh_change_ticket_amount,
      'gh_change_date': gh_change_date,
    };
  }
}
