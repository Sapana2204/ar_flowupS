import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/appUrls.dart';
import '../data/network/network_api_services.dart';

class UserStatusRepository {
  final NetworkApiServices _api = NetworkApiServices();

  Future<bool> signIn() async {
    final payload = await _buildPayload("active");

    debugPrint("=========== SIGN IN API ===========");
    debugPrint("URL: ${AppUrls.userSignIn}");
    debugPrint("Payload: $payload");

    final response = await _api.getPostApiResponse(
      AppUrls.userSignIn,
      payload,
    );

    debugPrint("Response: $response");
    debugPrint("===================================");

    return response != null;
  }

  Future<bool> signOut() async {
    final payload = await _buildPayload("inactive");

    debugPrint("=========== SIGN OUT API ===========");
    debugPrint("URL: ${AppUrls.userSignOut}");
    debugPrint("Payload: $payload");

    final response = await _api.getPostApiResponse(
      AppUrls.userSignOut,
      payload,
    );

    debugPrint("Response: $response");
    debugPrint("====================================");

    return response != null;
  }

  Future<Map<String, dynamic>> _buildPayload(String status) async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String location = "";

    try {
      final place = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (place.isNotEmpty) {
        final p = place.first;
        location = "${p.locality}, ${p.administrativeArea}";
      }
    } catch (e) {
      debugPrint("Location Error: $e");
    }

    final battery = Battery();

    final batteryPercent = await battery.batteryLevel;
    final batteryState = await battery.batteryState;

    final connectivity = await Connectivity().checkConnectivity();

    String networkType = "offline";

    if (connectivity.contains(ConnectivityResult.wifi)) {
      networkType = "wifi";
    } else if (connectivity.contains(ConnectivityResult.mobile)) {
      networkType = Platform.isAndroid ? "4g" : "mobile";
    }

    final payload = {
      "status": status,
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
      "location": location,
      "alive_data": {
        "battery_percent": batteryPercent,
        "network_type": networkType,
        "is_charging": batteryState == BatteryState.charging,
        "last_seen": DateTime.now().toIso8601String(),
      }
    };

    debugPrint("========== USER STATUS PAYLOAD ==========");
    debugPrint("Status        : $status");
    debugPrint("Latitude      : ${position.latitude}");
    debugPrint("Longitude     : ${position.longitude}");
    debugPrint("Location      : $location");
    debugPrint("Battery       : $batteryPercent%");
    debugPrint("Battery State : $batteryState");
    debugPrint("Network       : $networkType");
    debugPrint("Payload       : $payload");
    debugPrint("=========================================");

    return payload;
  }

}