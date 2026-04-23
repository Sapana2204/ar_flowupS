import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/login_model.dart';
import '../repository/login_repository.dart';
import '../utils/routes/routes_names.dart';
import '../utils/routes/utils.dart';

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

  int? getCustomerIdFromToken() {
    if (_userData?.token == null) return null;

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(_userData!.token!);

      // Try both possible key cases
      var customerId = decodedToken['CustomerId'] ?? decodedToken['customerId'];

      if (customerId == null) return null;

      // Convert to int if it comes as String
      if (customerId is String) {
        return int.tryParse(customerId);
      } else if (customerId is int) {
        return customerId;
      } else {
        print("⚠ Unexpected type for CustomerId: ${customerId.runtimeType}");
        return null;
      }
    } catch (e) {
      print("Error decoding token: $e");
      return null;
    }
  }


  void setUserData(LoginModel? user) {
    _userData = user;
    notifyListeners();
  }

  Future<void> saveUserData(LoginModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(user.toJson()));
  }

  Future<LoginModel?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('userData');
    if (data != null) {
      return LoginModel.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<void> loginApi(
      String username, String password, BuildContext context) async {
    setLoading(true);
    try {
      final response = await _loginRepository.loginApi(username, password);
      print("Login response: $response");

      final loginModel = LoginModel.fromJson(response);

      if (loginModel.token != null && loginModel.token!.isNotEmpty) {
        setUserData(loginModel);
        await saveUserData(loginModel);

        /// Decode token after saving it
        Map<String, dynamic> decodedToken = JwtDecoder.decode(loginModel.token!);
        print("🔐 Token Decoded: $decodedToken");

        /// Access specific fields (only if your backend provides them)
        print("👤 UserId: ${decodedToken['UserId']}");
        print("👩 Username: ${decodedToken['UserName']}");
        print("🎭 Role: ${decodedToken['RoleName']}");
        print("🎭 CustomerId: ${decodedToken['CustomerId']}");

        /// 🟩 Auto logout when token expires
        Duration expiryDuration = JwtDecoder.getExpirationDate(loginModel.token!)
            .difference(DateTime.now());

        print("⌛ Token valid for: $expiryDuration");

        Future.delayed(expiryDuration, () {
          logout(context);
          Utils.showToast("Session Expired. Please Login Again");
        });

        Utils.showToast("User Login Successfully!");
        Navigator.pushNamed(context, RouteNames.home);
      } else {
        Utils.showToast("Unauthorized User");
      }

    } catch (e) {
      if (e.toString().contains('401')) {
        Utils.showToast("Unauthorized User");
      } else {
        Utils.showToast("Network error: $e");
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    setUserData(null);
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.welcomeScreen,
          (route) => false,
    );
  }

  Future<void> checkUserSession(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('userData');

    if (data != null) {
      final user = LoginModel.fromJson(jsonDecode(data));

      // Validate token
      if (user.token != null && !JwtDecoder.isExpired(user.token!)) {
        setUserData(user);
        Navigator.pushReplacementNamed(context, RouteNames.home);
      } else {
        // Token expired, clear session and redirect to login
        await logout(context);
        Utils.showToast("Session expired. Please log in again.");
      }
    } else {
      // No user data, redirect to login
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }



}
