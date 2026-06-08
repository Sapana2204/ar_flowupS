import '../data/network/network_api_services.dart';
import '../constants/appUrls.dart';
import '../model/adminData_model.dart';
import '../model/clientData_model.dart';
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

  /// 🔹 FETCH ADMIN LIST
  Future<List<AdminData>> fetchAdmins() async {
    final response = await _apiService.getPostApiResponse(
      AppUrls.searchAssignee,
      {
        "text": "",
        "system": "new",
        "tableName": "admin",
        "wherec": "name",
        "status": false,
        "list": "adminID,name",
      },
    );

    print("ASSIGNEE RESPONSE => $response");

    if (response['data'] != null) {
      return (response['data'] as List)
          .map((e) => AdminData.fromJson(e))
          .toList();
    }

    return [];
  }

  Future<List<ClientData>> fetchClients({String text = ""}) async {
    final response = await _apiService.getPostApiResponse(
      AppUrls.searchList,
      {
        "text": text,
        "system": "new",
        "tableName": "customer",
        "wherec": "name",
        "status": false,
        "list":
        "customer_id,name,created_date,mobile_no,customer_products"
      },
    );

    if (response['data'] != null) {
      return (response['data'] as List)
          .map((e) => ClientData.fromJson(e))
          .toList();
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

  /// 🔹 Ticket Status
  Future<List<Sublist>> fetchStatusList() async {
    return _fetchBySlug("ticket_status");
  }
}