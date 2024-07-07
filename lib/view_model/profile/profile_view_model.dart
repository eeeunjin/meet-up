import 'package:flutter/material.dart';
import 'package:meet_up/model/province_district_model.dart';
import 'package:meet_up/util/image.dart';

class ProfileViewModel with ChangeNotifier {
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

  // 회원 탈퇴
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

  // 프로필 수정
  String _selectedIconPath = '';

  String get selectedIconPath => _selectedIconPath;

  void setSelectedIconPath(String path) {
    _selectedIconPath = path;
    notifyListeners();
  }

  void initializeSelectedIconPath(String profileIcon) {
    final profileIconName = profileIcon.split('/').last.split('_').first;
    switch (profileIconName) {
      case "fedro":
        setSelectedIconPath(ImagePath.fedroSelect);
        break;
      case "cogy":
        setSelectedIconPath(ImagePath.cogySelect);
        break;
      case "piggy":
        setSelectedIconPath(ImagePath.piggySelect);
        break;
      case "ham":
        setSelectedIconPath(ImagePath.hamSelect);
        break;
      case "aengmu":
        setSelectedIconPath(ImagePath.aengmuSelect);
        break;
    }
  }

  // 프로필 수정 - 거주지
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

  String? get selectedAffiliation => _selectedAffiliation;

  void selectAffiliation(String affiliation) {
    _selectedAffiliation = affiliation;
    notifyListeners();
  }
}
