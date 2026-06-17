import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/appUrls.dart';
import '../data/network/network_api_services.dart';
import '../model/notification_model.dart';
import '../utils/login_encryption.dart';

class LoginRepository {
  final NetworkApiServices _api = NetworkApiServices(); // ✅ ADD THIS

  Future<Map<String, dynamic>> loginApi(
      String username,
      String password,
      ) async {

    try {
      print("🚀 LOGIN API START");
      print("👤 Username: $username");

      print("🔑 Starting password encryption...");

      final encryptedPassword =
      await LoginEncryption.encryptPassword(password);

      print("✅ Encryption successful");
      print("🔒 Encrypted Password Length: ${encryptedPassword.length}");

      final uri = Uri.parse(AppUrls.loginEndPoint);

      final requestBody = {
        "username": username,
        "encryptedPassword": encryptedPassword,
        "isMobile": true,
      };

      print("📡 API URL: $uri");
      print("📤 Request Headers: {Content-Type: application/json}");
      print("📤 Request Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message']);
        }
      }

      throw Exception("Server error: ${response.statusCode}");
    } catch (e, stackTrace) {
      print("❌ LOGIN REPOSITORY ERROR");
      print("❌ Error: $e");
      print("❌ StackTrace:");
      print(stackTrace);
      rethrow;
    }
  }


  Future<int> fetchUnreadCount() async {
    try {
      print("🔥 FUNCTION CALLED");

      final response = await _api.getGetApiResponse(
        "${AppUrls.baseUrl}/notifications/unread-count",
      );

      print("📦 Response: $response");

      return response['total'] ?? 0;
    } catch (e) {
      print("❌ Error fetching count: $e");
      return 0;
    }
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await _api.getPostApiResponse(
        "/notifications",
        {"page": 1},
      );

      final list = response['data'] as List;

      return list.map((e) => NotificationModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ Fetch notification error: $e");
      return [];
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final response = await _api.getGetApiResponse(
        "${AppUrls.baseUrl}/notifications/read/$notificationId", // ✅ FULL URL
      );

      print("✅ Mark read response: $response");
    } catch (e) {
      print("❌ Mark read error: $e");
    }
  }



  Future<void> updateUserLocation({
    required double latitude,
    required double longitude,
  }) async {
    final api = NetworkApiServices();

    final data = {
      "latitude": latitude,
      "longitude": longitude,
    };

    try {
      final response = await api.getPostApiResponse(
        "/users/update-location",   // ✅ no full URL needed
        data,
      );

      print("✅ Location updated: $response");
    } catch (e) {
      print("❌ Error updating location: $e");
    }
  }

  /// 🔐 FORGOT PASSWORD - SEND OTP
  Future<void> forgotPasswordApi(String email) async {
    try {
      final response = await _api.getPostApiResponse(
        "/forgotPassword",
        {
          "email": email,
        },
      );

      print("✅ Forgot Password Response: $response");

      if (response['success'] != true) {
        throw Exception(response['message'] ?? "Failed to send OTP");
      }

    } catch (e) {
      print("❌ Forgot Password Error: $e");
      rethrow;
    }
  }

  /// 🔐 VERIFY OTP + RESET PASSWORD
  Future<void> verifyOtpApi({
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _api.getPostApiResponse(
        "/verifyOtp",
        {
          "otp": otp,
          "new_password": newPassword,
          "re_enter_password": confirmPassword,
        },
      );

      print("✅ Verify OTP Response: $response");

      if (response['success'] != true) {
        throw Exception(response['message'] ?? "Reset failed");
      }

    } catch (e) {
      print("❌ Verify OTP Error: $e");
      rethrow;
    }
  }


}