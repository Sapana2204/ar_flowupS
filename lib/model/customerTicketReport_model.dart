class CustomerTicketReportModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  Data? data;

  CustomerTicketReportModel({
    this.success,
    this.code,
    this.type,
    this.message,
    this.data,
  });

  CustomerTicketReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'type': type,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  Customer? customer;
  List<Product>? products;
  List<Ticket>? tickets;
  Summary? summary;
  Filters? filters;

  Data({
    this.customer,
    this.products,
    this.tickets,
    this.summary,
    this.filters,
  });

  Data.fromJson(Map<String, dynamic> json) {
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;

    products =
        (json['products'] as List?)?.map((e) => Product.fromJson(e)).toList() ??
            [];

    tickets =
        (json['tickets'] as List?)?.map((e) => Ticket.fromJson(e)).toList() ??
            [];

    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;

    filters =
        json['filters'] != null ? Filters.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'customer': customer?.toJson(),
      'products': products?.map((e) => e.toJson()).toList(),
      'tickets': tickets?.map((e) => e.toJson()).toList(),
      'summary': summary?.toJson(),
      'filters': filters?.toJson(),
    };
  }
}

class Customer {
  int? customerId;
  String? name;
  String? email;
  String? mobileNo;
  String? waNo;
  String? contactPerson;
  String? companyName;
  int? companyId;
  String? isAmc;
  String? amcStartDate;
  String? amcEndDate;
  List<Product>? customerProducts;
  String? createdDate;

  Customer({
    this.customerId,
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
    this.createdDate,
  });

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

    customerProducts = (json['customer_products'] as List?)
            ?.map((e) => Product.fromJson(e))
            .toList() ??
        [];

    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'name': name,
      'email': email,
      'mobile_no': mobileNo,
      'wa_no': waNo,
      'contact_person': contactPerson,
      'company_name': companyName,
      'company_id': companyId,
      'is_amc': isAmc,
      'amc_start_date': amcStartDate,
      'amc_end_date': amcEndDate,
      'customer_products': customerProducts?.map((e) => e.toJson()).toList(),
      'created_date': createdDate,
    };
  }
}

class Product {
  String? productId;
  String? productName;
  String? serialNumber;
  String? expiryDate;
  List<String>? addOns;

  Product({
    this.productId,
    this.productName,
    this.serialNumber,
    this.expiryDate,
    this.addOns,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toString();
    productName = json['product_name'];
    serialNumber = json['serial_number'];
    expiryDate = json['expiry_date'];
    addOns = json['add_ons'] != null
        ? List<String>.from(json['add_ons'])
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'serial_number': serialNumber,
      'expiry_date': expiryDate,
      'add_ons': addOns,
    };
  }
}

class Ticket {
  int? ticketId;
  String? ticketNo;
  String? description;
  String? createdDate;
  String? startDate;
  String? dueDate;
  String? contactPerson;
  String? contactNo;

  String? productSerialNumber;
  String? productName;

  int? modifiedBy;

  String? ticketStatus;
  String? ticketPriority;
  String? queryType;
  String? assigneeName;
  String? resolverName;
  String? resolutionTime;

  Ticket({
    this.ticketId,
    this.ticketNo,
    this.description,
    this.createdDate,
    this.startDate,
    this.dueDate,
    this.contactPerson,
    this.contactNo,
    this.productSerialNumber,
    this.productName,
    this.modifiedBy,
    this.ticketStatus,
    this.ticketPriority,
    this.queryType,
    this.assigneeName,
    this.resolverName,
    this.resolutionTime,
  });

  Ticket.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    ticketNo = json['ticket_no'];
    description = json['description'];
    createdDate = json['created_date'];
    startDate = json['start_date'];
    dueDate = json['due_date'];
    contactPerson = json['contact_person'];
    contactNo = json['contact_no'];

    productSerialNumber = json['product_serial_number'];
    productName = json['product_name'];

    modifiedBy = json['modified_by'];

    ticketStatus = json['ticket_status'];
    ticketPriority = json['ticket_priority'];
    queryType = json['query_type'];
    assigneeName = json['assignee_name'];
    resolverName = json['resolver_name'];
    resolutionTime = json['resolution_time']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_id': ticketId,
      'ticket_no': ticketNo,
      'description': description,
      'created_date': createdDate,
      'start_date': startDate,
      'due_date': dueDate,
      'contact_person': contactPerson,
      'contact_no': contactNo,
      'product_serial_number': productSerialNumber,
      'product_name': productName,
      'modified_by': modifiedBy,
      'ticket_status': ticketStatus,
      'ticket_priority': ticketPriority,
      'query_type': queryType,
      'assignee_name': assigneeName,
      'resolver_name': resolverName,
      'resolution_time': resolutionTime,
    };
  }
}

class Summary {
  int? total;
  int? resolved;
  int? pending;
  int? overdue;

  Summary({
    this.total,
    this.resolved,
    this.pending,
    this.overdue,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    resolved = json['resolved'];
    pending = json['pending'];
    overdue = json['overdue'];
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'resolved': resolved,
      'pending': pending,
      'overdue': overdue,
    };
  }
}

class Filters {
  String? customerId;
  String? fromDate;

  Filters({
    this.customerId,
    this.fromDate,
  });

  Filters.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id']?.toString();
    fromDate = json['from_date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'from_date': fromDate,
    };
  }
}
