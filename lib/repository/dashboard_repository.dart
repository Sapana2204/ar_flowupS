import '../../constants/appUrls.dart';
import '../../data/network/network_api_services.dart';

class DashboardRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getDashboardData() async {
    try {
      print("========== DASHBOARD API ==========");
      print("URL : ${AppUrls.dashboardApi}");

      final response = await _apiServices.getPostApiResponse(
        AppUrls.dashboardApi,
        {}, // empty body if backend doesn't require params
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