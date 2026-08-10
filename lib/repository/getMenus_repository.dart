import '../data/network/network_api_services.dart';
import '../constants/appUrls.dart';
import '../model/getMenus_model.dart';

class GetMenusRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<GetMenusModel> getMenus() async {
    final response = await _apiServices.getPostApiResponse(
      AppUrls.getMenus,
      {
        "getAll": "Y",
      },
    );

    return GetMenusModel.fromJson(response);
  }
}