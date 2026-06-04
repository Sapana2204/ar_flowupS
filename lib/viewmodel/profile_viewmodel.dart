import 'package:flutter/material.dart';

import '../model/profile_model.dart';
import '../repository/profile_repository.dart';

class ProfileViewModel with ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();

  bool _loading = false;
  bool get loading => _loading;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> getProfile() async {
    setLoading(true);

    try {
      final response = await _profileRepository.getProfileApi();

      _profileModel = ProfileModel.fromJson(response);

      debugPrint("✅ Profile Loaded");
      debugPrint("Name: ${_profileModel?.data?.name}");

    } catch (e) {
      debugPrint("❌ Profile Error: $e");
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}