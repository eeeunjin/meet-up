import 'package:flutter/material.dart';
import 'package:meet_up/loginFunc.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/room_repository.dart';
import 'package:meet_up/repository/user_repository.dart';

class UserViewModel with ChangeNotifier {
  // 유저 데이터 관리 레포지토리
  final UserRepository _userRepository = UserRepository();
  final RoomRepository _roomRepository = RoomRepository();

  // 유저 정보 (사용자)
  UserModel? userModel;
  String? uid;
  bool rebuild = false;

  void setUserModel({required UserModel userModel}) {
    this.userModel = userModel;
    notifyListeners();
  }

  void setUserModelWithRebuild({required UserModel? userModel}) {
    this.userModel = userModel;
    rebuild = !rebuild;
    notifyListeners();
  }

  // MAKR: - 유저 정보 CRUD
  // Update
  Future<void> updateUserInfo({required Map<String, dynamic> data}) async {
    await _userRepository.updateUserDocument(uid: uid!, data: data);

    data.forEach((key, value) {
      if (key == "coin") {
        userModel!.coin = value;
      } else if (key == "ticket") {
        userModel!.ticket = value;
      }
    });

    logger.d("[updateUserInfo] 유저 정보 업데이트 완료");

    notifyListeners();
  }

  // MARK: - 로그인 & 회원가입 & 로그아웃 & 탈퇴

  // MARK: - 내 정보
  // 로그인이 된 경우, 유저 정보를 불러오는 함수
  Future<void> loadUserModel() async {
    // 처음 한번만 불러오도록 함
    if (userModel != null) return;

    // uid가 null이 아닌 경우 사용자 정보를 저장
    if (uid != null) {
      setUserModelWithRebuild(
          userModel: await _userRepository.readUserDocument(uid: uid!));
    } else {
      debugPrint("Error: uid value is null");
    }
  }

  // 로그인 & 회원가입 시, 로그인 정보 및 uid 저장
  Future<void> login({required String? uid}) async {
    try {
      // router 시작 지점 변경
      LoginFunc.isLogined = true;
      // firebase secure storage에 uid 값 저장
      await LoginFunc.storage.write(
        key: "uid",
        value: uid,
      );
      LoginFunc.uid = uid;
      this.uid = uid;
      // login 함수 호출 후, loadUserModel 함수를 호출 하기 때문에 notify는 하지 않음
    } catch (e) {
      Exception("Error: $e");
      LoginFunc.isLogined = false;
    }
  }

  // 로그아웃 시, 로그인 정보 및 uid 정보 삭제
  Future<void> logout() async {
    try {
      // firebase secure storage에 uid 값 삭제
      await LoginFunc.storage.delete(key: "uid");
      LoginFunc.isLogined = false;
      uid = null;
      setUserModelWithRebuild(userModel: null);
    } catch (e) {
      LoginFunc.isLogined = true;
      logger.e("[logout] Error: $e");
      throw Exception("Error: $e");
    }
  }

  // 탈퇴 시, 유저 정보 삭제
  Future<void> deleteUser() async {
    try {
      // 유저 정보 삭제 (유저 기본 정보, 나의 방 정보)
      await _userRepository.deleteUser(uid: uid!);
      // 방 정보 삭제 (유저가 만든 방)
      await _roomRepository.deleteRoomDataByUserDelete(uid: uid!);
    } catch (e) {
      logger.e("[deleteUser] Error: $e");
      throw Exception("Error: $e");
    }
  }

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
}
