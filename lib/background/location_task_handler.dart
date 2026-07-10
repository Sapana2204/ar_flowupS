import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';

import '../data/network/network_api_services.dart';
import '../services/alive_data_service.dart';

StreamSubscription<Position>? _subscription;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  const settings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 50,
  );

  _subscription = Geolocator.getPositionStream(
    locationSettings: settings,
  ).listen((Position position) async {

    try {

      final aliveData =
      await AliveDataService.getAliveData();

      print("📍 Background Location");
      print(position.latitude);
      print(position.longitude);

      await NetworkApiServices().getPostApiResponse(
        "/users/update-location",
        {
          "latitude": position.latitude,
          "longitude": position.longitude,
          "alive_data": aliveData,
        },
      );

    } catch (e) {
      print("Background Location Error : $e");
    }

  });

  service.on("stopService").listen((event) async {

    await _subscription?.cancel();

    service.stopSelf();

  });

}