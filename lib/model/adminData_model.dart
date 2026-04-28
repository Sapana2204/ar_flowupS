class AdminData {
  int? adminID;
  String? name;

  AdminData.fromJson(Map<String, dynamic> json) {
    adminID = json['adminID'];
    name = json['name'];
  }
}