import '../data/network/base_api_services.dart';
import '../data/network/network_api_services.dart';
import '../model/productExpiryReport_model.dart';
import '../constants/appUrls.dart';

class ProductExpiryRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<ProductExpiryReportModel> getProductExpiryReport({
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
    String orderBy = "expiry_date",
    String order = "ASC",
  }) async {
    final response = await _apiServices.getPostApiResponse(
      AppUrls.productExpiryReport,
      {
        "company_id": companyId,
        "customer_id": customerId,
        "product_id": productId,
        "expiry_status": expiryStatus,
        "from_date": fromDate,
        "to_date": toDate,
        "expiring_days": expiringDays,
        "page": page,
        "limit": limit,
        "searchText": searchText,
        "orderBy": orderBy,
        "order": order,
      },
    );

    return ProductExpiryReportModel.fromJson(response);
  }
}