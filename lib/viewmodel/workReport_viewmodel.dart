import 'package:flutter/material.dart';

import '../model/assignee_model.dart';
import '../model/company_model.dart';
import '../model/workReport_model.dart';
import '../repository/WorkReport_repository.dart';

class WorkReportViewModel extends ChangeNotifier {
  final WorkReportRepository _repo = WorkReportRepository();

  bool isLoading = false;

  /// Dropdown Data
  List<AssigneeModel> assigneeList = [];
  List<CompanyModel> companyList = [];

  AssigneeModel? selectedAssignee;
  CompanyModel? selectedCompany;

  /// Work Report Data
  WorkReportModel? workReportModel;

  List<Data> workLogs = [];

  Summary? summary;

  List<CompanySummary> companySummary = [];

  int currentPage = 1;

  /// Employee + Company Dropdown APIs
  Future<void> loadWorkReportData() async {
    try {
      isLoading = true;
      notifyListeners();

      final results = await Future.wait([
        _repo.getAssignees(),
        _repo.getCompanies(),
      ]);

      assigneeList = results[0] as List<AssigneeModel>;
      companyList = results[1] as List<CompanyModel>;
    } catch (e) {
      debugPrint("Dropdown Error : $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Work Report API
  Future<void> getWorkReport({
    String userId = "",
    String companyId = "",
    String fromDate = "",
    String toDate = "",
    String searchText = "",
    int page = 1,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _repo.getWorkReport(
        userId: userId,
        companyId: companyId,
        fromDate: fromDate,
        toDate: toDate,
        page: page,
        searchText: searchText,
      );

      workReportModel = response;

      workLogs = response.data ?? [];

      summary = response.summary;

      companySummary = response.companySummary ?? [];

      currentPage = page;

      debugPrint(
        "Work Logs Loaded: ${workLogs.length}",
      );
    } catch (e) {
      debugPrint("Work Report Error : $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectAssignee(AssigneeModel? value) {
    selectedAssignee = value;
    notifyListeners();
  }

  void selectCompany(CompanyModel? value) {
    selectedCompany = value;
    notifyListeners();
  }
}