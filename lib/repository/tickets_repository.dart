import 'package:flutter/foundation.dart';
import '../data/network/network_api_services.dart';
import '../model/createTicket_model.dart';
import '../model/tickets_model.dart';
import '../constants/appUrls.dart';

class TicketsRepository {
  final _apiService = NetworkApiServices();

  Future<Ticketsmodel> fetchTickets({
    String status = "active",
    int page = 1,
    String searchText = "",
    List filters = const [],
    String order = "DESC",
    String orderBy = "created_by",
  }) async {
    try {
      final response = await _apiService.getPostApiResponse(
        AppUrls.ticketsList,
        {
          "status": status,
          "page": page,
          "searchText": searchText,
          "filters": filters,
          "order": order,
          "order_by": orderBy,
        },
      );

      return Ticketsmodel.fromJson(response);
    } catch (e) {
      debugPrint("❌ TicketsRepository Error: $e");
      rethrow;
    }
  }

  // 🔹 CREATE TICKET
  Future<Map<String, dynamic>> createTicket(CreateTicket model) async {
    try {
      final response = await _apiService.getPutApiResponse(
        AppUrls.createTicket, // ✅ use constant instead of hardcoded URL
        model.toJson(),
      );

      return response;
    } catch (e) {
      throw Exception("Create Ticket Failed: $e");
    }
  }

  Future<Ticketsmodel> fetchClientTickets(int clientId) async {
    try {
      final response = await _apiService.getPostApiResponse(
        AppUrls.ticketsList,
        {
          "client_id": clientId,
          "getAll": "Y",
        },
      );

      return Ticketsmodel.fromJson(response);
    } catch (e) {
      debugPrint("❌ Client Tickets Error: $e");
      rethrow;
    }
  }
}
