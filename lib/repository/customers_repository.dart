import 'package:flutter/foundation.dart';
import '../data/network/network_api_services.dart';
import '../constants/appUrls.dart';
import '../model/createCustomer_model.dart';
import '../model/customers_model.dart';
import '../model/updateCustomer_model.dart';


class CustomersRepository {
  final _api = NetworkApiServices();

  /// 🔹 LIST
  Future<CustomersModel> fetchCustomers({
    int page = 1,
    String searchText = "",
    List filters = const [],
    String order = "DESC",
    String orderBy = "created_by",
  }) async {
    try {
      final response = await _api.getPostApiResponse(
        AppUrls.customersList,
        {
          "page": page,
          "searchText": searchText,
          "filters": filters,
          "order": order,
          "order_by": orderBy,
        },
      );

      return CustomersModel.fromJson(response);
    } catch (e) {
      debugPrint("❌ Customers Error: $e");
      rethrow;
    }
  }

  /// 🔹 CREATE
  Future<Map<String, dynamic>> createCustomer(CreateCustomer model) async {
    return await _api.getPutApiResponse(
      AppUrls.createCustomer,
      model.toJson(),
    );
  }

  /// 🔹 GET BY ID
  Future<CustomerData> getCustomerById(int id) async {
    final response = await _api.getGetApiResponse(
      "${AppUrls.customerById}$id",
    );

    return CustomerData.fromJson(response["data"]);
  }

  /// 🔹 UPDATE
  Future<Map<String, dynamic>> updateCustomer(UpdateCustomer model) async {
    return await _api.getPostApiResponse(
      "${AppUrls.updateCustomer}${model.customerId}",
      model.toJson(),
    );
  }
}