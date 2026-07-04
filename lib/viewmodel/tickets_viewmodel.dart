import 'package:flutter/material.dart';
import '../model/comment_model.dart';
import '../model/createVisit_model.dart';
import '../model/createWorkLog_model.dart';
import '../model/createTicket_model.dart';
import '../model/ticketHistory_model.dart';
import '../model/tickets_model.dart';
import '../model/updateTicket_model.dart';
import '../model/updateWorkLog_model.dart';
import '../model/visits_model.dart';
import '../model/workLogSummary_model.dart';
import '../model/workLog_model.dart';
import '../repository/tickets_repository.dart';

class TicketsViewModel extends ChangeNotifier {
  final _repository = TicketsRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Data> _ticketsList = [];
  List<Data> get ticketsList => _ticketsList;

  List<Data> _clientHistoryList = [];
  List<Data> get clientHistoryList => _clientHistoryList;

  bool _clientHistoryLoading = false;
  bool get clientHistoryLoading => _clientHistoryLoading;

  String _error = "";
  String get error => _error;

  int _page = 1;
  int get page => _page;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String _searchText = "";
  String get searchText => _searchText;

  List<Data> _allTickets = [];   // original data

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  String _createMessage = "";
  String get createMessage => _createMessage;

  Ticketsmodel? _ticketDetail;
  Ticketsmodel? get ticketDetail => _ticketDetail;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  String _updateMessage = "";
  String get updateMessage => _updateMessage;

  List<CommentModel> commentsList = [];

  bool commentsLoading = false;

  TextEditingController commentController =
  TextEditingController();

  List<TicketHistoryModel> ticketHistoryList = [];

  bool historyLoading = false;

  bool workLogsLoading = false;

  List<WorkLog> workLogsList = [];

  WorkLogSummary? workLogSummary;
  bool createWorkLogLoading = false;
  bool updateWorkLogLoading = false;

  bool visitsLoading = false;
  List<VisitData> visitsList = [];

  bool createVisitLoading = false;

  String _workLogErrorMessage = "";
  String get workLogErrorMessage => _workLogErrorMessage;

  String _status = "active";
  String get status => _status;

  int _selectedAssigneeId = 0;
  int get selectedAssigneeId => _selectedAssigneeId;

  Future<void> setAssignee(int assigneeId) async {
    _selectedAssigneeId = assigneeId;
    await fetchTickets(isRefresh: true);
  }

  void setSearchText(String value) {
    _searchText = value;
  }

