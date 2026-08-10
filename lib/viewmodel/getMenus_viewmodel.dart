import 'package:flutter/material.dart';

import '../model/getMenus_model.dart';
import '../repository/getMenus_repository.dart';

class GetMenusViewModel extends ChangeNotifier {
  final GetMenusRepository _repository = GetMenusRepository();

  GetMenusModel? _menuModel;

  bool _isLoading = false;
  String? _errorMessage;

  GetMenusModel? get menuModel => _menuModel;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<Data> get menus {
    return _menuModel?.data ?? [];
  }

  Future<void> fetchMenus() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final response = await _repository.getMenus();

      _menuModel = response;

      // Only active menus
      _menuModel?.data = (_menuModel?.data ?? [])
          .where(
            (menu) =>
        menu.status?.toLowerCase() == "active",
      )
          .toList();

      // Sort according to menu_index
      _menuModel?.data?.sort(
            (a, b) =>
            (a.menuIndex ?? 999).compareTo(b.menuIndex ?? 999),
      );

      debugPrint(
        "✅ Menus loaded: ${_menuModel?.data?.length}",
      );

      for (final menu in _menuModel?.data ?? []) {
        debugPrint(
          "MENU: ${menu.menuName} | ${menu.menuLink} | ${menu.status}",
        );
      }
    } catch (e) {
      _errorMessage = e.toString();

      debugPrint(
        "❌ Get Menus Error: $e",
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}