import 'package:flutter/material.dart';
import 'package:my_new_project/model/amcActivity_model.dart';

import '../model/amc_model.dart';
import '../repository/amc_repository.dart';
import '../model/scheduleAMCVisit_model.dart';

class AMCViewModel extends ChangeNotifier {
  final AMCRepository _repository = AMCRepository();

  bool isLoading = false;
  String errorMessage = "";

  AMCModel? amcModel;

  List<AMCData> amcList = [];
  List<AMCData> allAMCList = [];

  bool isSendingReminder = false;
  String reminderMessage = "";

  bool isSchedulingVisit = false;
  String visitMessage = "";

  bool isActivityLoading = false;

  String activityError = "";

  AMCActivityModel? activityModel;

  Future<void> loadAMCReminders() async {
    try {
      isLoading = true;
      errorMessage = "";
      notifyListeners();

      final response = await _repository.getAMCReminders();

      amcModel = response;
      allAMCList = response.data ?? [];
      amcList = List.from(allAMCList);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void searchAMC(String value) {
    if (value.trim().isEmpty) {
      amcList = List.from(allAMCList);
    } else {
      final query = value.toLowerCase();

      amcList = allAMCList.where((amc) {
        return (amc.name ?? "")
            .toLowerCase()
            .contains(query) ||
            (amc.companyName ?? "")
                .toLowerCase()
                .contains(query) ||
            (amc.contactPerson ?? "")
                .toLowerCase()
                .contains(query) ||
            (amc.mobileNo ?? "")
                .contains(value) ||
            (amc.email ?? "")
                .toLowerCase()
                .contains(query);
      }).toList();
    }

    notifyListeners();
  }

  Future<void> refreshAMC() async {
    await loadAMCReminders();
  }

  Future<bool> sendAMCReminder({
    required int customerId,
    required bool includeReport,
  }) async {
    try {
      isSendingReminder = true;
      notifyListeners();

      final response =
      await _repository.sendAMCReminder(
        customerId: customerId,
        includeReport: includeReport,
      );

      reminderMessage =
          response["message"] ??
              "AMC reminder sent successfully";

      return response["success"] == true;
    } catch (e) {
      reminderMessage = e
          .toString()
          .replaceAll("Exception: ", "");

      return false;
    } finally {
      isSendingReminder = false;
      notifyListeners();
    }
  }

  Future<bool> scheduleAMCVisit(
      ScheduleAMCVisitRequest request,
      ) async {
    try {
      isSchedulingVisit = true;
      notifyListeners();

      final response =
      await _repository.scheduleAMCVisit(
        request,
      );

      visitMessage =
          response["message"] ??
              "AMC visit scheduled successfully.";

      return response["success"] == true;
    } catch (e) {
      visitMessage = e
          .toString()
          .replaceAll("Exception: ", "");

      return false;
    } finally {
      isSchedulingVisit = false;
      notifyListeners();
    }
  }

  Future<void> loadAMCActivity({
    required int customerId,
  }) async {
    try {
      isActivityLoading = true;
      activityError = "";
      notifyListeners();

      activityModel = await _repository.getAMCActivity(
        customerId: customerId,
      );
    } catch (e) {
      activityError = e.toString();
    } finally {
      isActivityLoading = false;
      notifyListeners();
    }
  }
}