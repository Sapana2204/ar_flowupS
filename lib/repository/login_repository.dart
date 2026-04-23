import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/appUrls.dart';

class LoginRepository {
  Future<dynamic> loginApi(String userName, String password) async {
    final uri = Uri.parse(
      "${AppUrls.baseUrl}${AppUrls.loginEndPoint}?userName=$userName&password=$password",
    );

    try {
      print("Calling API at: $uri");

      final response = await http.post(
        uri,
        headers: {
          "accept": "text/plain",
        },
        body: "", // API requires empty body
      );

      if (response.statusCode == 200) {
        print("API Success: ${response.body}");

        // Return as map for compatibility with LoginModel
        return {
          "message": response.body.trim(), // ⬅ removes hidden newlines
        };
      } else {
        print("API Error - Status: ${response.statusCode}");
        print("API Error - Body: ${response.body}");
        throw Exception("Failed with status code ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("Network error: $e");
      throw Exception("API error: $e");
    }
  }
}
