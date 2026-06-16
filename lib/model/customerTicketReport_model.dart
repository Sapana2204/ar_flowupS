class CustomerTicketReportModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  Data? data;

  CustomerTicketReportModel(
      {this.success, this.code, this.type, this.message, this.data});

  CustomerTicketReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['type'] = this.type;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Customer? customer;
  List<dynamic>? products;
  List<dynamic>? tickets;
  Summary? summary;
  Filters? filters;

  Data(
      {this.customer, this.products, this.summary, this.tickets, this.filters});

  Data.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    if (json['products'] != null) {
      products = <Null>[];
      json['products'].forEach((v) {
        products = json['products'];
      });
    }
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    if (json['tickets'] != null) {
      tickets = <Null>[];
      json['tickets'].forEach((v) {
        tickets = json['tickets'];      });
    }
    filters =
    json['filters'] != null ? new Filters.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.tickets != null) {
      data['tickets'] = this.tickets!.map((v) => v.toJson()).toList();
    }
    if (this.filters != null) {
      data['filters'] = this.filters!.toJson();
    }
    return data;
  }
}

class Customer {
  int? customerId;
  String? name;
  String? email;
  String? mobileNo;
  String? waNo;
  String? contactPerson;
  int? companyId;
  String? isAmc;
  String? companyName;
  String? amcStartDate;
  String? amcEndDate;
  List<dynamic>? customerProducts;
  String? createdDate;

  Customer(
      {this.customerId,
        this.name,
        this.email,
        this.mobileNo,
        this.waNo,
        this.contactPerson,
        this.companyName,
        this.companyId,
        this.isAmc,
        this.amcStartDate,
        this.amcEndDate,
        this.customerProducts,
        this.createdDate});

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    waNo = json['wa_no'];
    contactPerson = json['contact_person'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    isAmc = json['is_amc'];
    amcStartDate = json['amc_start_date'];
    amcEndDate = json['amc_end_date'];
    customerProducts = json['customer_products'] ?? [];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['wa_no'] = this.waNo;
    data['contact_person'] = this.contactPerson;
    data['company_name'] = this.companyName;
    data['company_id'] = this.companyId;
    data['is_amc'] = this.isAmc;
    data['amc_start_date'] = this.amcStartDate;
    data['amc_end_date'] = this.amcEndDate;
    if (this.customerProducts != null) {
      data['customer_products'] =
          this.customerProducts!.map((v) => v.toJson()).toList();
    }
    data['created_date'] = this.createdDate;
    return data;
  }
}

class Summary {
  int? total;
  int? resolved;
  int? pending;
  int? overdue;

  Summary({this.total, this.resolved, this.pending, this.overdue});

  Summary.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    resolved = json['resolved'];
    pending = json['pending'];
    overdue = json['overdue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['resolved'] = this.resolved;
    data['pending'] = this.pending;
    data['overdue'] = this.overdue;
    return data;
  }
}

class Filters {
  String? customerId;
  String? fromDate;

  Filters({this.customerId, this.fromDate});

  Filters.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    fromDate = json['from_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['from_date'] = this.fromDate;
    return data;
  }
}
