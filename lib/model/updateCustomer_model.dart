class UpdateCustomer {
  int? customerId;
  String? name;
  String? contactPerson;
  String? mobileNo;
  String? waNo;
  String? email;
  String? panNumber;
  String? gstNumber;
  String? address;

  String? isAmc;
  String? amcTermPeriod;
  String? amcStartDate;
  String? amcEndDate;
  String? status;

  int? responsiblePerson;
  String? expCallCount;

  List<Map<String, dynamic>>? customerProducts;
  List<String>? productIds;
  List<Map<String, dynamic>>? products;

  UpdateCustomer({
    this.customerId,
    this.name,
    this.contactPerson,
    this.mobileNo,
    this.waNo,
    this.email,
    this.panNumber,
    this.gstNumber,
    this.address,
    this.isAmc,
    this.amcTermPeriod,
    this.amcStartDate,
    this.amcEndDate,
    this.status,
    this.responsiblePerson,
    this.expCallCount,
    this.customerProducts,
    this.productIds,
    this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      "customer_id": customerId,
      "name": name,
      "email": email,
      "mobile_no": mobileNo,
      "wa_no": waNo ?? "",
      "pan_number": panNumber,
      "gst_number": gstNumber,
      "address": address,
      "contact_person": contactPerson,

      "is_amc": isAmc,
      "amc_term_period": amcTermPeriod,
      "amc_start_date": amcStartDate,
      "amc_end_date": amcEndDate,

      "responsible_person": responsiblePerson,
      "exp_call_count": expCallCount,

      "status": status,

      "customer_products": customerProducts ?? [],
      "product_ids": productIds ?? [],
      "products": products ?? [],
    };
  }
}