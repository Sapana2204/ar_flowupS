class WorkReportModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<Data>? data;
  Summary? summary;
  List<CompanySummary>? companySummary;
  Pagination? pagination;

  WorkReportModel(
      {this.success,
        this.code,
        this.type,
        this.message,
        this.data,
        this.summary,
        this.companySummary,
        this.pagination});

  WorkReportModel.fromJson(Map<String, dynamic> json) {
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
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    if (json['company_summary'] != null) {
      companySummary = <CompanySummary>[];
      json['company_summary'].forEach((v) {
        companySummary!.add(new CompanySummary.fromJson(v));
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
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.companySummary != null) {
      data['company_summary'] =
          this.companySummary!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Data {
  int? workLogId;
  int? ticketId;
  int? employeeId;
  int? companyId;
  String? workStartAt;
  int? spentMinutes;
  String? workDetails;
  String? workStatus;
  String? createdDate;
  String? workDate;
  String? workTime;
  String? ticketNo;
  int? expectedMinutes;
  String? clientName;
  String? employeeName;
  String? companyName;

  Data(
      {this.workLogId,
        this.ticketId,
        this.employeeId,
        this.companyId,
        this.workStartAt,
        this.spentMinutes,
        this.workDetails,
        this.workStatus,
        this.createdDate,
        this.workDate,
        this.workTime,
        this.ticketNo,
        this.expectedMinutes,
        this.clientName,
        this.employeeName,
        this.companyName});

  Data.fromJson(Map<String, dynamic> json) {
    workLogId = json['work_log_id'];
    ticketId = json['ticket_id'];
    employeeId = json['employee_id'];
    companyId = json['company_id'];
    workStartAt = json['work_start_at'];
    spentMinutes = json['spent_minutes'];
    workDetails = json['work_details'];
    workStatus = json['work_status'];
    createdDate = json['created_date'];
    workDate = json['work_date'];
    workTime = json['work_time'];
    ticketNo = json['ticket_no'];
    expectedMinutes = json['expected_minutes'];
    clientName = json['client_name'];
    employeeName = json['employee_name'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['work_log_id'] = this.workLogId;
    data['ticket_id'] = this.ticketId;
    data['employee_id'] = this.employeeId;
    data['company_id'] = this.companyId;
    data['work_start_at'] = this.workStartAt;
    data['spent_minutes'] = this.spentMinutes;
    data['work_details'] = this.workDetails;
    data['work_status'] = this.workStatus;
    data['created_date'] = this.createdDate;
    data['work_date'] = this.workDate;
    data['work_time'] = this.workTime;
    data['ticket_no'] = this.ticketNo;
    data['expected_minutes'] = this.expectedMinutes;
    data['client_name'] = this.clientName;
    data['employee_name'] = this.employeeName;
    data['company_name'] = this.companyName;
    return data;
  }
}

class Summary {
  int? totalLogs;
  String? totalMinutes;
  int? employeeCount;
  int? ticketCount;

  Summary(
      {this.totalLogs,
        this.totalMinutes,
        this.employeeCount,
        this.ticketCount});

  Summary.fromJson(Map<String, dynamic> json) {
    totalLogs = json['total_logs'];
    totalMinutes = json['total_minutes'];
    employeeCount = json['employee_count'];
    ticketCount = json['ticket_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_logs'] = this.totalLogs;
    data['total_minutes'] = this.totalMinutes;
    data['employee_count'] = this.employeeCount;
    data['ticket_count'] = this.ticketCount;
    return data;
  }
}

class CompanySummary {
  int? companyId;
  String? companyName;
  int? totalLogs;
  String? totalMinutes;

  CompanySummary(
      {this.companyId, this.companyName, this.totalLogs, this.totalMinutes});

  CompanySummary.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    companyName = json['company_name'];
    totalLogs = json['total_logs'];
    totalMinutes = json['total_minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['total_logs'] = this.totalLogs;
    data['total_minutes'] = this.totalMinutes;
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
