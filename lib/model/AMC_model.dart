class AMCModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<Data>? data;
  Pagination? pagination;

  AMCModel(
      {this.success,
        this.code,
        this.type,
        this.message,
        this.data,
        this.pagination});

  AMCModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
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
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Data {
  int? customerId;
  String? name;
  String? email;
  String? mobileNo;
  String? contactPerson;
  String? companyName;
  int? companyId;
  String? isAmc;
  String? amcTermPeriod;
  String? amcStartDate;
  String? amcEndDate;
  int? expCallCount;
  int? expectedCallCount;
  int? daysUntilExpiry;
  int? supportCallCount;
  int? doneAmcCallCount;
  int? remainingCallCount;
  int? amcTicketCount;
  int? amcVisitScheduledCount;
  int? amcVisitedCount;
  Null? lastReminderSentAt;
  int? reminderCount;
  Null? lastReminderIncludeReport;
  int? sentToday;

  Data(
      {this.customerId,
        this.name,
        this.email,
        this.mobileNo,
        this.contactPerson,
        this.companyName,
        this.companyId,
        this.isAmc,
        this.amcTermPeriod,
        this.amcStartDate,
        this.amcEndDate,
        this.expCallCount,
        this.expectedCallCount,
        this.daysUntilExpiry,
        this.supportCallCount,
        this.doneAmcCallCount,
        this.remainingCallCount,
        this.amcTicketCount,
        this.amcVisitScheduledCount,
        this.amcVisitedCount,
        this.lastReminderSentAt,
        this.reminderCount,
        this.lastReminderIncludeReport,
        this.sentToday});

  Data.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    contactPerson = json['contact_person'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    isAmc = json['is_amc'];
    amcTermPeriod = json['amc_term_period'];
    amcStartDate = json['amc_start_date'];
    amcEndDate = json['amc_end_date'];
    expCallCount = json['exp_call_count'];
    expectedCallCount = json['expected_call_count'];
    daysUntilExpiry = json['days_until_expiry'];
    supportCallCount = json['support_call_count'];
    doneAmcCallCount = json['done_amc_call_count'];
    remainingCallCount = json['remaining_call_count'];
    amcTicketCount = json['amc_ticket_count'];
    amcVisitScheduledCount = json['amc_visit_scheduled_count'];
    amcVisitedCount = json['amc_visited_count'];
    lastReminderSentAt = json['last_reminder_sent_at'];
    reminderCount = json['reminder_count'];
    lastReminderIncludeReport = json['last_reminder_include_report'];
    sentToday = json['sent_today'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['contact_person'] = this.contactPerson;
    data['company_name'] = this.companyName;
    data['company_id'] = this.companyId;
    data['is_amc'] = this.isAmc;
    data['amc_term_period'] = this.amcTermPeriod;
    data['amc_start_date'] = this.amcStartDate;
    data['amc_end_date'] = this.amcEndDate;
    data['exp_call_count'] = this.expCallCount;
    data['expected_call_count'] = this.expectedCallCount;
    data['days_until_expiry'] = this.daysUntilExpiry;
    data['support_call_count'] = this.supportCallCount;
    data['done_amc_call_count'] = this.doneAmcCallCount;
    data['remaining_call_count'] = this.remainingCallCount;
    data['amc_ticket_count'] = this.amcTicketCount;
    data['amc_visit_scheduled_count'] = this.amcVisitScheduledCount;
    data['amc_visited_count'] = this.amcVisitedCount;
    data['last_reminder_sent_at'] = this.lastReminderSentAt;
    data['reminder_count'] = this.reminderCount;
    data['last_reminder_include_report'] = this.lastReminderIncludeReport;
    data['sent_today'] = this.sentToday;
    return data;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  int? start;
  int? end;

  Pagination(
      {this.total,
        this.page,
        this.limit,
        this.totalPages,
        this.start,
        this.end});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalPages'] = this.totalPages;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
