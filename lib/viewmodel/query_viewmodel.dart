import 'package:flutter/material.dart';
import '../model/adminData_model.dart';
import '../model/clientData_model.dart';
import '../model/customerProduct.dart';
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

  List<Sublist> _statusList = [];
  List<Sublist> get statusList => _statusList;

  String? _selectedStatus;
  String? get selectedStatus => _selectedStatus;

  CustomerProduct? _selectedProduct;
  CustomerProduct? get selectedProduct => _selectedProduct;

  void setSelectedProduct(CustomerProduct? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  void setSelectedClient(ClientData value) {
    _selectedClient = value;
    notifyListeners();
  }

  void setSelectedAdmin(String value) {
    _selectedAdmin = value;
    notifyListeners();
  }

  void setSelectedStatus(String value) {
    _selectedStatus = value;
    notifyListeners();
  }

  Future<void> fetchStatusList() async {
    try {
      _isLoading = true;
      notifyListeners();

      _statusList = await _repository.fetchStatusList();

      if (_statusList.isNotEmpty) {
        _selectedStatus = _statusList.first.categoryName;
      }

    } catch (e) {
      debugPrint("❌ Status Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

      // ❌ DO NOTHING (no default selection)
      _selectedClient = null;

    } catch (e) {
      debugPrint("❌ Client Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetSelections() {
    _selectedClient = null;
    _selectedProduct = null; // ADD
    _selectedQuery = null;
    _selectedPriority = null;
    _selectedAdmin = null;
    _selectedStatus = null;
    notifyListeners();
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

  String? getSelectedStatusId() {
    try {
      final item = statusList.firstWhere(
            (e) => e.categoryName == selectedStatus,
      );
      return item.categoryId?.toString();
    } catch (e) {
      return null;
    }
  }
  void setSelectedQueryById(String? id) {
    try {
      final item = _queryList.firstWhere(
            (e) => e.categoryId.toString() == id,
      );
      _selectedQuery = item.categoryName;
      notifyListeners();
    } catch (_) {}
  }
  void setSelectedPriorityById(String? id) {
    try {
      final item = _priorityList.firstWhere(
            (e) => e.categoryId.toString() == id,
      );
      _selectedPriority = item.categoryName;
      notifyListeners();
    } catch (_) {}
  }
  void setSelectedAdminById(String? id) {
    try {
      final item = _adminList.firstWhere(
            (e) => e.adminID.toString() == id,
      );
      _selectedAdmin = item.name;
      notifyListeners();
    } catch (_) {}
  }
  void setSelectedStatusById(String? id) {
    try {
      final item = _statusList.firstWhere(
            (e) => e.categoryId.toString() == id,
      );
      _selectedStatus = item.categoryName;
      notifyListeners();
    } catch (_) {}
  }
}