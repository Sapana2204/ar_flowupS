import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../utils/app_colors.dart';
import '../viewmodel/map_viewmodel.dart';
import 'package:geocoding/geocoding.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();

  bool showZoomMessage = true;


  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<MapViewModel>().fetchMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Markers"),
        backgroundColor: primary,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
            children:[ RefreshIndicator(
                    onRefresh: () async {
            await context.read<MapViewModel>().fetchMarkers();
                    },
                    child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: vm.users.isNotEmpty
                      ? LatLng(
                    vm.users.first.latitude!,
                    vm.users.first.longitude!,
                  )
                      : LatLng(19.0760, 72.8777),
                  initialZoom: 6,
    onPositionChanged: (position, hasGesture) {
      if (hasGesture && showZoomMessage) {
        setState(() {
          showZoomMessage = false;
        });
      }
    }
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
                        width: 120,
                        height: 90,
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                user.latitude!,
                                user.longitude!,
                              );
            
                              final place = placemarks.first;
            
                              String address =
                                  "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
            
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(user.name),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("📍 Latitude: ${user.latitude}"),
                                      Text("📍 Longitude: ${user.longitude}"),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Address:",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(address),
                                    ],
                                  ),
                                ),
                              );
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(user.name),
                                  content: Text(
                                    "Latitude: ${user.latitude}\n"
                                        "Longitude: ${user.longitude}\n\n"
                                        "Address not available",
                                  ),
                                ),
                              );
                            }
                          },
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
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  user.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
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
              /// ZOOM MESSAGE
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
                      "🔍 Zoom or move map to see users locations",
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
      ),    );
  }
}