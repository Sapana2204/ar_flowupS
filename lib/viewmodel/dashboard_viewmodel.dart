import 'package:flutter/material.dart';

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

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> getDashboardData() async {
    setLoading(true);

    try {
      final response = await _repository.getDashboardData();

      _dashboardModel = DashboardModel.fromJson(response);

      print(
          "✅ Dashboard Loaded : ${_dashboardModel?.data?.summary?.length}");

      _error = null;
    } catch (e) {
      _error = e.toString();

      print("❌ Dashboard Error : $e");
    }

    setLoading(false);
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