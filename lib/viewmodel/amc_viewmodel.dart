import 'package:flutter/material.dart';

import '../model/amc_model.dart';
import '../repository/amc_repository.dart';

class AMCViewModel extends ChangeNotifier {
  final AMCRepository _repository = AMCRepository();

  bool isLoading = false;
  String errorMessage = "";

  AMCModel? amcModel;

  List<Data> amcList = [];

  Future<void> loadAMCReminders() async {
    try {
      isLoading = true;
      errorMessage = "";
      notifyListeners();

      final response = await _repository.getAMCReminders();

      amcModel = response;
      amcList = response.data ?? [];
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAMC() async {
    await loadAMCReminders();
  }
}