import 'package:flutter/foundation.dart';

import '../model/quotation_model.dart';
import '../repository/quotation_repository.dart';

class QuotationViewModel extends ChangeNotifier {

  final QuotationRepository _repository =
  QuotationRepository();

  List<QuotationModel> quotations = [];

  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchQuotations({
    String searchText = '',
  }) async {

    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {

      quotations =
      await _repository.getQuotations(
        status: 'active',
        page: 1,
        searchText: searchText,
        filters: [],
        order: 'DESC',
        orderBy: 'created_date',
      );

    } catch (e) {

      errorMessage = e.toString();

    }

    isLoading = false;

    notifyListeners();
  }
}