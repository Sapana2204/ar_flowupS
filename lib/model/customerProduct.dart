class CustomerProduct {
  String? productId;
  String? productName;
  String? serialNumber;

  CustomerProduct({
    this.productId,
    this.productName,
    this.serialNumber,
  });

  CustomerProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toString();
    productName = json['product_name']?.toString();
    serialNumber = json['serial_number']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "product_name": productName,
      "serial_number": serialNumber,
    };
  }
}