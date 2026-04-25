import 'package:flutter/material.dart';
import '../model/tickets_model.dart';
import '../repository/tickets_repository.dart';

class TicketsViewModel extends ChangeNotifier {
  final _repository = TicketsRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Data> _ticketsList = [];
  List<Data> get ticketsList => _ticketsList;

  String _error = "";
  String get error => _error;

  int _page = 1;
  int get page => _page;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String _searchText = "";
  String get searchText => _searchText;

  void setSearchText(String value) {
    _searchText = value;
  }
  List<Data> _allTickets = [];   // original data

  /// 🔹 Initial Load
  Future<void> fetchTickets({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        _page = 1;
        _ticketsList.clear();
      }

      _isLoading = true;
      notifyListeners();

      final response = await _repository.fetchTickets(
        page: _page,
        searchText: _searchText, // ✅ ALWAYS use stored value
      );

      if (response.data != null) {
        if (_page == 1) {
          _allTickets = response.data!;     // ✅ store original
          _ticketsList = response.data!;    // ✅ show initially
        } else {
          _allTickets.addAll(response.data!);
          _ticketsList.addAll(response.data!);
        }

        _hasMore = response.pagination?.totalPages != _page;
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

        return name.contains(query.toLowerCase()) ||
            phone.contains(query) ||
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
}