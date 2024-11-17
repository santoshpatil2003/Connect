import 'package:flutter/material.dart';

import 'DBHelper.dart';

class ProfileProvider2 with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();

  // Profile fields
  String name = '';
  String profession = '';
  String email = '';
  String phoneNumber = '';
  String instagram = '';
  String linkedin = '';
  String twitter = '';
  int userId = -1;

  // Santosh Patil
  // Student
  // santoshpatil2003@gmail.com
  // 9845167455
  // santoshpatil2003
  // santoshpatil2003
  // santoshpatil200
  Map<String, dynamic> UserData = {};

  void setUserData(data) {
    UserData = data;
    name = data['name'];
    profession = data['profession'];
    email = data['email'];
    phoneNumber = data['phoneNumber'];
    instagram = data['instagram'];
    linkedin = data['linkedin'];
    twitter = data['twitter'];
    notifyListeners();
  }

  void setValue(field, value) {
    switch (field) {
      case 'name':
        name = value;
        break;
      case 'profession':
        profession = value;
        break;
      case 'email':
        email = value;
        break;
      case 'phoneNumber':
        phoneNumber = value;
        break;
      case 'instagram':
        instagram = value;
        break;
      case 'linkedin':
        linkedin = value;
        break;
      case 'twitter':
        twitter = value;
        break;
    }
  }

  // Tracks if the profile is created
  bool isCreated = false;

  // Tracks edit state for each field
  Map<String, bool> editMode = {
    'name': false,
    'profession': false,
    'email': false,
    'phoneNumber': false,
    'instagram': false,
    'linkedin': false,
    'twitter': false,
  };

  // Method to fetch and set userId by profile type (isMyProfile)
  Future<void> fetchAndSetUserId(bool isMyProfile) async {
    userId = await _dbHelper.getUserIdByProfileType(isMyProfile);
    print(userId);
    notifyListeners();
  }

  Future<int> fetchAndSetUserId2(bool isMyProfile) async {
    userId = await _dbHelper.getUserIdByProfileType(isMyProfile);
    return userId;
    // notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getOtherProfiles() {
    final Future<List<Map<String, dynamic>>> data =
        _dbHelper.getOtherProfiles();
    return data;
  }

  // Method to fetch and set userId by email
  Future<void> fetchAndSetUserIdEmail(String email) async {
    userId = await _dbHelper.getUserIdByEmail(email);
    notifyListeners();
  }

  // Load profile data from the database
  Future<Map<String, String>> loadProfile(int id) async {
    final profile = await _dbHelper.getProfileById(id);
    final Map<String, String> profileData = {
      "name": "",
      "profession": "",
      "email": "",
      "phoneNumber": "",
      "instagram": "",
      "linkedin": "",
      "twitter": ""
    };
    if (profile != null) {
      profileData["name"] = profile['name'];
      profileData["profession"] = profile['profession'];
      profileData["email"] = profile['email'];
      profileData["phoneNumber"] = profile['phoneNumber'];
      profileData["instagram"] = profile['instagram'];
      profileData["linkedin"] = profile['linkedin'];
      profileData["twitter"] = profile['twitter'];
      isCreated = true;
      notifyListeners();
    }
    return profileData;
  }

  // Save profile data to the database
  Future<void> saveProfileData({bool isMyProfile = true}) async {
    if (!isCreated) {
      await _dbHelper.insertProfile({
        'name': name,
        'profession': profession,
        'email': email,
        'phoneNumber': phoneNumber,
        'instagram': instagram,
        'linkedin': linkedin,
        'twitter': twitter,
        'isMyProfile': isMyProfile,
      });
      print("inserted");
      print({
        'name': name,
        'profession': profession,
        'email': email,
        'phoneNumber': phoneNumber,
        'instagram': instagram,
        'linkedin': linkedin,
        'twitter': twitter,
        'isMyProfile': isMyProfile,
      });
      isCreated = true;
      notifyListeners();
    }
  }

  Future<void> saveOtherProfileData(
      bool isMyProfile, Map<String, dynamic> ProfileData) async {
    if (isCreated) {
      await _dbHelper.insertProfile({
        'name': ProfileData['name'],
        'profession': ProfileData['profession'],
        'email': ProfileData["email"],
        'phoneNumber': ProfileData["phoneNumber"],
        'instagram': ProfileData["instagram"],
        'linkedin': ProfileData["linkedin"],
        'twitter': ProfileData["twitter"],
        'isMyProfile': isMyProfile,
      });
      print("inserted");
      print({
        'name': ProfileData['name'],
        'profession': ProfileData['profession'],
        'email': ProfileData["email"],
        'phoneNumber': ProfileData["phoneNumber"],
        'instagram': ProfileData["instagram"],
        'linkedin': ProfileData["linkedin"],
        'twitter': ProfileData["twitter"],
        'isMyProfile': isMyProfile,
      });
      // isCreated = true;
      notifyListeners();
    }
  }

  // Update a specific field in the profile
  Future<void> updateProfileField(String field, String value, int id) async {
    // Update locally
    switch (field) {
      case 'name':
        name = value;
        break;
      case 'profession':
        profession = value;
        break;
      case 'email':
        email = value;
        break;
      case 'phoneNumber':
        phoneNumber = value;
        break;
      case 'instagram':
        instagram = value;
        break;
      case 'linkedin':
        linkedin = value;
        break;
      case 'twitter':
        twitter = value;
        break;
    }

    // Update in the database
    await _dbHelper.updateProfile(id, {
      'name': name,
      'profession': profession,
      'email': email,
      'phoneNumber': phoneNumber,
      'instagram': instagram,
      'linkedin': linkedin,
      'twitter': twitter,
      'isMyProfile': true,
    });

    // Exit edit mode for the field
    editMode[field] = false;
    notifyListeners();
  }

  // Delete a specific profile by id
  Future<void> deleteProfile(int id) async {
    await _dbHelper.deleteProfile(id);
    clearFields();
    notifyListeners();
  }

  // Toggle edit mode for a specific field
  void toggleEditMode(String field) {
    editMode[field] = !editMode[field]!;
    notifyListeners();
  }

  // Clear profile fields after deletion
  void clearFields() {
    name = '';
    profession = '';
    email = '';
    phoneNumber = '';
    instagram = '';
    linkedin = '';
    twitter = '';
    isCreated = false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
