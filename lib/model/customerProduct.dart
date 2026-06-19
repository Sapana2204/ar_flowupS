class CustomerProduct {
  String? productId;
  String? productName;
  String? serialNumber;
  String? expiryDate;
  List<String>? addOns;

  CustomerProduct({
    this.productId,
    this.productName,
    this.serialNumber,
    this.expiryDate,
    this.addOns,
  });

  CustomerProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toString();
    productName = json['product_name']?.toString();
    serialNumber = json['serial_number']?.toString();
    expiryDate = json['expiry_date']?.toString();

    addOns = json['add_ons'] == null
        ? []
        : List<String>.from(json['add_ons']);
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "product_name": productName,
      "serial_number": serialNumber,
      "add_ons": addOns ?? [],
    };
  }
}