  /// 🔹 Initial Load
  Future<void> fetchTickets({bool isRefresh = false}) async {
    try {
      if (_isLoading) return;

      if (isRefresh) {
        _page = 1;
        _ticketsList.clear();
        _allTickets.clear();
        _hasMore = true;
      }

      _isLoading = true;
      _error = "";
      notifyListeners();

      final List<Map<String, dynamic>> filters = [];

      if (_selectedAssigneeId != 0) {
        filters.add({
          "field": "assignee",
          "condition": "equal_to",
          "value": _selectedAssigneeId,
          "type": "select",
        });
      }

      final response = await _repository.fetchTickets(
        status: _status,
        page: _page,
        searchText: _searchText,
        filters: filters,
      );

      final newData = response.data ?? [];

      if (_page == 1) {
        _ticketsList = List.from(newData);
        _allTickets = List.from(newData);
      } else {
        _ticketsList.addAll(newData);
        _allTickets.addAll(newData);
      }

      _hasMore = _page < (response.pagination?.totalPages ?? 0);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetAssignee() async {
    _selectedAssigneeId = 0;
    _searchText = "";
    await fetchTickets(isRefresh: true);
  }

  Future<void> searchTickets(
      String query, {
        String? status,
      }) async {
    _searchText = query.trim();

    if (status != null) {
      _status = status;
    }

    _page = 1;
    _hasMore = true;
    _ticketsList.clear();
    _allTickets.clear();

    await fetchTickets(isRefresh: true);
  }

  /// 🔹 Pagination
  Future<void> loadMore() async {
    if (!_hasMore || _isLoading) return;
    _page++;
    await fetchTickets();
  }

  void resetTicketsState() {
    _searchText = "";
    _status = "active"; // Reset status filter
    _page = 1;
    _hasMore = true;
    _error = "";
    _ticketsList.clear();
    _allTickets.clear();
    notifyListeners();
  }

  /// 🔹 Refresh
  Future<void> refreshTickets() async {
    await fetchTickets(isRefresh: true); // ✅ will use _searchText automatically
  }

  Future<bool> createTicket(CreateTicket ticket) async {
    try {
      _isCreating = true;
      _createMessage = "";
      notifyListeners();

      final response = await _repository.createTicket(ticket);

      if (response["success"] == true) {
        _createMessage = response["message"] ?? "Ticket created successfully";

        // 🔄 Refresh list after creation
        await fetchTickets(isRefresh: true);

        return true;
      } else {
        _createMessage = response["message"] ?? "Failed to create ticket";
        return false;
      }
    } catch (e) {
      _createMessage = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<void> fetchClientHistory(int clientId) async {
    try {
      _clientHistoryLoading = true;
      notifyListeners();

      final response =
      await _repository.fetchClientTickets(clientId);

      if (response.data != null) {
        _clientHistoryList = response.data!;
      } else {
        _clientHistoryList = [];
      }

    } catch (e) {
      debugPrint(e.toString());
      _clientHistoryList = [];
    } finally {
      _clientHistoryLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTicketById({
    required int ticketId,
    int? clientId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _repository.getTicketById(
        ticketId: ticketId,
        clientId: clientId,
      );

      _ticketDetail = response;

      _error = "";
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTicket(UpdateTicketModel ticket) async {
    try {
      _isUpdating = true;
      _updateMessage = "";
      notifyListeners();

      final response = await _repository.updateTicket(ticket);

      if (response["success"] == true) {
        _updateMessage = response["message"] ?? "Updated successfully";

        // 🔄 Refresh list after update
        await fetchTickets(isRefresh: true);

        return true;
      } else {
        _updateMessage = response["message"] ?? "Failed to update ticket";
        return false;
      }
    } catch (e) {
      _updateMessage = e.toString();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> fetchComments(int ticketId) async {
    try {
      commentsLoading = true;
      notifyListeners();

      commentsList =
      await _repository.fetchComments(ticketId);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      commentsLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addComment(int ticketId) async {
    if (commentController.text.trim().isEmpty) {
      return false;
    }

    final success = await _repository.createComment(
      ticketId: ticketId,
      comment: commentController.text.trim(),
    );

    if (success) {
      commentController.clear();
      await fetchComments(ticketId);
    }

    return success;
  }

  Future<void> fetchTicketHistory(int ticketId) async {
    try {
      historyLoading = true;
      notifyListeners();

      ticketHistoryList =
      await _repository.fetchTicketHistory(ticketId);

    } catch (e) {
      debugPrint("❌ History Error: $e");
    } finally {
      historyLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTicketWorkLogs(int ticketId) async {
    try {
      workLogsLoading = true;
      notifyListeners();

      final response =
      await _repository.fetchTicketWorkLogs(ticketId);

      workLogsList =
          (response["data"] as List?)
              ?.map((e) => WorkLog.fromJson(e))
              .toList() ??
              [];

      workLogSummary = response["summary"] != null
          ? WorkLogSummary.fromJson(response["summary"])
          : null;

    } catch (e) {
      debugPrint("❌ Work Logs Error: $e");
    } finally {
      workLogsLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createWorkLog(
      CreateWorkLogModel model,
      ) async {
    try {
      createWorkLogLoading = true;
      notifyListeners();

      final response =
      await _repository.createWorkLog(model);

      if (response["success"] == true) {
        await fetchTicketWorkLogs(model.ticketId);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint("❌ Create Work Log Error: $e");
      return false;
    } finally {
      createWorkLogLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateWorkLog(
      UpdateWorkLogModel model,
      ) async {
    try {
      updateWorkLogLoading = true;
      notifyListeners();

      final response =
      await _repository.updateWorkLog(model);

      print("UPDATE RESPONSE => $response");

      if (response["success"] == true) {
        print("FETCHING WORK LOGS");

        await fetchTicketWorkLogs(model.ticketId);

        print("RETURNING TRUE");

        return true;
      }

      print("RETURNING FALSE");
      return false;
    } catch (e, s) {
      print("UPDATE ERROR => $e");
      print(s);
      return false;
    } finally {
      updateWorkLogLoading = false;
      notifyListeners();
    }
  }

  Future<int?> createWorkLogAndReturnId(CreateWorkLogModel model) async {
    try {
      _workLogErrorMessage = "";
      print("VM CREATE WORK LOG START");

      final response = await _repository.createWorkLog(model);

      print("VM RESPONSE => $response");

      if (response["success"] == true) {
        return response["insertId"];
      }

      _workLogErrorMessage =
          response["message"]?.toString() ?? "Failed to create work log";

      return null;
    } catch (e, s) {
      print("❌ VM CREATE ERROR => $e");
      print(s);

      _workLogErrorMessage = e.toString().replaceFirst("Exception: ", "");
      return null;
    }
  }

  Future<void> fetchTicketVisits(int ticketId) async {
    try {
      visitsLoading = true;
      notifyListeners();

      final response =
      await _repository.fetchTicketVisits(ticketId);

      visitsList = response.data ?? [];
    } catch (e) {
      debugPrint("❌ Visits Error: $e");
      visitsList = [];
    } finally {
      visitsLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createVisit(
      CreateVisitModel model,
      ) async {
    try {
      createVisitLoading = true;
      notifyListeners();

      final response =
      await _repository.createVisit(model);

      if (response["success"] == true) {

        // Refresh visits list
        await fetchTicketVisits(model.ticketId!);

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("❌ Create Visit Error: $e");
      return false;
    } finally {
      createVisitLoading = false;
      notifyListeners();
    }
  }

}