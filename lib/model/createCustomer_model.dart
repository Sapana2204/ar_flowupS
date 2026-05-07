class CreateCustomer {
  String? name;
  String? contactPerson;
  String? mobileNo;
  String? waNo;
  String? email;
  String? panNumber;
  String? gstNo;
  String? address;

  CreateCustomer({
    this.name,
    this.contactPerson,
    this.mobileNo,
    this.waNo,
    this.email,
    this.panNumber,
    this.gstNo,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "customer_id": null,
      "name": name,
      "email": email,
      "mobile_no": mobileNo,
      "wa_no": waNo,
      "pan_number": panNumber,
      "gst_no": gstNo, // 👈 IMPORTANT
      "address": address,
      "contact_person": contactPerson,
    };
  }
}