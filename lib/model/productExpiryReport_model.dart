class ProductExpiryReportModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<ProductExpData>? data;
  Summary? summary;
  Pagination? pagination;
  Filters? filters;

  ProductExpiryReportModel(
      {this.success,
        this.code,
        this.type,
        this.message,
        this.data,
        this.summary,
        this.pagination,
        this.filters});

  ProductExpiryReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductExpData>[];
      json['data'].forEach((v) {
        data!.add(new ProductExpData.fromJson(v));
      });
    }
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    filters =
    json['filters'] != null ? new Filters.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['type'] = this.type;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.filters != null) {
      data['filters'] = this.filters!.toJson();
    }
    return data;
  }
}

class ProductExpData {
  int? customerId;
  String? customerName;
  String? contactPerson;
  String? email;
  String? mobileNo;
  int? companyId;
  String? companyName;
  String? productId;
  String? productName;
  String? serialNumber;
  String? expiryDate;
  int? daysLeft;
  String? expiryStatus;
  List<String>? addOns;

  ProductExpData(
      {this.customerId,
        this.customerName,
        this.contactPerson,
        this.email,
        this.mobileNo,
        this.companyId,
        this.companyName,
        this.productId,
        this.productName,
        this.serialNumber,
        this.expiryDate,
        this.daysLeft,
        this.expiryStatus,
        this.addOns});

  ProductExpData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    contactPerson = json['contact_person'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    productId = json['product_id'];
    productName = json['product_name'];
    serialNumber = json['serial_number'];
    expiryDate = json['expiry_date'];
    daysLeft = json['days_left'];
    expiryStatus = json['expiry_status'];
    addOns = json['add_ons'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['contact_person'] = this.contactPerson;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['serial_number'] = this.serialNumber;
    data['expiry_date'] = this.expiryDate;
    data['days_left'] = this.daysLeft;
    data['expiry_status'] = this.expiryStatus;
    data['add_ons'] = this.addOns;
    return data;
  }
}

class Summary {
  int? total;
  int? expired;
  int? expiringSoon;
  int? valid;

  Summary({this.total, this.expired, this.expiringSoon, this.valid});

  Summary.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    expired = json['expired'];
    expiringSoon = json['expiring_soon'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['expired'] = this.expired;
    data['expiring_soon'] = this.expiringSoon;
    data['valid'] = this.valid;
    return data;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({this.total, this.page, this.limit, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class Filters {
  String? searchText;
  String? companyId;
  String? customerId;
  String? productId;
  String? expiryStatus;
  String? fromDate;
  String? toDate;
  int? expiringDays;
  String? orderBy;
  String? order;

  Filters(
      {this.searchText,
        this.companyId,
        this.customerId,
        this.productId,
        this.expiryStatus,
        this.fromDate,
        this.toDate,
        this.expiringDays,
        this.orderBy,
        this.order});

  Filters.fromJson(Map<String, dynamic> json) {
    searchText = json['searchText'];
    companyId = json['company_id'];
    customerId = json['customer_id'];
    productId = json['product_id'];
    expiryStatus = json['expiry_status'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    expiringDays = json['expiring_days'];
    orderBy = json['orderBy'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchText'] = this.searchText;
    data['company_id'] = this.companyId;
    data['customer_id'] = this.customerId;
    data['product_id'] = this.productId;
    data['expiry_status'] = this.expiryStatus;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['expiring_days'] = this.expiringDays;
    data['orderBy'] = this.orderBy;
    data['order'] = this.order;
    return data;
  }
}
