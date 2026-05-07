class UpdateCustomer {
  int? customerId;
  String? name;
  String? email;
  String? mobileNo;
  String? waNo;
  String? address;
  String? panNumber;
  String? companyName;
  String? contactPerson;

  Map<String, dynamic> toJson() {
    return {
      "customer_id": customerId,
      "name": name,
      "email": email,
      "mobile_no": mobileNo,
      "wa_no": waNo,
      "address": address,
      "pan_number": panNumber,
      "company_name": companyName,
      "contact_person": contactPerson,
    };
  }
}