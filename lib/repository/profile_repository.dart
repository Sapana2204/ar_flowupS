import '../data/network/base_api_services.dart';
import '../data/network/network_api_services.dart';
import '../constants/appUrls.dart';

class ProfileRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getProfileApi() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
        AppUrls.baseUrl + AppUrls.profile,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}