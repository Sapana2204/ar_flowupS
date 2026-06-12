import '../data/network/network_api_services.dart';
import '../model/amc_model.dart';
import '../constants/appUrls.dart';

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
}