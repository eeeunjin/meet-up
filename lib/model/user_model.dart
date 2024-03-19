import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase - User Document 데이터 모델
class UserModel {
  // 닉네임
  String nickname;
  // 프로필 아이콘
  int profileIcon;
  // 생년월일
  Timestamp birthday;
  // 성별
  String gender;
  // 거주지
  Map<String, dynamic> region;
  // 소속분류
  String job;
  // 성격 - 대인관계
  List<dynamic> personalityRelationship;
  // 성격 - 자신
  List<dynamic> personalitySelf;
  // 관심사
  List<dynamic> interest;
  // 만남목적
  List<dynamic> purpose;
  // 전화번호
  String phoneNumber;

  UserModel({
    required this.nickname,
    required this.profileIcon,
    required this.birthday,
    required this.gender,
    required this.region,
    required this.job,
    required this.personalityRelationship,
    required this.personalitySelf,
    required this.interest,
    required this.purpose,
    required this.phoneNumber,
  });

  /// json 형식으로 된 정보를 변수 값으로 등록할 때 쓰는 Constructor
  UserModel.fromJson(Map<String, Object?> json)
      : this(
          nickname: json['nickname']! as String,
          profileIcon: json['profileIcon']! as int,
          birthday: json['birthday']! as Timestamp,
          gender: json['gender']! as String,
          region: json['region']! as Map<String, dynamic>,
          job: json['job']! as String,
          personalityRelationship:
              json["personalityRelationship"]! as List<dynamic>,
          personalitySelf: json["personalitySelf"]! as List<dynamic>,
          interest: json["interest"]! as List<dynamic>,
          purpose: json["purpose"]! as List<dynamic>,
          phoneNumber: json["phoneNumber"]! as String,
        );

  /// 모델의 프로퍼티 값을 json 파일 형식으로 변환하여 넘겨줄 때 사용하는 함수
  Map<String, Object?> toJson() {
    return {
      'nickname': nickname,
      'profileIcon': profileIcon,
      'birthday': birthday,
      'gender': gender,
      'region': region,
      'job': job,
      'personalityRelationship': personalityRelationship,
      'personalitySelf': personalitySelf,
      'interest': interest,
      'purpose': purpose,
      'phoneNumber': phoneNumber,
    };
  }
}
