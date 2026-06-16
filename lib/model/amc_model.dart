class AMCModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<AMCData>? data;
  Pagination? pagination;

  AMCModel({
    this.success,
    this.code,
    this.type,
    this.message,
    this.data,
    this.pagination,
  });

  AMCModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];

    if (json['data'] != null) {
      data = <AMCData>[];
      json['data'].forEach((v) {
        data!.add(AMCData.fromJson(v));
      });
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['success'] = success;
    json['code'] = code;
    json['type'] = type;
    json['message'] = message;

    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }

    if (pagination != null) {
      json['pagination'] = pagination!.toJson();
    }

    return json;
  }
}

class AMCData {
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
  dynamic lastReminderSentAt;
  int? reminderCount;
  dynamic lastReminderIncludeReport;
  int? sentToday;

  AMCData({
    this.customerId,
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
    this.sentToday,
  });

  AMCData.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> json = {};

    json['customer_id'] = customerId;
    json['name'] = name;
    json['email'] = email;
    json['mobile_no'] = mobileNo;
    json['contact_person'] = contactPerson;
    json['company_name'] = companyName;
    json['company_id'] = companyId;
    json['is_amc'] = isAmc;
    json['amc_term_period'] = amcTermPeriod;
    json['amc_start_date'] = amcStartDate;
    json['amc_end_date'] = amcEndDate;
    json['exp_call_count'] = expCallCount;
    json['expected_call_count'] = expectedCallCount;
    json['days_until_expiry'] = daysUntilExpiry;
    json['support_call_count'] = supportCallCount;
    json['done_amc_call_count'] = doneAmcCallCount;
    json['remaining_call_count'] = remainingCallCount;
    json['amc_ticket_count'] = amcTicketCount;
    json['amc_visit_scheduled_count'] = amcVisitScheduledCount;
    json['amc_visited_count'] = amcVisitedCount;
    json['last_reminder_sent_at'] = lastReminderSentAt;
    json['reminder_count'] = reminderCount;
    json['last_reminder_include_report'] = lastReminderIncludeReport;
    json['sent_today'] = sentToday;

    return json;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  int? start;
  int? end;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.start,
    this.end,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['total'] = total;
    json['page'] = page;
    json['limit'] = limit;
    json['totalPages'] = totalPages;
    json['start'] = start;
    json['end'] = end;

    return json;
  }
}