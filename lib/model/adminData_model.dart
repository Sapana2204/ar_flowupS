class AdminData {
  int? adminID;
  int? pendingTicketsCount;
  String? name;

  AdminData.fromJson(Map<String, dynamic> json) {
    adminID = json['adminID'];
    pendingTicketsCount = json['pending_tickets_count'];
    name = json['name'];
  }
}