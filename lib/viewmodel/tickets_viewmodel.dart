import 'package:flutter/material.dart';
import '../model/comment_model.dart';
import '../model/createTicket_model.dart';
import '../model/ticketHistory_model.dart';
import '../model/tickets_model.dart';
import '../model/updateTicket_model.dart';
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


  void setSearchText(String value) {
    _searchText = value;
  }

  /// 🔹 Initial Load
  Future<void> fetchTickets({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        _page = 1;
        _ticketsList.clear();
        _allTickets.clear();
      }

      _isLoading = true;
      notifyListeners();

      final response = await _repository.fetchTickets(
        page: _page,
        searchText: _searchText,
      );

      print("PAGE: $_page");
      print("TOTAL: ${response.pagination?.totalPages}");
      print("DATA: ${response.data?.length}");

      if (response.data != null) {
        if (_page == 1) {
          _allTickets = List.from(response.data!);
          _ticketsList = List.from(response.data!);
        } else {
          _allTickets.addAll(response.data!);
          _ticketsList.addAll(response.data!);
        }

        _hasMore = _page < (response.pagination?.totalPages ?? 0);
      }

      _error = "";
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterTickets(String query) {
    _searchText = query;

    if (query.isEmpty) {
      _ticketsList = List.from(_allTickets);
    } else {
      _ticketsList = _allTickets.where((ticket) {
        final name = ticket.clientId?.toLowerCase() ?? "";
        final phone = ticket.contactNo ?? "";
        final ticketNo = ticket.ticketNo?.toLowerCase() ?? "";
        final queryType = ticket.queryType?.toLowerCase() ?? "";
        final description = ticket.description?.toLowerCase() ?? "";

        return name.contains(query.toLowerCase()) ||
            phone.contains(query) ||queryType.contains(query)||description.contains(query)||
            ticketNo.contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  /// 🔹 Pagination
  Future<void> loadMore() async {
    if (!_hasMore || _isLoading) return;

    _page++;
    await fetchTickets(); // ✅ no parameter needed
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


}