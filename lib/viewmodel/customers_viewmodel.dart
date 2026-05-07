import 'package:flutter/material.dart';
import '../model/createCustomer_model.dart';
import '../model/customers_model.dart';
import '../model/updateCustomer_model.dart';
import '../repository/customers_repository.dart';

class CustomersViewModel extends ChangeNotifier {
  final _repo = CustomersRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CustomerData> _customers = [];
  List<CustomerData> get customers => _customers;

  List<CustomerData> _allCustomers = [];

  String _error = "";
  String get error => _error;

  int _page = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;   // ✅ THIS LINE IS MISSING

  String _searchText = "";

  void setSearchText(String value) {
    _searchText = value;
  }

  /// 🔹 FETCH
  Future<void> fetchCustomers({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        _page = 1;
        _customers.clear();
        _allCustomers.clear();
        _hasMore = true;   // ✅ ADD THIS (important)
      }

      _isLoading = true;
      notifyListeners();

      final res = await _repo.fetchCustomers(
        page: _page,
        searchText: _searchText,
      );

      if (res.data != null) {
        if (_page == 1) {
          _allCustomers = List.from(res.data!);
          _customers = List.from(res.data!);
        } else {
          _allCustomers.addAll(res.data!);
          _customers.addAll(res.data!);
        }

        _hasMore = _page < (res.pagination?.totalPages ?? 0);
      }

      _error = "";
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔍 SEARCH (LOCAL)
  void filterCustomers(String query) {
    _searchText = query;

    if (query.isEmpty) {
      _customers = List.from(_allCustomers);
    } else {
      _customers = _allCustomers.where((c) {
        final name = c.name?.toLowerCase() ?? "";
        final mobile = c.mobileNo ?? "";

        return name.contains(query.toLowerCase()) ||
            mobile.contains(query);
      }).toList();
    }

    notifyListeners();
  }

  /// 🔹 PAGINATION
  Future<void> loadMore() async {
    if (!_hasMore || _isLoading) return;

    _page++;
    await fetchCustomers();
  }

  /// 🔹 CREATE
  Future<bool> createCustomer(CreateCustomer model) async {
    final res = await _repo.createCustomer(model);

    if (res["success"] == true) {
      await fetchCustomers(isRefresh: true);
      return true;
    }
    return false;
  }

  /// 🔹 UPDATE
  Future<bool> updateCustomer(UpdateCustomer model) async {
    final res = await _repo.updateCustomer(model);

    if (res["success"] == true) {
      await fetchCustomers(isRefresh: true);
      return true;
    }
    return false;
  }
}