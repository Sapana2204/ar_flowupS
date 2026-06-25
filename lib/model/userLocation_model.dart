class AliveDataModel {
  final String? carrier;
  final String? timestamp;
  final String? ringerMode;
  final String? networkType;
  final int? batteryPercent;
  final String? signalStrength;
  final String? mobileNetworkGeneration;

  AliveDataModel({
    this.carrier,
    this.timestamp,
    this.ringerMode,
    this.networkType,
    this.batteryPercent,
    this.signalStrength,
    this.mobileNetworkGeneration,
  });

  factory AliveDataModel.fromJson(Map<String, dynamic> json) {
    return AliveDataModel(
      carrier: json['carrier']?.toString(),
      timestamp: json['timestamp']?.toString(),
      ringerMode: json['ringer_mode']?.toString(),
      networkType: json['network_type']?.toString(),
      batteryPercent: json['battery_percent'] is int
          ? json['battery_percent']
          : int.tryParse(json['battery_percent']?.toString() ?? ''),
      signalStrength: json['signal_strength']?.toString(),
      mobileNetworkGeneration:
      json['mobile_network_generation']?.toString(),
    );
  }
}

class UserLocationModel {
  final int adminID;
  final double? latitude;
  final double? longitude;
  final String name;
  final AliveDataModel? aliveData;
  final String? status;

  UserLocationModel({
    required this.adminID,
    required this.latitude,
    required this.longitude,
    required this.name,
    this.aliveData,
    this.status,
  });

  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      adminID: json['adminID'] ?? 0,
      latitude: double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: double.tryParse(json['longitude']?.toString() ?? ''),
      name: json['name'] ?? '',
      aliveData: json['alive_data'] != null
          ? AliveDataModel.fromJson(json['alive_data'])
          : null,
      status: json['status']?.toString(),
    );
  }
}