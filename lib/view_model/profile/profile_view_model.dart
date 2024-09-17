import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/province_district_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/user_repository.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';

class ProfileViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // MARK: - 등급
  String _selectedRank = '용감한 햄스터';

  String get selectedRank => _selectedRank;

  void selectRank(String rank) {
    _selectedRank = rank;
    notifyListeners();
  }

  Map<String, List<String>> get rankBenefits {
    return {
      'Beginner': ['추가 할인 0%'],
      'Novice': ['추가 할인 2%', '최초 달성 시, 만남권 1개 지급'],
      'Intermediate': ['추가 할인 4%', '최초 달성 시, 만남권 1개 지급'],
      'Advanced': ['추가 할인 6%', '최초 달성 시, 만남권 1개 지급'],
      'Master': ['추가 할인 8%', '최초 달성 시, 만남권 2개 지급'],
    };
  }

  // MARK: - 회원 탈퇴
  final List<String> _selectedReasons = [];
  List<String> get selectedReasons => _selectedReasons;

  // 한 개 이상 체크 되었는지 확인
  bool get hasSelectedReasons => _selectedReasons.isNotEmpty;

  void toggleReason(String reason) {
    if (_selectedReasons.contains(reason)) {
      _selectedReasons.remove(reason);
    } else {
      _selectedReasons.add(reason);
    }
    notifyListeners();
  }

  // 탈퇴 확인 버튼
  bool _isConfirmButtonPressed = false;
  bool get isConfirmButtonPressed => _isConfirmButtonPressed;

  void pressConfirmButton() {
    _isConfirmButtonPressed = !_isConfirmButtonPressed;
    notifyListeners();
  }

  // MARK: - 프로필 수정
  // 변수 초기화 함수
  void initializeProfileInfo(UserModel userModel) {
    logger.d('userModel: ${userModel.toJson()}');

    nickNameController.text = userModel.nickname;
    initializeSelectedIconPath(userModel.profile_icon);
    selectedProvince = userModel.region['province'];
    selectedDistrict = userModel.region['district'];
    _selectedAffiliation = userModel.job;
    for (var interest in userModel.interest) {
      _selectedInterests.add(interest);
    }
    for (var personality in userModel.personality_self) {
      _selectedPersonalities.add(personality);
    }
    for (var relationship in userModel.personality_relationship) {
      _selectedRelationship.add(relationship);
    }
    for (var purpose in userModel.purpose) {
      _selectedMeetingPurposes.add(purpose);
    }
  }

  // 변수 리셋 함수
  void resetProfileInfo() {
    nickNameController.clear();
    _selectedIconPath = '';
    selectedProvince = null;
    selectedDistrict = null;
    _selectedAffiliation = null;
    _selectedInterests = [];
    _selectedPersonalities = [];
    _selectedRelationship = [];
    _selectedMeetingPurposes = [];
  }

  // MARK: - 닉네임
  TextEditingController nickNameController = TextEditingController();

  // MARK: - 아이콘
  String _selectedIconPath = '';
  String _changedIconPath = '';

  String get selectedIconPath => _selectedIconPath;
  String get changedIconPath => _changedIconPath;

  void setSelectedIconPath(String path) {
    _selectedIconPath = path;
    notifyListeners();
  }

  void setChangedIconPath(String path) {
    _changedIconPath = path;
    notifyListeners();
  }

  void initializeSelectedIconPath(String profileIcon) {
    final profileIconName = profileIcon.split('/').last.split('_').first;
    switch (profileIconName) {
      case "fedro":
        _selectedIconPath = ImagePath.fedroSelect;
        break;
      case "cogy":
        _selectedIconPath = ImagePath.cogySelect;
        break;
      case "piggy":
        _selectedIconPath = ImagePath.piggySelect;
        break;
      case "ham":
        _selectedIconPath = ImagePath.hamSelect;
        break;
      case "aengmu":
        _selectedIconPath = ImagePath.annumSelect;
        break;
    }
  }

  // MARK: - 거주지
  String? selectedProvince;
  String? selectedDistrict;
  int selectedProvinceIndex = 0;
  int selectedDistrictIndex = 0;

  final FixedExtentScrollController provinceScrollController =
      FixedExtentScrollController();
  final FixedExtentScrollController districtScrollController =
      FixedExtentScrollController();

  void selectProvince(String province) {
    selectedProvince = province;
    selectedProvinceIndex =
        ProvinceDistrict.districts.keys.toList().indexOf(province);
    notifyListeners();
  }

  void selectDistrict(String district) {
    selectedDistrict = district;
    selectedDistrictIndex =
        ProvinceDistrict.districts[selectedProvince]!.indexOf(district);
    notifyListeners();
  }

  // MARK: - 소속 수정
  String? _selectedAffiliation;
  String? _changedAffiliation;

  String? get selectedAffiliation => _selectedAffiliation;
  String? get changedAffiliation => _changedAffiliation;

  void setChangedAffiliation(String affiliation) {
    switch (affiliation) {
      case '대학생':
        _changedAffiliation = Affiliation.student.name;
        break;
      case '직장인':
        _changedAffiliation = Affiliation.employee.name;
        break;
      case '프리랜서':
        _changedAffiliation = Affiliation.freelancer.name;
        break;
      case '무직':
        _changedAffiliation = Affiliation.unemployed.name;
        break;
      default:
        _changedAffiliation = null;
    }
    notifyListeners();
  }

  void selectAffiliation(String affiliation) {
    _selectedAffiliation = affiliation;
    notifyListeners();
  }

  // MARK: - 대인관계
  List<String> _selectedRelationship = [];
  final List<String> _changedRelationship = [];

  List<String> get selectedRelationship => _selectedRelationship;
  List<String> get changedRelationship => _changedRelationship;

  void toggleChangedRelationship(String relationship) {
    if (_changedRelationship.contains(relationship)) {
      _changedRelationship.remove(relationship);
    } else {
      if (_changedRelationship.length < 3) {
        _changedRelationship.add(relationship);
      }
    }
    notifyListeners();
  }

  void setRelationship(List<String> relationships) {
    _selectedRelationship.clear();
    _selectedRelationship.addAll(relationships);
    notifyListeners();
  }

  void clearChangedRelationships() {
    _changedRelationship.clear();
    notifyListeners();
  }

  // MARK: - 성격
  List<String> _selectedPersonalities = [];
  final List<String> _changedPersonalites = [];

  List<String> get selectedPersonalities => _selectedPersonalities;
  List<String> get changedPersonalites => _changedPersonalites;

  void toggleChangedPersonality(String personality) {
    if (_changedPersonalites.contains(personality)) {
      _changedPersonalites.remove(personality);
    } else {
      if (_changedPersonalites.length < 3) {
        _changedPersonalites.add(personality);
      }
    }
    notifyListeners();
  }

  void setPersonality(List<String> personalities) {
    _selectedPersonalities.clear();
    _selectedPersonalities.addAll(personalities);
    notifyListeners();
  }

  void clearChangedPersonalities() {
    _changedPersonalites.clear();
    notifyListeners();
  }

  // MARK: - 관심사
  List<String> _selectedInterests = [];
  final List<String> _changedInterests = [];

  List<String> get selectedInterests => _selectedInterests;
  List<String> get changedInterests => _changedInterests;

  void toggleChangedInterest(String interest) {
    if (_changedInterests.contains(interest)) {
      _changedInterests.remove(interest);
    } else {
      if (_changedInterests.length < 3) {
        _changedInterests.add(interest);
      }
    }
    notifyListeners();
  }

  void setInterest(List<String> interests) {
    _selectedInterests.clear();
    _selectedInterests.addAll(interests);
    notifyListeners();
  }

  void clearChangedInterests() {
    _changedInterests.clear();
    notifyListeners();
  }

  // MARK: - 만남 목적
  List<String> _selectedMeetingPurposes = [];
  final List<String> _changedMeetingPurposes = [];

  List<String> get selectedMeetingPurposes => _selectedMeetingPurposes;
  List<String> get changedMeetingPurposes => _changedMeetingPurposes;

  void toggleChangedMeetingPurposes(String meetingPurposes) {
    if (_changedMeetingPurposes.contains(meetingPurposes)) {
      _changedMeetingPurposes.remove(meetingPurposes);
    } else {
      if (_changedMeetingPurposes.length < 3) {
        _changedMeetingPurposes.add(meetingPurposes);
      }
    }
    notifyListeners();
  }

  void setMeetingPurpose(List<String> meetingPurposes) {
    _selectedMeetingPurposes.clear();
    _selectedMeetingPurposes.addAll(meetingPurposes);
    notifyListeners();
  }

  void clearChangedMeetingPurposes() {
    _changedMeetingPurposes.clear();
    notifyListeners();
  }

  // MARK: - 수정된 프로필 정보를 저장하는 함수
  Future<UserModel?> updateProfileInfo(String uid, UserModel userModel) async {
    if (uid != '') {
      logger.d('uid is $uid');
    } else {
      logger.e('uid를 확인해주세요');
    }

    // MARK: - Firebase DB 정보 변경
    Map<String, dynamic> updatedData = {};
    UserModel updatedUserModel = userModel;
    bool anyChanged = false;

    // MARK: - 닉네임
    if (nickNameController.text != userModel.nickname) {
      anyChanged = true;
      updatedData['nickname'] = nickNameController.text;
      updatedUserModel.nickname = nickNameController.text;
      logger.d('닉네임 변경됨');
    }

    // MARK: - 아이콘
    if (selectedIconPath != userModel.profile_icon) {
      anyChanged = true;
      updatedData['profile_icon'] = selectedIconPath;
      updatedUserModel.profile_icon = selectedIconPath;
      logger.d('아이콘이 변경됨');
    }

    // MARK: - 거주지
    if (selectedProvince != userModel.region['province']) {
      anyChanged = true;
      updatedData['region'] = {
        'province': selectedProvince,
        'district': selectedDistrict,
      };
      updatedUserModel.region = {
        'province': selectedProvince,
        'district': selectedDistrict,
      };
      logger.d('province 변경됨');
    }

    if (selectedDistrict != userModel.region['district']) {
      anyChanged = true;
      updatedData['region'] = {
        'province': selectedProvince,
        'district': selectedDistrict,
      };
      updatedUserModel.region = {
        'province': selectedProvince,
        'district': selectedDistrict,
      };
      logger.d('district 변경됨');
    }

    // MARK: - 직업
    if (selectedAffiliation != userModel.job) {
      anyChanged = true;
      updatedData['job'] = selectedAffiliation;
      updatedUserModel.job = selectedAffiliation!;
      logger.d('직업 변경 됨');
    }

    // MARK: - 관심
    final selectedInterestsSet = selectedInterests.toSet();
    final selectedInterestsSetLength = selectedInterestsSet.length;

    for (String interest in userModel.interest) {
      selectedInterestsSet.add(interest);
    }

    if (selectedInterestsSetLength != selectedInterestsSet.length) {
      anyChanged = true;
      updatedData['interest'] = selectedInterests;
      updatedUserModel.interest = selectedInterests as List<dynamic>;
      logger.d('관심사 변경 됨');
    }

    // MARK: - 대인관계
    final selectedRelationshipSet = selectedRelationship.toSet();
    final selectedRelationshipSetLength = selectedRelationshipSet.length;

    for (String relationship in userModel.personality_relationship) {
      selectedRelationshipSet.add(relationship);
    }

    if (selectedRelationshipSetLength != selectedRelationshipSet.length) {
      anyChanged = true;
      updatedData['personality_relationship'] = selectedRelationship;
      updatedUserModel.personality_relationship =
          selectedRelationship as List<dynamic>;
      logger.d('대인관계 변경 됨');
    }

    // MARK: - 성격
    final selectedPersonalitiesSet = selectedPersonalities.toSet();
    final selectedPersonalitiesSetLength = selectedPersonalitiesSet.length;

    for (String personality in userModel.personality_self) {
      selectedPersonalitiesSet.add(personality);
    }

    if (selectedPersonalitiesSetLength != selectedPersonalitiesSet.length) {
      anyChanged = true;
      updatedData['personality_self'] = selectedPersonalities;
      updatedUserModel.personality_self =
          selectedPersonalities as List<dynamic>;
      logger.d('성격 변경 됨');
    }

    // MARK: - 만남 목적
    final selectedMeetingPurposesSet = selectedMeetingPurposes.toSet();
    final selectedMeetingPurposesSetLength = selectedMeetingPurposesSet.length;

    for (String purpose in userModel.purpose) {
      selectedMeetingPurposesSet.add(purpose);
    }

    if (selectedMeetingPurposesSetLength != selectedMeetingPurposesSet.length) {
      anyChanged = true;
      updatedData['purpose'] = selectedMeetingPurposes;
      updatedUserModel.purpose = selectedMeetingPurposes as List<dynamic>;
      logger.d('만남 목적 변경 됨');
    }

    logger.d('변경된 data: $updatedData');

    if (anyChanged) {
      await _userRepository.updateUserDocument(uid: uid, data: updatedData);
      return updatedUserModel;
    } else {
      return null;
    }
  }
}
