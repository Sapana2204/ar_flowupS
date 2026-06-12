import '../constants/appUrls.dart';
import '../data/network/network_api_services.dart';
import '../model/workPerformance_model.dart';

class WorkPerformanceRepository {
  final NetworkApiServices _api =
  NetworkApiServices();

  Future<WorkPerformanceModel>
  getUserPerformanceReport({
    required String userId,
    required String fromDate,
    required String toDate,
    String companyId = "",
    String ticketStatus = "",
    String searchText = "",
    int page = 1,
    int limit = 10,
    String orderBy = "assigned_date",
    String order = "DESC",
  }) async {
    final response =
    await _api.getPostApiResponse(
      AppUrls.userPerformanceReport,
      {
        "user_id": userId,
        "from_date": fromDate,
        "to_date": toDate,
        "company_id": companyId,
        "ticket_status": ticketStatus,
        "searchText": searchText,
        "page": page,
        "limit": limit,
        "order_by": orderBy,
        "order": order,
      },
    );

    return WorkPerformanceModel.fromJson(
      response,
    );
  }
}