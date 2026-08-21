import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/dashboard_model.dart';
import '../repository/dashboard_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository _repository = DashboardRepository();

  bool _loading = false;
  bool get loading => _loading;

  DashboardModel? _dashboardModel;
  DashboardModel? get dashboardModel => _dashboardModel;

  String? _error;
  String? get error => _error;

  // Selected dates
  DateTime? _fromDate;
  DateTime? _toDate;

  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// Get first day of current month
  DateTime get currentMonthFirstDate {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      1,
    );
  }

  /// Format date as yyyy-MM-dd
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> getDashboardData({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    setLoading(true);

    try {
      // If no from date is selected,
      // use first date of current month.
      final selectedFromDate =
          fromDate ?? _fromDate ?? currentMonthFirstDate;

      // Store selected dates
      _fromDate = selectedFromDate;
      _toDate = toDate ?? _toDate;

      final response = await _repository.getDashboardData(
        fromDate: formatDate(selectedFromDate),
        toDate: _toDate != null ? formatDate(_toDate!) : null,
      );

      _dashboardModel = DashboardModel.fromJson(response);

      print(
        "✅ Dashboard Loaded : "
            "${_dashboardModel?.data?.summary?.length}",
      );

      print(
        "FROM DATE : ${formatDate(selectedFromDate)}",
      );

      print(
        "TO DATE : "
            "${_toDate != null ? formatDate(_toDate!) : null}",
      );

      _error = null;
    } catch (e) {
      _error = e.toString();

      print("❌ Dashboard Error : $e");
    }

    setLoading(false);
  }

  /// Set date filter and reload dashboard
  Future<void> setDateFilter({
    required DateTime fromDate,
    DateTime? toDate,
  }) async {
    _fromDate = fromDate;
    _toDate = toDate;

    notifyListeners();

    await getDashboardData(
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  /// Clear date filter.
  /// It will again use first day of current month.
  Future<void> clearDateFilter() async {
    _fromDate = currentMonthFirstDate;
    _toDate = null;

    notifyListeners();

    await getDashboardData(
      fromDate: _fromDate,
      toDate: null,
    );
  }

  /// Helper function for getting count by key
  String getSummaryValue(String key) {
    try {
      final item = _dashboardModel?.data?.summary?.firstWhere(
            (e) => e.key == key,
      );

      return item?.value ?? "0";
    } catch (e) {
      return "0";
    }
  }
}