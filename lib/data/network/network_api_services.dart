import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/appUrls.dart';
import '../../model/login_model.dart';
import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getGetApiResponse(String url, {String? token}) async {
    dynamic jsonResponse;

    try {
      token = await _getValidToken(token);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          if (token != null && token.isNotEmpty)
            "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 10));

      print("📤 GET API: $url");
      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      jsonResponse = handleResponse(response);
    } on SocketException {
      throw InternetException("No internet is available right now");
    }

    return jsonResponse;
  }

  @override
  Future<dynamic> getPostApiResponse(String url, dynamic data, {String? token}) async {
    try {
      token = await _getValidToken(token);

      String completeUrl = url.startsWith("http") ? url : AppUrls.baseUrl + url;

      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final response = await http.post(
        Uri.parse(completeUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      print("📤 POST API: $completeUrl");
      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      return handleResponse(response);
    } on SocketException {
      throw Exception("No Internet connection");
    } catch (e) {
      throw Exception("API error: $e");
    }
  }

  Future<String?> _getValidToken(String? token) async {
    if (token == null || token.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString("userData");

      if (userDataString != null) {
        final loginModel = LoginModel.fromJson(jsonDecode(userDataString));
        token = loginModel.token ?? "";

        if (token.isNotEmpty) {
          if (JwtDecoder.isExpired(token)) {
            print("❌ Token expired.");
            throw UnauthorizedException("Token expired");
          } else {
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
            // print("🧾 Decoded Token: $decodedToken");
            // print("👤 UserId: ${decodedToken['UserId']}");
            // print("👩 Username: ${decodedToken['UserName']}");
            // print("👮 Role: ${decodedToken['RoleName']}");
          }
        }
      }
    }

    return token;
  }

  dynamic handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException("Bad Request");
      case 401:
        throw UnauthorizedException("Unauthorized. Please log in again.");
      case 404:
        throw response.body;
        default:
        throw InternetException(
          "${response.statusCode} : ${response.reasonPhrase}",
        );
    }
  }
}
