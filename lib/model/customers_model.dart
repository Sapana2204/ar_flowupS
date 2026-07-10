import 'customerContact_model.dart';
import 'customerProduct.dart';

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

  /// AMC
  String? isAmc;
  String? amcTermPeriod;
  String? amcStartDate;
  String? amcEndDate;
  String? responsiblePerson;
  int? expCallCount;

  /// Products
  List<CustomerProduct>? customerProducts;

  List<CustomerContact>? customerContacts;
  List<CustomerContact>? contactPersons;

  CustomerData({
    this.customerId,
    this.name,
    this.contactPerson,
    this.email,
    this.mobileNo,
    this.waNo,
    this.panNumber,
    this.gstNumber,
    this.companyName,
    this.address,
    this.createdBy,
    this.createdDate,
    this.status,
    this.isAmc,
    this.amcTermPeriod,
    this.amcStartDate,
    this.amcEndDate,
    this.customerProducts,
    this.responsiblePerson,
    this.expCallCount,
    this.customerContacts,
    this.contactPersons,
  });

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
    createdBy = json['created_by']?.toString();
    createdDate = json['created_date']?.toString();
    status = json['status']?.toString();

    /// AMC
    isAmc = json['is_amc']?.toString();
    amcTermPeriod = json['amc_term_period']?.toString();
    amcStartDate = json['amc_start_date']?.toString();
    amcEndDate = json['amc_end_date']?.toString();
    responsiblePerson =
        json['responsible_person']?.toString();

    expCallCount =
        int.tryParse(
          json['exp_call_count']?.toString() ?? '',
        );

    /// Products
    if (json['customer_products'] != null) {
      customerProducts = <CustomerProduct>[];

      json['customer_products'].forEach((v) {
        customerProducts!.add(
          CustomerProduct.fromJson(v),
        );
      });
    }

    if (json['customer_contacts'] != null) {
      customerContacts = (json['customer_contacts'] as List)
          .map((e) => CustomerContact.fromJson(e))
          .toList();
    }

    if (json['contact_persons'] != null) {
      contactPersons = (json['contact_persons'] as List)
          .map((e) => CustomerContact.fromJson(e))
          .toList();
    }
  }
}

class Pagination {
  int? totalPages;

  Pagination.fromJson(Map<String, dynamic> json) {
    totalPages = json['totalPages'];
  }
}