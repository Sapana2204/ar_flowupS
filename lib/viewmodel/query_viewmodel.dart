import 'package:flutter/material.dart';
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

  /// 🔹 SETTERS
  void setSelectedQuery(String value) {
    _selectedQuery = value;
    notifyListeners();
  }

  void setSelectedPriority(String value) {
    _selectedPriority = value;
    notifyListeners();
  }
}