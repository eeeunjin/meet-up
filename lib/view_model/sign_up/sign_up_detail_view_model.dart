import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/main.dart';
import 'package:meet_up/model/province_district_model.dart';
import 'package:meet_up/model/room_model.dart';
import 'package:meet_up/model/user_model.dart';
import 'package:meet_up/repository/user_repository.dart';
import 'package:meet_up/util/image.dart';

class SignUpDetailViewModel with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  // MARK: - Page 1
  Gender _selectedGender = Gender.none;
  Gender get selectedGender => _selectedGender; // 선택된 성별

  DateTime _selectedDate;
  DateTime get selectedDate => _selectedDate; // 선택된 생일 날짜

  Affiliation _selectedAffiliation = Affiliation.none;
  Affiliation get selectedAffiliation => _selectedAffiliation; // 선택된 소속

  bool get selectedAllComponents =>
      (selectedGender != Gender.none) &&
      (selectedAffiliation != Affiliation.none);

  void selectGender(Gender gender) {
    if (_selectedGender != gender) {
      _selectedGender = gender;
      notifyListeners();
    }
  }

  String _selectedProvince = '서울';
  String get selectedProvince => _selectedProvince; // 선택된 도/시
  int get selectedProvinceIndex => ProvinceDistrict.districts.keys
      .toList()
      .indexOf(_selectedProvince); // 선택된 도/시의 인덱스
  FixedExtentScrollController provinceScrollController =
      FixedExtentScrollController(initialItem: 0);

  String _selectedDistrict = '강남구';
  String get selectedDistrict => _selectedDistrict; // 선택된 구/군
  int get selectedDistrictIndex => ProvinceDistrict.districts[selectedProvince]!
      .indexOf(_selectedDistrict); // 선택된 구/군의 인덱스
  FixedExtentScrollController districtScrollController =
      FixedExtentScrollController(initialItem: 0);

  void selectProvince(String province) {
    if (_selectedProvince != province) {
      _selectedProvince = province;
      notifyListeners();
    }
  }

  void selectDistrict(String district) {
    if (_selectedDistrict != district) {
      _selectedDistrict = district;
      notifyListeners();
    }
  }

  void selectAffiliation(Affiliation affiliation) {
    if (_selectedAffiliation != affiliation) {
      _selectedAffiliation = affiliation;
      notifyListeners();
    }
  }

  // datepicker
  final DateTime _start;
  final DateTime _end;

  SignUpDetailViewModel({
    required DateTime init,
    required DateTime start,
    required DateTime end,
  })  : _selectedDate = init,
        _start = start,
        _end = end;

  DateTime get start => _start;
  DateTime get end => _end;

  set selectedDate(DateTime newValue) {
    if (_selectedDate != newValue) {
      _selectedDate = newValue;
      notifyListeners();
    }
  }

  void updateDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      notifyListeners();
    }
  }

  // 연도 업데이트
  void updateYear(int year) {
    if (_selectedDate.year != year) {
      _selectedDate = DateTime(year, _selectedDate.month, _selectedDate.day);
      notifyListeners();
    }
  }

  // 월 업데이트
  void updateMonth(int month) {
    if (_selectedDate.month != month) {
      _selectedDate = DateTime(_selectedDate.year, month, _selectedDate.day);
      notifyListeners();
    }
  }

  // 일 업데이트
  void updateDay(int day) {
    if (_selectedDate.day != day) {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, day);
      notifyListeners();
    }
  }

  List<int> getYearList() {
    return List<int>.generate(
        end.year - start.year + 1, (index) => start.year + index);
  }

  List<int> getMonthList() {
    return List<int>.generate(12, (index) => index + 1);
  }

  List<int> getDayList() {
    DateTime lastDateOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);
    return List<int>.generate(lastDateOfMonth.day, (index) => index + 1);
  }

  // MARK: - Page 2
  TextEditingController nicknameController = TextEditingController();
  String errorMessage = '';
  String? _selectedImagePath;
  bool _isNicknameValid = false;

  bool get isNicknameValid => _isNicknameValid;
  String? get selectedImagePath => _selectedImagePath;
  String? get selectedIcon => selectedImagePath!.split('/').last;

  void validateNickname(String value) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9가-힣]{4,12}$');
    if (value.isEmpty) {
      errorMessage = '4~12자의 한글, 영문 대소문자, 숫자만 사용 가능합니다.';
      _isNicknameValid = false;
    } else if (!regExp.hasMatch(value)) {
      errorMessage = '4~12자의 한글, 영문 대소문자, 숫자만 사용 가능합니다.';
      _isNicknameValid = false;
    } else {
      errorMessage = '사용 가능한 닉네임입니다.';
      _isNicknameValid = true;
    }
    notifyListeners();
  }

  void selectImage(String imagePath) {
    _selectedImagePath = imagePath;
    notifyListeners();
  }

  String getIconPath() {
    switch (selectedIcon) {
      case "cogy_deselect.png":
        return ImagePath.cogySelect;
      case "piggy_deselect.png":
        return ImagePath.piggySelect;
      case "aengmu_deselect.png":
        return ImagePath.aengmuSelect;
      case "ham_deselect.png":
        return ImagePath.hamSelect;
      case "fedro_deselect.png":
        return ImagePath.fedroSelect;
      default:
        {
          logger.e("해당 아이콘이 없습니다.");
          return "";
        }
    }
  }

  bool get isNextButtonEnabled {
    return isNicknameValid && selectedImagePath != null;
  }

  // MARK: - Page 3
  void _selectKeyword(String keyword, List<String> targetList) {
    if (targetList.contains(keyword)) {
      targetList.remove(keyword);
      notifyListeners();
    } else {
      if (targetList.length < 3) {
        targetList.add(keyword);
      }
      notifyListeners();
    }
  }

  bool get areBothSectionsCompleted {
    return areThreeRelationshipKeywordsSelected &&
        areThreeLifestyleKeywordsSelected;
  }

  // relationship
  List<String> selectedRelationshipKeywords = [];

  void selectRelationshipKeyword(String keyword) {
    _selectKeyword(keyword, selectedRelationshipKeywords);
  }

  // relationship_check
  bool get areThreeRelationshipKeywordsSelected {
    return selectedRelationshipKeywords.length == 3;
  }

  // lifestyle
  List<String> selectedLifestyleKeywords = [];

  void selectLifestyleKeyword(String keyword) {
    _selectKeyword(keyword, selectedLifestyleKeywords);
  }

  // lifestyle_check
  bool get areThreeLifestyleKeywordsSelected {
    return selectedLifestyleKeywords.length == 3;
  }

  // MARK: - Page 4
  bool get isSectionsCompletedPageFour {
    return areThreeInterestedKeywordsSelected;
  }

  // interested
  List<String> selectedInterestedKeywords = [];

  void selectInterestedKeyword(String keyword) {
    _selectKeyword(keyword, selectedInterestedKeywords);
  }

  // interested_check
  bool get areThreeInterestedKeywordsSelected {
    return selectedInterestedKeywords.length == 3;
  }

  // MARK: - Page 5
  bool get isSectionsCompletedPageFive {
    return areThreePurposeKeywordsSelected;
  }

  // interested
  List<String> selectedPurposeKeywords = [];

  void selectPurposeKeyword(String keyword) {
    _selectKeyword(keyword, selectedPurposeKeywords);
  }

  // interested_check
  bool get areThreePurposeKeywordsSelected {
    return selectedPurposeKeywords.length <= 3 &&
        selectedPurposeKeywords.isNotEmpty;
  }

  // MARK: - Page 6
  List<bool> acceptedPolicies = [
    false, // 필수
    false, // 필수
    false, // 필수
    false, // 필수
    false, // 필수
    false, // 선택
    false, // 선택
    false, // 전체 동의
  ];

  bool isAcceptionValid = false;

  void toggleAcceptPolicies({required int index}) {
    acceptedPolicies[index] = !acceptedPolicies[index];
    bool allAcceptionCheck = true;
    bool acceptionValidCheck = true;
    for (int i = 0; i < 7; i++) {
      if (acceptedPolicies[i] == false) {
        allAcceptionCheck = false;
        if (i < 5) acceptionValidCheck = false;
      }
    }
    if (allAcceptionCheck == true) {
      acceptedPolicies[7] = true;
    } else {
      acceptedPolicies[7] = false;
    }
    isAcceptionValid = acceptionValidCheck;

    notifyListeners();
  }

  void toggleAllAccpetPlicies() {
    if (acceptedPolicies[7] == false) {
      for (int i = 0; i < 8; i++) {
        acceptedPolicies[i] = true;
      }
      isAcceptionValid = true;
    } else {
      for (int i = 0; i < 8; i++) {
        acceptedPolicies[i] = false;
      }
      isAcceptionValid = false;
    }
    notifyListeners();
  }

  Future<bool> updateNewUser({required String uid}) async {
    Map<String, dynamic> newUserData = {
      "nickname": nicknameController.text,
      "profile_icon": selectedImagePath!,
      "birthday": selectedDate,
      "gender": selectedGender.name,
      "region": {
        "province": selectedProvince,
        "district": selectedDistrict,
      },
      "job": selectedAffiliation.name,
      "personality_relationship": selectedRelationshipKeywords,
      "personality_self": selectedLifestyleKeywords,
      "interest": selectedInterestedKeywords,
      "purpose": selectedPurposeKeywords,
      "accepted_policies": [
        acceptedPolicies[5],
        acceptedPolicies[6],
      ],
    };

    return await _userRepository.updateUserDocument(
      uid: uid,
      data: newUserData,
    );
  }
}

enum Gender { none, female, male }

enum Affiliation { none, student, employee, freelancer, unemployed }
