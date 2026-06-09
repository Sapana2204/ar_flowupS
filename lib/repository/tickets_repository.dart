import 'package:flutter/foundation.dart';
import '../data/network/network_api_services.dart';
import '../model/comment_model.dart';
import '../model/createWorkLog_model.dart';
import '../model/createTicket_model.dart';
import '../model/ticketHistory_model.dart';
import '../model/tickets_model.dart';
import '../constants/appUrls.dart';
import '../model/updateTicket_model.dart';
import '../model/updateWorkLog_model.dart';

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

  Future<Ticketsmodel> getTicketById({
    required int ticketId,
    int? clientId,
  }) async {
    try {
      final response = await _apiService.getGetApiResponse(
        "${AppUrls.ticketDetailsById}$ticketId"
            "?client_id=$clientId&getAll=Y",
      );

      return Ticketsmodel.fromJson(response);
    } catch (e) {
      debugPrint("❌ Get Ticket By Id Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateTicket(UpdateTicketModel model) async {
    try {
      final response = await _apiService.getPostApiResponse(
        "${AppUrls.updateTicket}${model.ticketId}", // 👈 dynamic ID
        model.toJson(),
      );

      return response;
    } catch (e) {
      throw Exception("Update Ticket Failed: $e");
    }
  }

  Future<List<CommentModel>> fetchComments(int ticketId) async {
    try {
      final response = await _apiService.getPostApiResponse(
        AppUrls.commentsList,
        {
          "module": "tickets",
          "order_by": "created_date",
          "order": "DESC",
          "module_id": ticketId,
          "ticket_id": ticketId,
          "getAll": "Y",
        },
      );

      if (response["data"] != null) {
        return (response["data"] as List)
            .map((e) => CommentModel.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createComment({
    required int ticketId,
    required String comment,
  }) async {
    try {
      final response = await _apiService.getPutApiResponse(
        AppUrls.createComment,
        {
          "module": "tickets",
          "module_id": ticketId,
          "ticket_id": ticketId,
          "record_type": "ticket",
          "comment": comment,
          "status": "active",
        },
      );

      return response["success"] == true;
    } catch (e) {
      return false;
    }
  }

  Future<List<TicketHistoryModel>> fetchTicketHistory(
      int ticketId,
      ) async {
    try {
      final response = await _apiService.getPostApiResponse(
        AppUrls.ticketHistory,
        {
          "ticket_id": ticketId,
        },
      );

      if (response["data"] == null) return [];

      return (response["data"] as List)
          .map((e) => TicketHistoryModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("❌ Ticket History Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchTicketWorkLogs(
      int ticketId,
      ) async {
    try {
      final response = await _apiService.getPostApiResponse(
        AppUrls.ticketWorkLogs,
        {
          "ticket_id": ticketId,
        },
      );

      return response;
    } catch (e) {
      debugPrint("❌ Work Logs Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createWorkLog(
      CreateWorkLogModel model,
      ) async {
    try {
      print("════════ CREATE WORK LOG API ════════");
      print("URL => ${AppUrls.createWorkLog}");
      print("PAYLOAD => ${model.toJson()}");

      final response = await _apiService.getPutApiResponse(
        AppUrls.createWorkLog,
        model.toJson(),
      );

      print("RESPONSE => $response");
      print("═════════════════════════════════════");

      return response;
    } catch (e, s) {
      print("❌ CREATE WORK LOG ERROR => $e");
      print(s);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateWorkLog(
      UpdateWorkLogModel model,
      ) async {
    try {
      print("════════ UPDATE WORK LOG API ════════");
      print("URL => ${AppUrls.updateWorkLog}");
      print("PAYLOAD => ${model.toJson()}");

      final response = await _apiService.getPostApiResponse(
        AppUrls.updateWorkLog,
        model.toJson(),
      );

      print("RESPONSE => $response");
      print("═════════════════════════════════════");

      return response;
    } catch (e, s) {
      print("❌ UPDATE WORK LOG ERROR => $e");
      print(s);
      rethrow;
    }
  }
}
