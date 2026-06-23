import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../viewmodel/map_viewmodel.dart';
import '../model/userLocation_model.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  bool showZoomMessage = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<MapViewModel>().fetchMarkers();
    });
  }

  Future<void> _showUserDetails(UserLocationModel user) async {
    String address = "Address not available";

    try {
      final placemarks = await placemarkFromCoordinates(
        user.latitude!,
        user.longitude!,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
          place.country,
        ].where((e) => e != null && e.toString().trim().isNotEmpty).join(", ");
      }
    } catch (_) {}

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🆔 Admin ID: ${user.adminID}"),
              const SizedBox(height: 6),
              Text("📌 Status: ${user.status ?? 'N/A'}"),
              const SizedBox(height: 6),
              Text("📍 Latitude: ${user.latitude}"),
              Text("📍 Longitude: ${user.longitude}"),
              const SizedBox(height: 10),
              const Text(
                "Address:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(address),
              const SizedBox(height: 10),
              const Text(
                "Last Signal:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(user.aliveData?.toString() ?? "N/A"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: primary),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();

    final LatLng initialLocation = vm.users.isNotEmpty
        ? LatLng(vm.users.first.latitude!, vm.users.first.longitude!)
        : LatLng(19.0760, 72.8777);

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Markers"),
        backgroundColor: primary,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await context.read<MapViewModel>().fetchMarkers();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: initialLocation,
                    initialZoom: 14,
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture && showZoomMessage) {
                        setState(() {
                          showZoomMessage = false;
                        });
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.example.my_new_project',
                    ),

                    MarkerLayer(
                      markers: vm.users.map((user) {
                        return Marker(
                          point: LatLng(user.latitude!, user.longitude!),
                          width: 140,
                          height: 95,
                          child: GestureDetector(
                            onTap: () => _showUserDetails(user),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        user.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: (user.status?.toLowerCase() == "active")
                                              ? Colors.green
                                              : Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (showZoomMessage)
            Positioned(
              top: 15,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "🔍 Zoom or tap on user to see users exact locations",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}