import 'package:flutter/cupertino.dart';

import '../constants/appUrls.dart';
import '../data/network/network_api_services.dart';
import '../model/userLocation_model.dart';

class MapViewModel extends ChangeNotifier {
  final _api = NetworkApiServices();

  List<UserLocationModel> users = [];
  bool isLoading = false;

  Future<void> fetchMarkers() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _api.getGetApiResponse(
        "${AppUrls.baseUrl}/users/get-markers",
      );

      final List data = response['data'];

      users = data
          .map((e) => UserLocationModel.fromJson(e))
          .where((e) => e.latitude != null && e.longitude != null) // ✅ filter nulls
          .toList();
    } catch (e) {
      print("❌ Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}