import '../data/network/network_api_services.dart';
import '../constants/appUrls.dart';
import '../model/assignee_model.dart';
import '../model/company_model.dart';
import '../model/workReport_model.dart';

class WorkReportRepository {
  final NetworkApiServices _api = NetworkApiServices();

  Future<List<AssigneeModel>> getAssignees() async {
    final response = await _api.getPostApiResponse(
      AppUrls.searchList,
      {
        "tableName": "admin",
        "selectFields":
        "adminID,name,email,userName,roleID,status",
        "searchField": "name",
        "searchText": "",
        "status": "active"
      },
    );

    List data = response["data"] ?? [];

    return data
        .map((e) => AssigneeModel.fromJson(e))
        .toList();
  }

  Future<List<CompanyModel>> getCompanies() async {
    final response = await _api.getPostApiResponse(
      AppUrls.searchList,
      {
        "tableName": "company_master",
        "selectFields":
        "company_id,company_name",
        "searchField": "company_name",
        "searchText": "",
        "status": "active"
      },
    );

    List data = response["data"] ?? [];

    return data
        .map((e) => CompanyModel.fromJson(e))
        .toList();
  }

  Future<WorkReportModel> getWorkReport({
    String userId = "",
    String companyId = "",
    String fromDate = "",
    String toDate = "",
    int page = 1,
    int limit = 10,
    String searchText = "",
  }) async {
    final response = await _api.getPostApiResponse(
      AppUrls.workReport,
      {
        "user_id": userId,
        "company_id": companyId,
        "from_date": fromDate,
        "to_date": toDate,
        "page": page,
        "limit": limit,
        "searchText": searchText,
        "order_by": "work_start_at",
        "order": "DESC"
      },
    );

    return WorkReportModel.fromJson(response);
  }
}