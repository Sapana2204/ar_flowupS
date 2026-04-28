import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/appUrls.dart';

class LoginRepository {
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
}