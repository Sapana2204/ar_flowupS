import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:ringer_mode/ringer_mode.dart';

class AliveDataService {
  static const MethodChannel _telephonyChannel =
  MethodChannel('com.example.my_new_project/telephony');

  static Future<Map<String, dynamic>> getAliveData() async {
    try {
      final battery = Battery();
      final batteryPercent = await battery.batteryLevel;

      String ringerMode = "unknown";

      try {
        final mode = await RingerModeService.getRingerMode();

        switch (mode) {
          case RingerMode.normal:
            ringerMode = "normal";
            break;
          case RingerMode.silent:
            ringerMode = "silent";
            break;
          case RingerMode.vibrate:
            ringerMode = "vibrate";
            break;
        }
      } catch (_) {}

      String networkType = "offline";

      final connectivity = await Connectivity().checkConnectivity();

      if (connectivity.contains(ConnectivityResult.mobile)) {
        networkType = "mobile";
      }

      if (connectivity.contains(ConnectivityResult.wifi)) {
        networkType = "wifi";
      }

      Map telephony = {};

      try {
        telephony =
        await _telephonyChannel.invokeMethod("getTelephonyData");
      } catch (_) {}

      return {
        "battery_percent": batteryPercent,
        "ringer_mode": ringerMode,
        "network_type": networkType,
        "mobile_network_generation":
        telephony["mobile_network_generation"] ?? "unknown",
        "carrier": telephony["carrier"] ?? "unknown",
        "signal_strength": telephony["signal_strength"] ?? "unknown",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "battery_percent": 0,
        "ringer_mode": "unknown",
        "network_type": "unknown",
        "mobile_network_generation": "unknown",
        "carrier": "unknown",
        "signal_strength": "unknown",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }
}