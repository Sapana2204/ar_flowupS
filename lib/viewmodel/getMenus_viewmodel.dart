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

  /// Menus which are currently implemented
  /// in the Android application.
  ///
  /// Web-only menus should NOT be added here
  /// until their Android screen is implemented.
  static const Set<String> mobileSupportedMenus = {
    "dashboard",
    "user-markers",
    "customers",
    "amc-management",
    "quotation",
    "profile",
    "/work-report",
    "reports/performance",
  };

  Future<void> fetchMenus() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final response = await _repository.getMenus();

      final apiMenus = response.data ?? [];

      /// Filter:
      /// 1. Menu must be active
      /// 2. Menu must be implemented in Android
      final mobileMenus = apiMenus.where((menu) {
        final menuLink = menu.menuLink?.trim() ?? "";

        return menu.status?.toLowerCase() == "active" &&
            mobileSupportedMenus.contains(menuLink);
      }).toList();

      /// Sort by menu_index
      mobileMenus.sort(
            (a, b) {
          return (a.menuIndex ?? 999)
              .compareTo(b.menuIndex ?? 999);
        },
      );

      /// Replace API data with Android-supported menus
      response.data = mobileMenus;

      _menuModel = response;

      debugPrint(
        "══════════════════════════════════════",
      );

      debugPrint(
        "🌐 API MENUS: ${apiMenus.length}",
      );

      debugPrint(
        "📱 MOBILE MENUS: ${mobileMenus.length}",
      );

      for (final menu in mobileMenus) {
        debugPrint(
          "📱 ${menu.menuName} | ${menu.menuLink}",
        );
      }

      debugPrint(
        "══════════════════════════════════════",
      );
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