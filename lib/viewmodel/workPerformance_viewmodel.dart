import 'package:flutter/material.dart';

import '../model/dashboard_model.dart' as dashboard;
import '../model/workPerformance_model.dart' as performance;
import '../repository/workPerformance_repository.dart';

class WorkPerformanceViewModel extends ChangeNotifier {
  final WorkPerformanceRepository _repo =
  WorkPerformanceRepository();

  bool isLoading = false;
  String? error;

  performance.WorkPerformanceModel? report;

  Future<void> getPerformanceReport({
    required String userId,
    required String fromDate,
    required String toDate,
    String companyId = "",
    String ticketStatus = "",
    String searchText = "",
    int page = 1,
    int limit = 10,
  }) async {
    try {
      isLoading = true;
      error = null;

      notifyListeners();

      report = await _repo.getUserPerformanceReport(
        userId: userId,
        fromDate: fromDate,
        toDate: toDate,
        companyId: companyId,
        ticketStatus: ticketStatus,
        searchText: searchText,
        page: page,
        limit: limit,
      );
    } catch (e) {
      error = e.toString();
      debugPrint("Performance API Error => $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ---------------------------
  /// User
  /// ---------------------------

  performance.User? get user =>
      report?.data?.user;

  /// ---------------------------
  /// Summary
  /// ---------------------------

  performance.Summary? get summary =>
      report?.data?.summary;

  int get assigned =>
      summary?.assigned ?? 0;

  int get closed =>
      summary?.closed ?? 0;

  int get pending =>
      summary?.pending ?? 0;

  int get delegated =>
      summary?.delegated ?? 0;

  int get overdue =>
      summary?.overdue ?? 0;

  int get avgResolutionTime =>
      summary?.avgResolutionTime ?? 0;

  int get productivityScore =>
      summary?.productivityScore ?? 0;

  /// ---------------------------
  /// Charts
  /// ---------------------------

  performance.Charts? get charts =>
      report?.data?.charts;

  List<performance.MonthlyProductivity>
  get monthlyProductivity =>
      charts?.monthlyProductivity ?? [];

  List<performance.TicketStatusDistribution>
  get ticketStatusDistribution =>
      charts?.ticketStatusDistribution ?? [];

  List<performance.DailyClosureTrend>
  get dailyClosureTrend =>
      charts?.dailyClosureTrend ?? [];

  performance.PendingVsClosed?
  get pendingVsClosed =>
      charts?.pendingVsClosed;

  /// ---------------------------
  /// Tickets
  /// ---------------------------

  List<performance.Tickets> get tickets =>
      report?.data?.tickets ?? [];

  /// ---------------------------
  /// Activities
  /// ---------------------------

  List<performance.Activities> get activities =>
      report?.data?.activities ?? [];

  /// ---------------------------
  /// Pagination
  /// ---------------------------

  performance.Pagination? get pagination =>
      report?.data?.pagination;

  int get currentPage =>
      pagination?.page ?? 1;

  int get totalPages =>
      pagination?.totalPages ?? 1;

  int get totalRecords =>
      pagination?.total ?? 0;

  /// ---------------------------
  /// Search
  /// ---------------------------

  Future<void> searchTickets({
    required String userId,
    required String fromDate,
    required String toDate,
    required String searchText,
  }) async {
    await getPerformanceReport(
      userId: userId,
      fromDate: fromDate,
      toDate: toDate,
      searchText: searchText,
    );
  }

  /// ---------------------------
  /// Refresh
  /// ---------------------------

  Future<void> refreshData({
    required String userId,
    required String fromDate,
    required String toDate,
  }) async {
    await getPerformanceReport(
      userId: userId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  /// ---------------------------
  /// Clear
  /// ---------------------------

  void clearData() {
    report = null;
    error = null;
    notifyListeners();
  }
}