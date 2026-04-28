import 'package:flutter/material.dart';
import '../model/adminData_model.dart';
import '../model/clientData_model.dart';
import '../model/queryTypes_model.dart';
import '../repository/query_repository.dart';

class QueryViewModel extends ChangeNotifier {
  final _repository = QueryRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 🔹 QUERY LIST
  List<Sublist> _queryList = [];
  List<Sublist> get queryList => _queryList;

  String? _selectedQuery;
  String? get selectedQuery => _selectedQuery;

  /// 🔹 PRIORITY LIST
  List<Sublist> _priorityList = [];
  List<Sublist> get priorityList => _priorityList;

  String? _selectedPriority;
  String? get selectedPriority => _selectedPriority;

  /// 🔹 ADMIN LIST
  List<AdminData> _adminList = [];
  List<AdminData> get adminList => _adminList;

  String? _selectedAdmin;
  String? get selectedAdmin => _selectedAdmin;

  List<ClientData> _clientList = [];
  List<ClientData> get clientList => _clientList;

  ClientData? _selectedClient;
  ClientData? get selectedClient => _selectedClient;

  void setSelectedClient(ClientData value) {
    _selectedClient = value;
    notifyListeners();
  }

  void setSelectedAdmin(String value) {
    _selectedAdmin = value;
    notifyListeners();
  }

  /// 🔹 FETCH QUERY TYPES
  Future<void> fetchQueryTypes() async {
    try {
      _isLoading = true;
      notifyListeners();

      _queryList = await _repository.fetchQueryTypes();

      if (_queryList.isNotEmpty) {
        _selectedQuery = _queryList.first.categoryName;
      }

    } catch (e) {
      debugPrint("❌ Query Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 FETCH PRIORITY LEVELS
  Future<void> fetchPriorityLevels() async {
    try {
      _isLoading = true;
      notifyListeners();

      _priorityList = await _repository.fetchPriorityLevels();

      if (_priorityList.isNotEmpty) {
        _selectedPriority = _priorityList.first.categoryName;
      }

    } catch (e) {
      debugPrint("❌ Priority Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAdmins() async {
    try {
      _isLoading = true;
      notifyListeners();

      _adminList = await _repository.fetchAdmins();

      if (_adminList.isNotEmpty) {
        _selectedAdmin = _adminList.first.name;
      }

    } catch (e) {
      debugPrint("❌ Admin Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchClients({String text = ""}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _clientList = await _repository.fetchClients(text: text);

      if (_clientList.isNotEmpty) {
        _selectedClient = _clientList.first;      }

    } catch (e) {
      debugPrint("❌ Client Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 SETTERS
  void setSelectedQuery(String value) {
    _selectedQuery = value;
    notifyListeners();
  }

  void setSelectedPriority(String value) {
    _selectedPriority = value;
    notifyListeners();
  }

  String? getSelectedQueryId() {
    try {
      final item = queryList.firstWhere(
            (e) => e.categoryName == selectedQuery,
      );
      return item.categoryId?.toString();
    } catch (e) {
      return null;
    }
  }

  String? getSelectedPriorityId() {
    try {
      final item = priorityList.firstWhere(
            (e) => e.categoryName == selectedPriority,
      );
      return item.categoryId?.toString();
    } catch (e) {
      return null;
    }
  }

  String? getSelectedAdminId() {
    try {
      final item = adminList.firstWhere(
            (e) => e.name == selectedAdmin,
      );
      return item.adminID?.toString();
    } catch (e) {
      return null;
    }
  }
}