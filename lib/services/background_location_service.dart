import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../background/location_task_handler.dart';

class BackgroundLocationService {
  static final FlutterBackgroundService _service =
  FlutterBackgroundService();

  static const String notificationChannelId = "flowups_location_channel";

  static Future<void> initialize() async {
    final notificationPlugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId,
      "Location Tracking",
      description: "Tracks employee location in background",
      importance: Importance.low,
    );

    await notificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        autoStartOnBoot: true,
        foregroundServiceNotificationId: 1001,
        initialNotificationTitle: "flowupS",
        initialNotificationContent: "Running",
        foregroundServiceTypes: [
          AndroidForegroundType.location,
        ],
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  static Future<void> start() async {
    bool running = await _service.isRunning();

    if (!running) {
      await _service.startService();
    }
  }

  static Future<void> stop() async {
    _service.invoke("stopService");
  }

  static Future<bool> isRunning() async {
    return await _service.isRunning();
  }
}