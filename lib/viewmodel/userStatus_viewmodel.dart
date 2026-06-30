import 'package:flutter/material.dart';

import '../repository/userStatus_repository.dart';

class UserStatusViewModel extends ChangeNotifier {
  final UserStatusRepository _repo = UserStatusRepository();

  bool isLoading = false;

  Future<bool> signIn() async {
    try {
      isLoading = true;
      notifyListeners();

      return await _repo.signIn();
    } catch (e) {
      debugPrint("Sign In Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signOut() async {
    try {
      isLoading = true;
      notifyListeners();

      return await _repo.signOut();
    } catch (e) {
      debugPrint("Sign Out Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}