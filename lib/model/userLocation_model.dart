class UserLocationModel {
  final double? latitude;
  final double? longitude;
  final String name;

  UserLocationModel({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      name: json['name'] ?? '',
    );
  }
}