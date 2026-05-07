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
    };
  }
}