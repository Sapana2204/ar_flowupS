class AMCActivityModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  Customer? customer;
  List<dynamic>? calls;
  List<Visits>? visits;
  List<Reminders>? reminders;
  Counts? counts;

  AMCActivityModel(
      {this.success,
        this.code,
        this.type,
        this.message,
        this.customer,
        this.calls,
        this.visits,
        this.reminders,
        this.counts});

  AMCActivityModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    if (json['calls'] != null) {
      calls = <Null>[];
      json['calls'].forEach((v) {
        calls = json['calls'];
      });
    }
    if (json['visits'] != null) {
      visits = <Visits>[];
      json['visits'].forEach((v) {
        visits!.add(new Visits.fromJson(v));
      });
    }
    if (json['reminders'] != null) {
      reminders = <Reminders>[];
      json['reminders'].forEach((v) {
        reminders!.add(new Reminders.fromJson(v));
      });
    }
    counts =
    json['counts'] != null ? new Counts.fromJson(json['counts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['type'] = this.type;
    data['message'] = this.message;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.calls != null) {
      data['calls'] = this.calls!.map((v) => v.toJson()).toList();
    }
    if (this.visits != null) {
      data['visits'] = this.visits!.map((v) => v.toJson()).toList();
    }
    if (this.reminders != null) {
      data['reminders'] = this.reminders!.map((v) => v.toJson()).toList();
    }
    if (this.counts != null) {
      data['counts'] = this.counts!.toJson();
    }
    return data;
  }
}

class Customer {
  int? customerId;
  String? name;
  String? email;
  String? mobileNo;
  Null? companyName;
  int? companyId;
  String? isAmc;

  Customer(
      {this.customerId,
        this.name,
        this.email,
        this.mobileNo,
        this.companyName,
        this.companyId,
        this.isAmc});

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    isAmc = json['is_amc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['company_name'] = this.companyName;
    data['company_id'] = this.companyId;
    data['is_amc'] = this.isAmc;
    return data;
  }
}

class Visits {
  int? visitId;
  int? ticketId;
  String? ticketNo;
  String? visitScheduledAt;
  Null? visitedAt;
  String? visitDetails;
  String? visitStatus;
  String? createdDate;
  String? employeeName;

  Visits(
      {this.visitId,
        this.ticketId,
        this.ticketNo,
        this.visitScheduledAt,
        this.visitedAt,
        this.visitDetails,
        this.visitStatus,
        this.createdDate,
        this.employeeName});

  Visits.fromJson(Map<String, dynamic> json) {
    visitId = json['visit_id'];
    ticketId = json['ticket_id'];
    ticketNo = json['ticket_no'];
    visitScheduledAt = json['visit_scheduled_at'];
    visitedAt = json['visited_at'];
    visitDetails = json['visit_details'];
    visitStatus = json['visit_status'];
    createdDate = json['created_date'];
    employeeName = json['employee_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visit_id'] = this.visitId;
    data['ticket_id'] = this.ticketId;
    data['ticket_no'] = this.ticketNo;
    data['visit_scheduled_at'] = this.visitScheduledAt;
    data['visited_at'] = this.visitedAt;
    data['visit_details'] = this.visitDetails;
    data['visit_status'] = this.visitStatus;
    data['created_date'] = this.createdDate;
    data['employee_name'] = this.employeeName;
    return data;
  }
}

class Reminders {
  int? reminderId;
  String? sentAt;
  String? includeReport;
  String? recipientEmail;
  String? emailSubject;
  String? status;
  Null? errorMessage;

  Reminders(
      {this.reminderId,
        this.sentAt,
        this.includeReport,
        this.recipientEmail,
        this.emailSubject,
        this.status,
        this.errorMessage});

  Reminders.fromJson(Map<String, dynamic> json) {
    reminderId = json['reminder_id'];
    sentAt = json['sent_at'];
    includeReport = json['include_report'];
    recipientEmail = json['recipient_email'];
    emailSubject = json['email_subject'];
    status = json['status'];
    errorMessage = json['error_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reminder_id'] = this.reminderId;
    data['sent_at'] = this.sentAt;
    data['include_report'] = this.includeReport;
    data['recipient_email'] = this.recipientEmail;
    data['email_subject'] = this.emailSubject;
    data['status'] = this.status;
    data['error_message'] = this.errorMessage;
    return data;
  }
}

class Counts {
  int? calls;
  int? visits;
  int? visited;
  int? reminders;

  Counts({this.calls, this.visits, this.visited, this.reminders});

  Counts.fromJson(Map<String, dynamic> json) {
    calls = json['calls'];
    visits = json['visits'];
    visited = json['visited'];
    reminders = json['reminders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calls'] = this.calls;
    data['visits'] = this.visits;
    data['visited'] = this.visited;
    data['reminders'] = this.reminders;
    return data;
  }
}
