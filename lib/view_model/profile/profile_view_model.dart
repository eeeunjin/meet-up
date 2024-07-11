import 'package:flutter/material.dart';
import 'package:meet_up/model/province_district_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/util/image.dart';
import 'package:meet_up/view_model/sign_up/sign_up_detail_view_model.dart';

class ProfileViewModel with ChangeNotifier {
  // MARK: - 등급
  String _selectedRank = 'Novice';

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
    for (var purpose in userModel.purpose) {
      _selectedMeetingPurposes.add(purpose);
    }
  }

  // 변수 리셋 함수
  void resetProfileInfo() {
    _selectedIconPath = '';
    selectedProvince = null;
    selectedDistrict = null;
    _selectedAffiliation = null;
    _selectedInterests.clear();
    _selectedPersonalities.clear();
    _selectedMeetingPurposes.clear();
  }

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
        _selectedIconPath = ImagePath.aengmuSelect;
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

  // MARK: - 성격
  final List<String> _selectedPersonalities = [];
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
  final List<String> _selectedInterests = [];
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
  final List<String> _selectedMeetingPurposes = [];
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
}
