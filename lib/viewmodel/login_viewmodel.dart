import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/network/network_api_services.dart';
import '../data/network/socket_service.dart';
import '../model/login_model.dart';
import '../repository/login_repository.dart';
import '../utils/routes/routes_names.dart';
import '../utils/utils.dart';

class LoginViewModel with ChangeNotifier {
  final _loginRepository = LoginRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginModel? _userData;
  LoginModel? get userData => _userData;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUserData(LoginModel user) {
    _userData = user;
    notifyListeners();
  }

  /// ✅ Save user locally
  Future<void> saveUserData(LoginModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(user.toJson()));
  }

  /// ✅ LOGIN API
  Future<void> loginApi(
      String username, String password, BuildContext context) async {

    setLoading(true);

    try {
      final response = await _loginRepository.loginApi(username, password);

      final loginModel = LoginModel.fromJson(response);

      if (loginModel.token != null && loginModel.token!.isNotEmpty) {

        setUserData(loginModel);
        await saveUserData(loginModel);

        /// ✅ CONNECT SOCKET HERE
        SocketService().connect(loginModel.adminId.toString());

        /// 🔐 Decode Token
        final decoded = JwtDecoder.decode(loginModel.token!);
        print("🔐 Decoded Token: $decoded");

        print("👤 AdminID: ${loginModel.adminId}");
        print("👤 Username: ${loginModel.username}");
        print("🎭 RoleID: ${loginModel.roleId}");

        /// ⏳ Auto Logout on Expiry
        final expiry = JwtDecoder.getExpirationDate(loginModel.token!);
        final duration = expiry.difference(DateTime.now());

        print("⌛ Token valid for: $duration");

        Future.delayed(duration, () {
          logout(context);
          Utils.showToast("Session expired. Please login again.");
        });

        Utils.showToast("Login Successful!");

        /// ✅ SEND LOCATION (fire & forget)
        _sendLocationToServer();

        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.home,
              (route) => false,
        );


      } else {
        Utils.showToast("Invalid login response");
      }

    } catch (e) {
      Utils.showToast(e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// ✅ Logout
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _userData = null;

    /// 🔥 DISCONNECT SOCKET
    SocketService().disconnect();

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.login,
          (route) => false,
    );
  }


  /// ✅ Session Check
  Future<void> checkUserSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('userData');

    if (data != null) {
      final user = LoginModel.fromJson(jsonDecode(data));

      if (user.token != null && !JwtDecoder.isExpired(user.token!)) {
        setUserData(user);

        Navigator.pushReplacementNamed(context, RouteNames.home);
      } else {
        await logout(context);
      }
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }

  Future<void> _sendLocationToServer() async {
    try {
      final api = NetworkApiServices();

      Position position = await api.getUserLocation();

      /// ✅ PRINT LOCATION
      print("📍 LOGIN LOCATION:");
      print("Latitude: ${position.latitude}");
      print("Longitude: ${position.longitude}");

      await api.getPostApiResponse(
        "/users/update-location",
        {
          "latitude": position.latitude,
          "longitude": position.longitude,
        },
      );

      print("✅ Location sent after login");
    } catch (e) {
      print("❌ Location error: $e");
    }
  }
}