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
    name = json['name'];
    contactPerson = json['contact_person'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    waNo = json['wa_no'];
    panNumber = json['pan_number'];
    gstNumber = json['gst_number'];
    companyName = json['company_name'];
    address = json['address'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    status = json['status'];
  }
}

class Pagination {
  int? totalPages;

  Pagination.fromJson(Map<String, dynamic> json) {
    totalPages = json['totalPages'];
  }
}