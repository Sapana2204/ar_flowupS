class CreateCustomer {
  String? name;
  String? contactPerson;
  String? mobileNo;
  String? waNo;
  String? email;
  String? panNumber;
  String? gstNo;
  String? address;

  String? isAmc;
  String? amcTermPeriod;
  String? amcStartDate;
  String? amcEndDate;

  List<Map<String, dynamic>>? customerProducts;

  CreateCustomer({
    this.name,
    this.contactPerson,
    this.mobileNo,
    this.waNo,
    this.email,
    this.panNumber,
    this.gstNo,
    this.address,
    this.isAmc,
    this.amcTermPeriod,
    this.amcStartDate,
    this.amcEndDate,
    this.customerProducts,
  });

  Map<String, dynamic> toJson() {
    return {
      "customer_id": null,
      "name": name,
      "email": email,
      "mobile_no": mobileNo,
      "wa_no": waNo,
      "pan_number": panNumber,
      "gst_no": gstNo,
      "address": address,
      "contact_person": contactPerson,

      "is_amc": isAmc,
      "amc_term_period": amcTermPeriod,
      "amc_start_date": amcStartDate,
      "amc_end_date": amcEndDate,

      "customer_products": customerProducts ?? [],
    };
  }
}