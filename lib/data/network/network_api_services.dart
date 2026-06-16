import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_new_project/data/network/socket_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/api_headers.dart';
import '../../constants/appUrls.dart';
import '../../constants/app_messages.dart';
import '../../model/apiResponseMessage_model.dart';
import '../../model/login_model.dart';
import '../../utils/routes/routes_names.dart';
import '../app_exceptions.dart';
import 'base_api_services.dart';
import 'navigation_service.dart';

class NetworkApiServices extends BaseApiServices {
  @override

  Future<dynamic> getGetApiResponse(String url, {String? token}) async {
    dynamic jsonResponse;

    try {
      token = await _getValidToken(token);

      final response = await http.get(
        Uri.parse(url),
        headers: ApiHeaders.headers(token: token),      ).timeout(const Duration(seconds: 10));

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

      final headers = ApiHeaders.headers(token: token);
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
    final prefs = await SharedPreferences.getInstance();

    if (token == null || token.isEmpty) {
      final userDataString = prefs.getString("userData");

      if (userDataString != null) {
        final loginModel =
        LoginModel.fromJson(jsonDecode(userDataString));
        token = loginModel.token ?? "";
      }
    }

    /// ❌ No token → DO NOT logout
    if (token == null || token.isEmpty || token == "null") {
      return null;
    }

    /// ❌ Invalid format → logout
    try {
      JwtDecoder.decode(token);
    } catch (e) {
      await _forceLogout();
      throw UnauthorizedException("Invalid token");
    }

    /// ❌ Expired → logout
    if (JwtDecoder.isExpired(token)) {
      print("❌ Token expired");
      await _forceLogout();
      throw UnauthorizedException("Token expired");
    }

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
      request.headers.addAll(
        ApiHeaders.multipartHeaders(token: token),
      );

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
        headers: ApiHeaders.headers(token: token),      );

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



  dynamic handleResponse(http.Response response) async {
    dynamic data;

    try {
      data = jsonDecode(response.body);
    } catch (_) {
      data = null;
    }

    final message = data != null
        ? ApiResponseMessage.fromResponse(data)
        : "Something went wrong";

    switch (response.statusCode) {
      case 200:
      case 201:
        return data;

      case 400:
        throw BadRequestException(message);

      case 401:
        await _forceLogout();
        throw UnauthorizedException(message);

      case 404:
        throw Exception(message);

      default:
        throw Exception(message);
    }
  }

  Future<dynamic> getPutApiResponse(String url, dynamic data, {String? token}) async {
    try {
      token = await _getValidToken(token);

      String completeUrl = url.startsWith("http") ? url : AppUrls.baseUrl + url;

      final headers = ApiHeaders.headers(token: token);
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

  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _forceLogout() async {
    print("🚨 FORCE LOGOUT CALLED");
    print(StackTrace.current);

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("userData");

    SocketService().disconnect();

    NavigationService.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(
      RouteNames.login,
          (route) => false,
    );
  }


}
