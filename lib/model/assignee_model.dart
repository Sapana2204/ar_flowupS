class AssigneeModel {
  final int adminId;
  final String name;
  final String? email;
  final int? roleId;
  final String? status;
  final String? companyId;

  AssigneeModel({
    required this.adminId,
    required this.name,
    this.email,
    this.roleId,
    this.status,
    this.companyId,
  });

  factory AssigneeModel.fromJson(Map<String, dynamic> json) {
    return AssigneeModel(
      adminId: json["adminID"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"],
      roleId: json["roleID"],
      status: json["status"],
      companyId: json["company_id"]?.toString(),
    );
  }
}