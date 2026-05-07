class CustomersModel {
  bool? success;
  List<CustomerData>? data;
  Pagination? pagination;

  CustomersModel({this.success, this.data, this.pagination});

  CustomersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    if (json['data'] != null) {
      data = <CustomerData>[];
      json['data'].forEach((v) {
        data!.add(CustomerData.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class CustomerData {
  int? customerId;
  String? name;
  String? contactPerson;
  String? email;
  String? mobileNo;
  String? waNo;
  String? panNumber;
  String? gstNumber;
  String? companyName;
  String? address;
  String? createdBy;
  String? createdDate;
  String? status;

  CustomerData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    name = json['name']?.toString();
    contactPerson = json['contact_person']?.toString();
    email = json['email']?.toString();
    mobileNo = json['mobile_no']?.toString();
    waNo = json['wa_no']?.toString();
    panNumber = json['pan_number']?.toString();
    gstNumber = json['gst_number']?.toString();
    companyName = json['company_name']?.toString();
    address = json['address']?.toString();
    createdBy = json['created_by']?.toString();     // 🔥 FIX
    createdDate = json['created_date']?.toString();
    status = json['status']?.toString();
  }
}

class Pagination {
  int? totalPages;

  Pagination.fromJson(Map<String, dynamic> json) {
    totalPages = json['totalPages'];
  }
}