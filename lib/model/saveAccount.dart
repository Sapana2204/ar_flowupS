import 'dart:convert';

import 'package:my_new_project/model/savedAccount.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveAccount(
    String username,
    String password,
    ) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> accounts =
      prefs.getStringList("saved_accounts") ?? [];

  List<SavedAccount> list = accounts
      .map((e) => SavedAccount.fromJson(jsonDecode(e)))
      .toList();

  // Remove existing account if already present
  list.removeWhere((e) => e.username == username);

  // Add latest account at top
  list.insert(
    0,
    SavedAccount(
      username: username,
      password: password,
    ),
  );

  // Keep only last 5 accounts
  if (list.length > 5) {
    list = list.sublist(0, 5);
  }

  await prefs.setStringList(
    "saved_accounts",
    list.map((e) => jsonEncode(e.toJson())).toList(),
  );
}