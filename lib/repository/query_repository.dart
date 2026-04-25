import '../data/network/network_api_services.dart';
import '../constants/appUrls.dart';
import '../model/queryTypes_model.dart';

class QueryRepository {
  final _apiService = NetworkApiServices();

  Future<List<Sublist>> _fetchBySlug(String slug) async {
    final response = await _apiService.getPostApiResponse(
      AppUrls.queryTypes,
      {
        "text": "",
        "tableName": "categories",
        "wherec": "categoryName",
        "list": "category_id,categoryName",
        "slug": slug,
        "status": "active"
      },
    );

    final model = CommonCategoryModel.fromJson(response);

    if (model.data != null && model.data!.isNotEmpty) {
      return model.data!.first.sublist ?? [];
    }

    return [];
  }

  /// 🔹 Query Types
  Future<List<Sublist>> fetchQueryTypes() async {
    return _fetchBySlug("query_types");
  }

  /// 🔹 Priority Levels
  Future<List<Sublist>> fetchPriorityLevels() async {
    return _fetchBySlug("ticket_priority");
  }
}