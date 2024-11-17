import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  // Profile fields
  String name = '';
  String profession = '';
  String email = '';
  String phoneNumber = '';
  String instagram = '';
  String linkedin = '';
  String twitter = '';

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

  Future<void> saveProfileData() async {
    if (!isCreated) {
      await FirebaseFirestore.instance.collection('profiles').add({
        'name': name,
        'profession': profession,
        'email': email,
        'phoneNumber': phoneNumber,
        'instagram': instagram,
        'linkedin': linkedin,
        'twitter': twitter,
      });
      isCreated = true;
      notifyListeners();
    }
  }

  Future<void> updateProfileField(String field, String value) async {
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

    // Update Firestore
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc('profileId')
        .update({
      field: value,
    });

    // Exit edit mode for the field
    editMode[field] = false;
    notifyListeners();
  }

  void toggleEditMode(String field) {
    editMode[field] = !editMode[field]!;
    notifyListeners();
  }
}
