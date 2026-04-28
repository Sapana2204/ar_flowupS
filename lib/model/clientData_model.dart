class ClientData {
  int? customerId;
  String? name;
  String? createdDate;
  String? mobileNo;

  ClientData({
    this.customerId,
    this.name,
    this.createdDate,
    this.mobileNo,
  });

  ClientData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    name = json['name'];
    createdDate = json['created_date'];
    mobileNo = json['mobile_no'];
  }
}