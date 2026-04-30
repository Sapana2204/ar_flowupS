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
        'Accept': 'application/json, text/plain, */*',
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
      print("Header: ${response.headers}");

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
      }
    }

    // ❌ No token
    if (token == null || token.isEmpty || token == "null") {
      throw UnauthorizedException("Token missing");
    }

    try {
      // ❌ Invalid token format
      JwtDecoder.decode(token);
    } catch (e) {
      throw UnauthorizedException("Invalid token format");
    }

    // ❌ Expired token
    if (JwtDecoder.isExpired(token)) {
      print("❌ Token expired.");
      throw UnauthorizedException("Token expired");
    }

    // ✅ Token valid
    print("🔑 Token: $token");

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    print("🧾 Decoded Token: $decodedToken");
    print("👤 UserId: ${decodedToken['UserId']}");
    print("👩 Username: ${decodedToken['UserName']}");
    print("👮 Role: ${decodedToken['RoleName']}");

    return token;
  }


  Future<dynamic> uploadMultipartApiResponse({
    required String url,
    required Map<String, String> fields,
    String? filePath,                // ✅ single file instead of List
    String fileKey = "File",         // ✅ match backend exactly
    String? token,
  }) async {
    try {
      token = await _getValidToken(token);

      String completeUrl =
      url.startsWith("http") ? url : AppUrls.baseUrl + url;
      var request = http.MultipartRequest('POST', Uri.parse(completeUrl));

      // Add headers
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields.addAll(fields);

      if (filePath != null && filePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(fileKey, filePath));
      }

      print("📤 Multipart Upload API: $completeUrl");
      print("Fields: $fields");
      print("File: $filePath");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      return handleResponse(response);
    } on SocketException {
      throw InternetException("No internet is available right now");
    } catch (e) {
      throw Exception("Upload failed: $e");
    }
  }


  Future<dynamic> getDeleteApiResponse(String url, {String? token}) async {
    try {
      token = await _getValidToken(token);

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          if (token != null && token.isNotEmpty)
            "Authorization": "Bearer $token",
        },
      );

      print("📤 DELETE API: $url");
      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      return handleResponse(response);
    } on SocketException {
      throw InternetException("No internet is available right now");
    } catch (e) {
      throw Exception("API error: $e");
    }
  }


  dynamic handleResponse(http.Response response) {
    switch (response.statusCode) {

      case 200:
      case 201:
        final body = response.body.trim();
        try {
          return jsonDecode(body);
        } catch (_) {
          return body;
        }

      case 400:
        throw BadRequestException("Bad Request");

      case 401:
        throw UnauthorizedException("Unauthorized. Please log in again.");

      case 404:
        throw response;

      default:
        throw InternetException(
          "${response.statusCode} : ${response.reasonPhrase}",
        );
    }
  }

  Future<dynamic> getPutApiResponse(String url, dynamic data, {String? token}) async {
    try {
      token = await _getValidToken(token);

      String completeUrl = url.startsWith("http") ? url : AppUrls.baseUrl + url;

      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json, text/plain, */*",
        if (token != null && token.isNotEmpty)
          "Authorization": "Bearer $token",
      };

      final response = await http.put(
        Uri.parse(completeUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      print("📤 PUT API: $completeUrl");
      print("📥 Request body: ${jsonEncode(data)}");
      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      return handleResponse(response);
    } on SocketException {
      throw InternetException("No internet is available right now");
    } catch (e) {
      throw Exception("API error: $e");
    }
  }

}
