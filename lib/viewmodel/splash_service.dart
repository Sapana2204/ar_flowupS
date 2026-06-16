import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../model/login_model.dart';
import '../utils/routes/routes_names.dart';

class SplashService {
  static Future<void> checkAuthentication(
      BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();

    print("📦 ALL KEYS ON APP START: ${prefs.getKeys()}");

    final userData = prefs.getString('userData');

    print("📦 USERDATA ON APP START:");
    print(userData);

    if (userData == null) {
      print("❌ NO USERDATA FOUND");
      Navigator.pushReplacementNamed(
        context,
        RouteNames.login,
      );
      return;
    }

    final user =
    LoginModel.fromJson(jsonDecode(userData));

    print("🔑 TOKEN:");
    print(user.token);

    print("⏰ EXPIRED:");
    print(JwtDecoder.isExpired(user.token!));

    if (user.token == null ||
        JwtDecoder.isExpired(user.token!)) {

      print("❌ TOKEN EXPIRED");

      await prefs.remove('userData');

      Navigator.pushReplacementNamed(
        context,
        RouteNames.login,
      );
    } else {
      print("✅ AUTO LOGIN");

      Navigator.pushReplacementNamed(
        context,
        RouteNames.home,
      );
    }
  }
}