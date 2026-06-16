import '../data/network/network_api_services.dart';
import '../model/amcActivity_model.dart';
import '../model/amc_model.dart';
import '../constants/appUrls.dart';
import '../model/scheduleAMCVisit_model.dart';

class AMCRepository {
  final NetworkApiServices _api = NetworkApiServices();

  Future<AMCModel> getAMCReminders({
    int page = 1,
    String searchText = "",
    List filters = const [],
    String order = "DESC",
    String orderBy = "remaining_call_count",
  }) async {
    final response = await _api.getPostApiResponse(
      AppUrls.amcReminders,
      {
        "page": page,
        "searchText": searchText,
        "filters": filters,
        "order": order,
        "order_by": orderBy,
      },
    );

    return AMCModel.fromJson(response);
  }

  Future<Map<String, dynamic>> sendAMCReminder({
    required int customerId,
    required bool includeReport,
  }) async {
    final response = await _api.getPostApiResponse(
      AppUrls.sendAMCReminder,
      {
        "customer_id": customerId,
        "include_report": includeReport,
      },
    );

    return response;
  }

  Future<Map<String, dynamic>> scheduleAMCVisit(
      ScheduleAMCVisitRequest request,
      ) async {
    final response = await _api.getPostApiResponse(
      AppUrls.scheduleAMCVisit,
      request.toJson(),
    );

    return response;
  }

  Future<AMCActivityModel> getAMCActivity({
    required int customerId,
  }) async {
    final response = await _api.getPostApiResponse(
      AppUrls.amcActivity,
      {
        "customer_id": customerId,
      },
    );

    return AMCActivityModel.fromJson(response);
  }
}