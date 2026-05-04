import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/appUrls.dart';
import '../data/network/network_api_services.dart';
import '../model/notification_model.dart';

class LoginRepository {
  final NetworkApiServices _api = NetworkApiServices(); // ✅ ADD THIS

  Future<Map<String, dynamic>> loginApi(
      String username, String password) async {

    final uri = Uri.parse(AppUrls.loginEndPoint); // ✅ UPDATED

    final requestBody = {
      "username": username,
      "password": password,
    };

    try {
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? "Login failed");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API Error: $e");
      throw Exception("Network/API error: $e");
    }
  }


  Future<int> fetchUnreadCount() async {
    try {
      final response = await http.get(Uri.parse(AppUrls.unreadCount));

      final data = jsonDecode(response.body);

      return data['total'] ?? 0;
    } catch (e) {
      print("❌ Error fetching count: $e");
      return 0;
    }
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await _api.getPostApiResponse(
        "/notifications",   // ✅ IMPORTANT (no /api/v1 because baseUrl already has it)
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
        "/notifications/read/$notificationId", // ✅ NO /api/v1
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


}