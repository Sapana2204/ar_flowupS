import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginRepository {
  Future<Map<String, dynamic>> loginApi(
      String username, String password) async {

    final uri = Uri.parse("http://192.168.1.3:3000/api/v1/login");

    final requestBody = {
      "username": username,
      "password": password,
    };

    try {
      print("📡 API URL: $uri");
      print("📤 Request Headers: {Content-Type: application/json}");
      print("📤 Request Body: ${jsonEncode(requestBody)}"); // ✅ ADD THIS

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