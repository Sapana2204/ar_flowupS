import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_new_project/viewmodel/userStatus_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ringer_mode/ringer_mode.dart';

import '../data/network/network_api_services.dart';
import '../data/network/socket_service.dart';
import '../model/login_model.dart';
import '../repository/login_repository.dart';
import '../services/alive_data_service.dart';
import '../services/background_location_service.dart';
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

  bool _readAllLoading = false;
  bool get readAllLoading => _readAllLoading;

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
  Future<bool> loginApi(
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

        SocketService().connect(loginModel.adminId.toString());

        final expiry = JwtDecoder.getExpirationDate(loginModel.token!);
        final duration = expiry.difference(DateTime.now());

        Future.delayed(duration, () {
          logout(context);
          Utils.showToast("Session expired. Please login again.");
        });

        Utils.showToast("Login Successful!");

        await _sendLocationToServer();
        await updateAttendanceStatus(
          context,
          true,
        );

        await BackgroundLocationService.start();

        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.home,
              (route) => false,
        );

        return true; // ✅ Login successful
      } else {
        Utils.showToast("Invalid login response");
        return false;
      }
    } catch (e) {
      print("error is: $e");

      Utils.showToast(
        e.toString().replaceFirst("Exception: ", "").trim(),
      );

      return false; // ❌ Login failed
    } finally {
      setLoading(false);
    }
  }
  /// ✅ Logout
  Future<void> logout(BuildContext context) async {
    try {
      await updateAttendanceStatus(
        context,
        false,
      );
    } catch (e) {
      debugPrint("Status update failed: $e");
    }

    // ✅ Stop background service
    await BackgroundLocationService.stop();

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
      await BackgroundLocationService.stop();

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

      await BackgroundLocationService.stop();

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

    SocketService().connect(user.adminId.toString());


    final signed =
        prefs.getBool("attendance_signed_in") ?? false;

    if (!signed) {
      await updateAttendanceStatus(
        context,
        true,
      );
    }
    await BackgroundLocationService.start();

    print("✅ RESTORING SESSION");
    print("👤 AdminID: ${user.adminId}");
    print("👤 Username: ${user.username}");

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

      final aliveData = await AliveDataService.getAliveData();

      print("📍 LOGIN LOCATION:");
      print("Latitude: ${position.latitude}");
      print("Longitude: ${position.longitude}");
      print("📱 Alive Data: $aliveData");

      await _loginRepository.updateUserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        aliveData: aliveData,
      );

      print("✅ Location + alive_data sent after login");
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
      Utils.showToast(
        e.toString().replaceFirst("Exception: ", "").trim(),
      );
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
      Utils.showToast(
        e.toString().replaceFirst("Exception: ", "").trim(),
      );
    } finally {
      setForgotLoading(false);
    }
  }


  Future<bool> readAllNotifications() async {
    try {
      _readAllLoading = true;
      notifyListeners();

      return await _loginRepository.readAllNotifications();
    } finally {
      _readAllLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAttendanceStatus(
      BuildContext context,
      bool active,
      ) async {
    try {
      final vm = UserStatusViewModel();

      if (active) {
        await vm.signIn();
      } else {
        await vm.signOut();
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(
        "attendance_signed_in",
        active,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}