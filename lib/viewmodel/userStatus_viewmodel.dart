import 'package:flutter/material.dart';

import '../repository/userStatus_repository.dart';


class UserStatusViewModel extends ChangeNotifier {
  final UserStatusRepository _repo = UserStatusRepository();

  bool isLoading = false;

  Future<bool> updateStatus(String status) async {
    try {
      isLoading = true;
      notifyListeners();

      await _repo.updateUserStatus(status);

      return true;
    } catch (e) {
      debugPrint("Status Update Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}