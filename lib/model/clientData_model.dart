import 'customerProduct.dart';

class ClientData {
  int? customerId;
  String? name;
  String? createdDate;
  String? mobileNo;

  List<CustomerProduct>? customerProducts;

  ClientData({
    this.customerId,
    this.name,
    this.createdDate,
    this.mobileNo,
    this.customerProducts,
  });

  ClientData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    name = json['name'];
    createdDate = json['created_date'];
    mobileNo = json['mobile_no'];

    if (json['customer_products'] != null) {
      customerProducts = [];

      json['customer_products'].forEach((v) {
        customerProducts!.add(
          CustomerProduct.fromJson(v),
        );
      });
    }
  }
}