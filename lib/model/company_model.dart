class CompanyModel {
  final int companyId;
  final String companyName;

  CompanyModel({
    required this.companyId,
    required this.companyName,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyId: json["company_id"] ?? 0,
      companyName: json["company_name"] ?? "",
    );
  }
}