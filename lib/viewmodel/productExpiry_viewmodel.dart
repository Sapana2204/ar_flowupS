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

  setLoading(bool value) {
    _loading = value;
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
}