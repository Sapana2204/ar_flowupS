import 'package:flutter/material.dart';

import '../model/productExpiryReport_model.dart';
import '../repository/productExpiry_repository.dart';

class ProductExpiryViewModel extends ChangeNotifier {
  final ProductExpiryRepository _repository =
  ProductExpiryRepository();

  bool _loading = false;
  bool get loading => _loading;

  ProductExpiryReportModel? reportModel;
  List<ProductExpData> products = [];
  Summary? summary;

  final Set<String> _loadingAlerts = {};

  bool isAlertLoading(String productId) {
    return _loadingAlerts.contains(productId);
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _activityLoading = false;
  bool get activityLoading => _activityLoading;

  void setActivityLoading(bool value) {
    _activityLoading = value;
    notifyListeners();
  }

  Future<void> fetchProductExpiryReport({
    String companyId = "",
    String customerId = "",
    String productId = "",
    String expiryStatus = "all",
    String fromDate = "",
    String toDate = "",
    int expiringDays = 30,
    int page = 1,
    int limit = 20,
    String searchText = "",
  }) async {
    try {
      setLoading(true);

      final response =
      await _repository.getProductExpiryReport(
        companyId: companyId,
        customerId: customerId,
        productId: productId,
        expiryStatus: expiryStatus,
        fromDate: fromDate,
        toDate: toDate,
        expiringDays: expiringDays,
        page: page,
        limit: limit,
        searchText: searchText,
      );

      reportModel = response;
      products = response.data ?? [];
      summary = response.summary;

      notifyListeners();
    } catch (e) {
      debugPrint("Product Expiry Error : $e");
      rethrow;
    } finally {
      setLoading(false);
    }
  }


  /// SEND ALERT API
  Future<bool> sendProductExpiryAlert({
    required ProductExpData product,
    required String customerId,
  }) async {
    final id = product.productId.toString();

    try {
      _loadingAlerts.add(id);
      notifyListeners();

      final response = await _repository.sendProductExpiryAlert(
        product: product,
        customerId: customerId,
      );

      if (response["success"] == true) {
        return true;
      } else {
        throw response["message"] ?? "Failed to send alert";
      }
    } finally {
      _loadingAlerts.remove(id);
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchProductExpiryActivity({
    required ProductExpData product,
    required String customerId,
  }) async {
    try {
      setActivityLoading(true);

      final response = await _repository.getProductExpiryActivity(
        product: product,
        customerId: customerId,
      );

      return response;
    } catch (e) {
      debugPrint("Product Expiry Activity Error: $e");
      rethrow;
    } finally {
      setActivityLoading(false);
    }
  }
}