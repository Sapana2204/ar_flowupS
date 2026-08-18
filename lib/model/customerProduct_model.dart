class CustomerProductModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<ProductData>? data;

  CustomerProductModel(
      {this.success, this.code, this.type, this.message, this.data});

  CustomerProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(new ProductData.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['success'] = this.success;
  //   data['code'] = this.code;
  //   data['type'] = this.type;
  //   data['message'] = this.message;
  //   if (this.data != null) {
  //     data['data'] = this.data!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class ProductData {
  int? productId;
  String? productName;
  double? rate;
  double? gstRate;

  ProductData({
    this.productId,
    this.productName,
    this.rate,
    this.gstRate,
  });

  ProductData.fromJson(Map<String, dynamic> json) {
    productId = int.tryParse(
      json['product_id']?.toString() ?? '',
    );

    productName = json['product_name']?.toString();

    rate = double.tryParse(
      json['rate']?.toString() ?? '',
    );

    gstRate = double.tryParse(
      json['gst_rate']?.toString() ?? '',
    );
  }
}
