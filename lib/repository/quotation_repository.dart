import '../constants/appUrls.dart';
import '../data/network/network_api_services.dart';
import '../model/quotation_model.dart';

class QuotationRepository {
  final NetworkApiServices _apiServices =
  NetworkApiServices();

  Future<List<QuotationModel>> getQuotations({
    String status = 'active',
    int page = 1,
    String searchText = '',
    List<dynamic> filters = const [],
    String order = 'DESC',
    String orderBy = 'created_date',
  }) async {

    final data = {
      "status": status,
      "page": page,
      "searchText": searchText,
      "filters": filters,
      "order": order,
      "orderBy": orderBy,
    };

    final response =
    await _apiServices.getPostApiResponse(
      AppUrls.quotations,
      data,
    );

    if (response == null) {
      throw Exception(
        "No response received from server",
      );
    }

    if (response['success'] != true) {
      throw Exception(
        response['message'] ??
            "Failed to fetch quotations",
      );
    }

    final List<dynamic> quotationData =
        response['data'] ?? [];

    return quotationData
        .map(
          (json) =>
          QuotationModel.fromJson(json),
    )
        .toList();
  }
}