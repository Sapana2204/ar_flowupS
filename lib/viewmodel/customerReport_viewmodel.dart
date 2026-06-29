import 'package:flutter/cupertino.dart';

import '../model/customerTicketReport_model.dart';
import '../repository/customerReport_repository.dart';

class CustomerReportViewModel extends ChangeNotifier {
  final CustomerRepository _repository = CustomerRepository();

  bool isLoading = false;

  CustomerTicketReportModel? reportModel;

  Future<void> getCustomerReport({
    required int customerId,
    required String fromDate,
    required String toDate,
  }) async {

    reportModel = await _repository.getCustomerTicketReport(
      customerId: customerId,
      fromDate: fromDate,
      toDate: toDate,
    );

    notifyListeners();
  }
}