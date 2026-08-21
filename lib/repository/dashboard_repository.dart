import '../../constants/appUrls.dart';
import '../../data/network/network_api_services.dart';

class DashboardRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getDashboardData({
    required String fromDate,
    String? toDate,
  }) async {
    try {
      print("========== DASHBOARD API ==========");
      print("URL : ${AppUrls.dashboardApi}");

      final body = {
        "from_date": fromDate,
        "to_date": toDate,
      };

      print("REQUEST BODY : $body");

      final response = await _apiServices.getPostApiResponse(
        AppUrls.dashboardApi,
        body,
      );

      print("========== DASHBOARD RESPONSE ==========");
      print(response);

      return response;
    } catch (e) {
      print("========== DASHBOARD ERROR ==========");
      print(e.toString());
      rethrow;
    }
  }
}