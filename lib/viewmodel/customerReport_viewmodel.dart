import 'package:flutter/material.dart';

import '../model/customerTicketReport_model.dart';
import '../repository/customerReport_repository.dart';

class CustomerReportViewModel extends ChangeNotifier {
  final CustomerRepository _repository =
  CustomerRepository();

  bool isLoading = false;

  CustomerTicketReportModel? reportModel;

  Future<void> getCustomerReport({
    required int customerId,
    required String fromDate,
  }) async {
    print("📤 Calling Report API");
    print("Customer ID: $customerId");
    print("From Date: $fromDate");

    reportModel = await _repository.getCustomerTicketReport(
      customerId: customerId,
      fromDate: fromDate,
    );

    print("📥 Report API Success");
    notifyListeners();
  }
}