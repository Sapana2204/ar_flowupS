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

  /// 🔄 LOADING FOR FORGOT FLOW
  bool _isForgotLoading = false;
  bool get isForgotLoading => _isForgotLoading;

  void setForgotLoading(bool value) {
    _isForgotLoading = value;
    notifyListeners();
  }

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

    await prefs.setString(
      'userData',
      jsonEncode(user.toJson()),
    );

    print("✅ SAVED KEYS: ${prefs.getKeys()}");
    print("✅ SAVED USERDATA: ${prefs.getString('userData')}");
  }

  /// ✅ LOGIN API
  Future<void> loginApi(
      String username,
      String password,
      BuildContext context,
      ) async {

    setLoading(true);

    try {
      final response = await _loginRepository.loginApi(
        username,
        password,
      );

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
      print("error is: $e");

      Utils.showToast(e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// ✅ Logout
  Future<void> logout(BuildContext context) async {
    try {
      await NetworkApiServices().getPostApiResponse(
        "/users/status",
        {
          "status": "inactive",
        },
      );
    } catch (e) {
      debugPrint("Status update failed: $e");
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userData");

    _userData = null;

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

    print("📦 STORED DATA: $data");

    if (data == null) {
      Navigator.pushReplacementNamed(
        context,
        RouteNames.login,
      );
      return;
    }

    final user = LoginModel.fromJson(
      jsonDecode(data),
    );

    if (user.token == null ||
        JwtDecoder.isExpired(user.token!)) {

      await prefs.remove('userData');

      Navigator.pushReplacementNamed(
        context,
        RouteNames.login,
      );

      Utils.showToast(
        "Session expired. Please login again.",
      );
      return;
    }

    /// Restore logged in user
    setUserData(user);
    SocketService().connect(
      user.adminId.toString(),
    );

    print("✅ RESTORING SESSION");
    print("👤 AdminID: ${user.adminId}");
    print("👤 Username: ${user.username}");

    /// Reconnect socket after app restart
    SocketService().connect(
      user.adminId.toString(),
    );

    /// Auto logout when token expires
    final expiry = JwtDecoder.getExpirationDate(
      user.token!,
    );

    final duration = expiry.difference(
      DateTime.now(),
    );

    Future.delayed(duration, () {
      logout(context);
      Utils.showToast("Session expired");
    });

    Navigator.pushReplacementNamed(
      context,
      RouteNames.home,
    );
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

  Future<void> forgotPassword(
      String email,
      BuildContext context,
      ) async {

    setForgotLoading(true);

    try {
      await _loginRepository.forgotPasswordApi(email);

      Utils.showToast("OTP sent to your email");

      Navigator.pushNamed(
        context,
        RouteNames.resetPasswordScreen,
        arguments: email,
      );

    } catch (e) {
      Utils.showToast(e.toString());
    } finally {
      setForgotLoading(false);
    }
  }

  Future<void> verifyOtp(
      String otp,
      String newPassword,
      String confirmPassword,
      BuildContext context,
      ) async {

    setForgotLoading(true);

    try {
      await _loginRepository.verifyOtpApi(
        otp: otp,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      Utils.showToast("Password reset successful");

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.login,
            (route) => false,
      );

    } catch (e) {
      Utils.showToast(e.toString());
    } finally {
      setForgotLoading(false);
    }
  }
}