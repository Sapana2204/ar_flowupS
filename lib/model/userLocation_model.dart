class UserLocationModel {
  final int adminID;
  final double? latitude;
  final double? longitude;
  final String name;
  final dynamic aliveData;
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
      aliveData: json['alive_data'],
      status: json['status']?.toString(),
    );
  }
}