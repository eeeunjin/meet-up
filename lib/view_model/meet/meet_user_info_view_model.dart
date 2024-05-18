import 'package:flutter/material.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';

class MeetUserInfoViewModel with ChangeNotifier {
  UserModel? userModel;
  String? uid;

  // 나이대 구하는 함수
  String getAgeRange() {
    DateTime birthDate = userModel!.birthday; // 생년월일 설정
    DateTime currentDate = DateTime.now(); // 현재 날짜 가져오기

    // 생일이 지났는지 확인
    bool isBirthdayPassed = birthDate.isBefore(
      DateTime(
        birthDate.year,
        currentDate.month,
        currentDate.day,
      ),
    );

    // 만 나이 계산
    int age = currentDate.year - birthDate.year;
    if (!isBirthdayPassed) {
      age--; // 아직 생일이 지나지 않은 경우 한 살 빼기
    }

    // 나이 계산
    switch (age ~/ 10) {
      case 1:
        logger.d("만 19살(생일 안지난 20살)");
        logger.d("만 나이: $age // 생일 지났는가: $isBirthdayPassed");
        return '20대';
      case 2:
        return '20대';
      case 3:
        return '30대';
      case 4:
        return '40대';
      case 5:
        return '50대';
      default:
        logger.e("나이대 변환 실패");
        return 'Error';
    }
  }

  // 성별 변환
  String convertGenderToKor() {
    return (userModel!.gender != Gender.female.name) ? "남성" : '여성';
  }

  // 직장
  String convertAffliationToKor() {
    switch (userModel!.job) {
      case "employee":
        return "회사원";
      case "freelancer":
        return "프리랜서";
      case "student":
        return "학생";
      case "unemployed":
        return "무직";
      default:
        return "Error Job";
    }
  }
}
