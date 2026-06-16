import '../constants/appUrls.dart';
import '../data/network/network_api_services.dart';

class UserStatusRepository {
  final NetworkApiServices _api = NetworkApiServices();

  Future<bool> updateUserStatus(String status) async {
    try {
      final response = await _api.getPostApiResponse(
        AppUrls.userStatus,
        {
          "status": status, // active / inactive
        },
      );

      return response != null;
    } catch (e) {
      rethrow;
    }
  }
}