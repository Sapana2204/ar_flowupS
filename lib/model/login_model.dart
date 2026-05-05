import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginModel {
  bool? success;
  int? code;
  String? message;
  String? token;
  String? roleSlug;

  int? adminId;
  String? username;
  int? roleId;

  // Optional: from user object
  String? name;

  LoginModel({
    this.success,
    this.code,
    this.message,
    this.token,
    this.adminId,
    this.username,
    this.roleId,
    this.name,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    token = json['token'];
    roleSlug = json['user']?['role_slug'];

    // ✅ Parse user object
    if (json['user'] != null) {
      adminId = json['user']['adminID'];
      username = json['user']['userName'];
      roleId = json['user']['roleID'];
      name = json['user']['name'];
    }

    // ✅ Optional: Decode JWT (if needed)
    if (token != null && token!.isNotEmpty) {
      final decoded = JwtDecoder.decode(token!);
      debugPrint("🧾 Decoded Token: $decoded");

      // You can override or double-check values from token
      adminId = decoded['adminID'] ?? adminId;
      username = decoded['username'] ?? username;
      roleId = decoded['roleID'] ?? roleId;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "code": code,
      "message": message,
      "token": token,
      "user": {
        "adminID": adminId,
        "userName": username,
        "roleID": roleId,
        "name": name,
      }
    };
  }

  /// ✅ Check if token is expired
  bool get isTokenExpired {
    if (token == null) return true;
    return JwtDecoder.isExpired(token!);
  }
}